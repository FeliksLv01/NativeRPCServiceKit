//
//  NativeRPCServiceMacro.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/26.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NativeRPCServiceMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // 确保宏只能应用于类
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("The @NativeRPCService macro can only be applied to classes.")
        }
        
        // 确保宏有参数，提取第一个参数（name）
        guard case .argumentList(let arguments) = node.arguments, !arguments.isEmpty,
              let name = arguments.first?.expression
        else {
            context.addDiagnostics(
                from: MacroExpansionErrorMessage("This macro requires at least one argument."),
                node: node
            )
            return []
        }
        
        // 提取第二个参数（connectionType），默认为 `.all`
        let connectionType: ExprSyntax
        if arguments.count == 2, let connectionTypeArg = arguments.last {
            connectionType = connectionTypeArg.expression
        } else {
            connectionType = ExprSyntax(stringLiteral: ".all")
        }
        
        // 获取类中所有标记了 @NativeRPCMethod 的方法
        let methods = classDecl.memberBlock.members.compactMap { member -> FunctionDeclSyntax? in
            if let method = member.decl.as(FunctionDeclSyntax.self),
               method.attributes.contains(where: {
                   let description = $0.as(AttributeSyntax.self)?.attributeName.description
                   return description == "NativeRPCMethod" || description == "NativeRPCMethodExport"
               }) {
                return method
            }
            return nil
        }
        
        let containsMethodDecl = """
        public func canHandleMethod(_ method: String) -> Bool {
            switch method {
            \(methods.map { method in
                let methodName = method.name.text
                return """
                case "\(methodName)":
                    return true
                """
            }.joined(separator: "\n"))
            default:
                return false
            }
        }
        """
        
        // 生成 dynamicallyCall(withKeywordArguments:) 方法
        let dynamicCallMethod = """
                public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, NativeRPCServiceCall>) throws -> Void {
                    guard let method = args.first?.key else {
                        throw NativeRPCError.methodNotFound
                    }
                    guard let call = args.first?.value as? NativeRPCServiceCall else {
                        throw NativeRPCError.invalidParams("Error: Invalid call object")
                    }
                
                    switch method {
                    \(methods.map { method in
                        let methodName = method.name.text
                        return """
                        case "\(methodName)":
                            self.\(methodName)(call)
                        """
                    }.joined(separator: "\n"))
                    default:
                        throw NativeRPCError.methodNotFound
                    }
                }
                """
        
        // 生成扩展
        let extensionDecl = try ExtensionDeclSyntax("extension \(type.trimmed): NativeRPCService") {
            DeclSyntax(stringLiteral: "static var name: String = \(name)")
            DeclSyntax(
                stringLiteral:
                    "static var supportedConnectionType: NativeRPCConnectionTypeOptions = \(connectionType)"
            )
            DeclSyntax(stringLiteral: containsMethodDecl)
            DeclSyntax(stringLiteral: dynamicCallMethod)
            DeclSyntax(stringLiteral: "static func createService() -> NativeRPCService { return \(type.trimmed)() }")
        }
        
        
        
        return [extensionDecl]
    }
}
