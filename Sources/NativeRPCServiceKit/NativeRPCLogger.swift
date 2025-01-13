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
