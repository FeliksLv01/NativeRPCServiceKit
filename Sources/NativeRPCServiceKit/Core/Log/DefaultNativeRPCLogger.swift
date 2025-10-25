//
//  DefaultNativeRPCLogger.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/10/25.
//

import Foundation

// MARK: - Default Logger Implementation

public struct DefaultNativeRPCLogger: NativeRPCLogger {
    private let minLevel: NativeRPCLogLevel
    private let dateFormatter: DateFormatter
    
    public init(minLevel: NativeRPCLogLevel = .debug) {
        self.minLevel = minLevel
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    public func log(
        _ level: NativeRPCLogLevel,
        _ message: @autoclosure () -> String,
        file: String,
        function: String,
        line: Int
    ) {
        // 检查日志级别是否达到最小要求
        guard shouldLog(level: level) else { return }
        
        // 格式化输出
        let timestamp = dateFormatter.string(from: Date())
        let levelIcon = level.icon
        let messageText = message()
        
        let logEntry = "[\(timestamp)] \(levelIcon) [\(file):\(line)] \(function) > \(messageText)"
        
        // 根据级别选择适当的输出方式
        switch level {
        case .debug, .info:
            print(logEntry)
        case .warning:
            print("⚠️ " + logEntry)
        case .error:
            print("❌ " + logEntry)
        }
    }
    
    private func shouldLog(level: NativeRPCLogLevel) -> Bool {
        let allLevels = NativeRPCLogLevel.allCases
        let minIndex = allLevels.firstIndex(of: minLevel) ?? 0
        let levelIndex = allLevels.firstIndex(of: level) ?? 0
        return levelIndex >= minIndex
    }
}

// MARK: - Helper Extensions

extension NativeRPCLogLevel {
    var icon: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
    
    var description: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}
