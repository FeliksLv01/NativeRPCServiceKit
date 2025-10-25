//
//  NativeRPCLogger.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

import Foundation

// MARK: - Log Level

public enum NativeRPCLogLevel: CaseIterable {
    case debug, info, warning, error
}

// MARK: - Logger Protocol
public protocol NativeRPCLogger {
    func log(
        _ level: NativeRPCLogLevel, _ message: @autoclosure () -> String, file: String, function: String, line: Int)
}

// MARK: - Log Manager
typealias NativeRPCLog = NativeRPCLogManager

public enum NativeRPCLogManager {
    private static var logger: NativeRPCLogger = DefaultNativeRPCLogger()

    public static func setLogger(_ logger: NativeRPCLogger) {
        Self.logger = logger
    }

    static func debug(
        _ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.log(.debug, message(), file: file, function: function, line: line)
    }

    static func info(
        _ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.log(.info, message(), file: file, function: function, line: line)
    }

    static func warning(
        _ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.log(.warning, message(), file: file, function: function, line: line)
    }

    static func error(
        _ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        logger.log(.error, message(), file: file, function: function, line: line)
    }
}
