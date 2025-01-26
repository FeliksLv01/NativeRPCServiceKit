//
//  NativeRPCServiceMacrosPlugin.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/26.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftCompilerPlugin


@main
struct NativeRPCServiceMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NativeRPCServiceMacro.self,
        NativeRPCMethodMacro.self,
        NativeRPCMethodExportMacro.self
    ]
}
