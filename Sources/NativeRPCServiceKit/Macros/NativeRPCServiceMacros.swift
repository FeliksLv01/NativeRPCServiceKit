//
//  NativeRPCServiceMacros.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/26.
//

/// A macro that auto implements the `NativeRPCService` protocol.
/// source code that generated the value. For example,
///
/// @NativeRPCService("my", options: .all)
/// class MyService {}
///
/// expand
///
@attached(extension, conformances: NativeRPCService, names: arbitrary)
public macro NativeRPCService(_ name: String, options: NativeRPCConnectionTypeOptions = .all) = #externalMacro(module: "NativeRPCServiceMacrosPlugin", type: "NativeRPCServiceMacro")


@attached(peer, names: arbitrary)
public macro NativeRPCMethod(_ name: String? = nil) = #externalMacro(module: "NativeRPCServiceMacrosPlugin", type: "NativeRPCMethodMacro")

@attached(peer, names: arbitrary)
public macro NativeRPCMethodExport() = #externalMacro(module: "NativeRPCServiceMacrosPlugin", type: "NativeRPCMethodExportMacro")
