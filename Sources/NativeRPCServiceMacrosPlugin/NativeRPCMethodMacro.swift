import SwiftSyntax
import SwiftSyntaxMacros

public struct NativeRPCMethodExportMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return []
    }
}

public struct NativeRPCMethodMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 确保宏应用于方法
        guard let methodDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("The @NativeRPCMethod macro can only be applied to methods.")
        }

        // 解析宏参数
        let generatedMethodName: String
        if case .argumentList(let arguments) = node.arguments,
           let nameArgument = arguments.first(where: { $0.label?.text == "name" }),
           let nameValue = nameArgument.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text {
            generatedMethodName = nameValue
        } else {
            // 如果没有提供 name 参数，默认使用方法名
            generatedMethodName = methodDecl.name.text
        }

        let parameters = methodDecl.signature.parameterClause.parameters
        let returnType = methodDecl.signature.returnClause?.type.description ?? "Void"
        
        let isThrowing = methodDecl.signature.effectSpecifiers?.throwsSpecifier != nil

        // 生成 NativeRPCServiceCall 兼容方法
        let generatedMethod = """
        public func \(generatedMethodName)(_ call: NativeRPCServiceCall) {
            let rpcCallParams = call.params ?? [:]
            \(generateMethodCall(methodName: methodDecl.name.text, parameters: parameters, returnType: returnType, isThrowing: isThrowing))
        }
        """

        return [DeclSyntax(stringLiteral: generatedMethod)]
    }

    /// 生成方法调用的代码片段。
    private static func generateMethodCall(methodName: String, parameters: FunctionParameterListSyntax, returnType: String, isThrowing: Bool) -> String {
        var callParams = [String]()
        for param in parameters {
            // 处理匿名参数名（例如 `post(_ name: String)`）
            let paramName = param.secondName?.text ?? param.firstName.text
            let paramType = param.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
            let isOptional = paramType.hasSuffix("?") || paramType.hasPrefix("Optional<")

            if isOptional {
                // 可空类型：提取实际类型
                let actualType = paramType.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "Optional<", with: "").replacingOccurrences(of: ">", with: "")
                let paramValue = "rpcCallParams[\"\(paramName)\"] as? \(actualType)"
                callParams.append("let \(paramName) = \(paramValue)")
            } else {
                // 非可空类型：使用 guard let
                let paramValue = "rpcCallParams[\"\(paramName)\"] as? \(paramType)"
                callParams.append("""
                guard let \(paramName) = \(paramValue) else {
                \tcall.reject(NativeRPCError.invalidParams("\(paramName) is missing or invalid"))
                \treturn
                }
                """)
            }
        }
        
        let methodCallParamsStr = parameters.map { param in
            let externalName = param.firstName.text
            let internalName = param.secondName?.text ?? param.firstName.text
            if externalName != "_" {
                return "\(externalName): \(internalName)"
            } else {
                return internalName
            }
        }.joined(separator: ", ")
        
        // 生成方法调用
        if returnType == "Void" {
            var methodCall = "self.\(methodName)(\(methodCallParamsStr))"
            
            if isThrowing {
                methodCall = "try \(methodCall)"
            }
            
            return """
            do {
                \(callParams.joined(separator: "\n"))
                \(methodCall)
                call.resolve()
            } catch {
                if let error = error as? NativeRPCError {
                    call.reject(error)
                } else {
                    call.reject(NativeRPCError.userDefined(error.localizedDescription))
                }
            }
            """
        }
        
        var methodCall = "let rpcMethodResult = self.\(methodName)(\(methodCallParamsStr))"
        
        if isThrowing {
            methodCall = "let rpcMethodResult = try self.\(methodName)(\(methodCallParamsStr))"
        }
        return """
            do {
                \(callParams.joined(separator: "\n"))
                \(methodCall)
                call.resolve(["result": rpcMethodResult])
            } catch {
                if let error = error as? NativeRPCError {
                    call.reject(error)
                } else {
                    call.reject(NativeRPCError.userDefined(error.localizedDescription))
                }
            }
            """
    }
}
