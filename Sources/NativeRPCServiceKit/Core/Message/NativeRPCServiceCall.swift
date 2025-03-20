//
//  NativeRPCServiceCall.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

public typealias NativeRPCResponseData = [String: Any]

public struct NativeRPCMethodCall<Method: RawRepresentable> where Method.RawValue == String {
    public let context: NativeRPCContext
    public let method: Method
    public let params: [String: Any]?

    init(context: NativeRPCContext, method: Method, params: [String: Any]?) {
        self.context = context
        self.method = method
        self.params = params
    }
}

struct AnyNativeRPCMethodCall {
    public let context: NativeRPCContext
    public let method: String
    public let params: [String: Any]?

    public init(context: NativeRPCContext, method: String, params: [String: Any]?) {
        self.method = method
        self.params = params
        self.context = context
    }
}
