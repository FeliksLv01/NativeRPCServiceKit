//
//  NativeRPCLogger.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

import os

extension OSLog {
    static let rpcLogger = OSLog(subsystem: "logger.itoken.team.native.rpc", category: "main")
}

enum RPCLog {
    static func info(_ message: StaticString, _ args: any CVarArg...) {
        os_log(.info, log: .rpcLogger, message, args)
    }

    static func debug(_ message: @autoclosure () -> StaticString, _ args: any CVarArg...) {
#if DEBUG
        os_log(.debug, log: .rpcLogger, message(), args)
#endif
    }

    static func error(_ message: StaticString, _ args: any CVarArg...) {
        os_log(.error, log: .rpcLogger, message, args)
    }
}
