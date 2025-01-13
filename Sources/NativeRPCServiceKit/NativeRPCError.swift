//
//  NativeRPCError.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

public enum NativeRPCError: Error {
    case invalidMessage
    case invalidParams(String?)
    case serviceNotFound
    case methodNotFound
    case connectionTypeNotSupported
    case unauthorized
    case accessDenied
    case userDefined(String?)
}

extension NativeRPCError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidMessage:
            return "invalid message"
        case .invalidParams(let message):
            return message ?? "Invalid parameters"
        case .serviceNotFound:
            return "Service Not Found"
        case .methodNotFound:
            return "Method Not Found"
        case .connectionTypeNotSupported:
            return "Not Supported Connection Type"
        case .unauthorized:
            return "Unauthorized"
        case .accessDenied:
            return "Access denied"
        case .userDefined(let message):
            return message ?? "Unknown error"
        }
    }
    
    public var errorCode: Int {
        switch self {
        case .invalidMessage:
            return 1001
        case .invalidParams:
            return 1002
        case .serviceNotFound:
            return 1003
        case .methodNotFound:
            return 1004
        case .connectionTypeNotSupported:
            return 1005
        case .unauthorized:
            return 1006
        case .accessDenied:
            return 1007
        case .userDefined:
            return 1008
        }
    }
    
    public static func from(_ error: Error) -> Self {
        guard let error = error as? NativeRPCError else {
            return .userDefined(error.localizedDescription)
        }
        return error
    }
}
