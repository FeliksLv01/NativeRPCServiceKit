//
//  NativeRPCServiceCall.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/15.
//

import Foundation

@objc
public extension NativeRPCServiceCall {
    func resolve(_ data: [String: Any]?) {
        successHandler(data)
    }
    
    func reject(_ code: NativeRPCResponseCode, _ message: String?) {
        errorHandler(NativeRPCError(code: code, message: message))
    }
}
