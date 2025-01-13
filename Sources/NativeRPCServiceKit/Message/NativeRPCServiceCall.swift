//
//  NativeRPCServiceCall.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

public typealias NativeRPCResponseData = [String: Any]
public typealias NativeRPCServiceCallCompletion = (Result<NativeRPCResponseData?, NativeRPCError>) -> Void

@objc
public class NativeRPCServiceCall: NSObject {
    let completion: NativeRPCServiceCallCompletion
    public let params: [String: Any]?
    public let context: NativeRPCContext

    init(context: NativeRPCContext, params: [String: Any]?, completion: @escaping NativeRPCServiceCallCompletion) {
        self.context = context
        self.params = params
        self.completion = completion
    }
    
    public func resolve(_ data: NativeRPCResponseData? = nil) {
        completion(.success(data))
    }
    
    public func reject(_ error: NativeRPCError) {
        completion(.failure(error))
    }
}
