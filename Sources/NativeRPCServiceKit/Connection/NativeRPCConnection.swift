//
//  NativeRPCConnection.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation
import CocoaLumberjackSwift

/// Native RPC 连接，连接是复用的，一次连接可以传输多个数据
open class NativeRPCConnection: NativeRPCStubDelegate {
    public let context: NativeRPCContext
    private var stub: NativeRPCStub?
    
    public var enableLog: Bool = false
    
    public init(context: NativeRPCContext) {
        self.context = context
    }
    
    public func start() {
        if enableLog {
            DDLogInfo("[RPC]: Connection Start")
        }
        stub = NativeRPCStub(context: context)
        stub?.delegate = self
    }
    
    public func close() {
        if enableLog {
            DDLogInfo("[RPC]: Connection Close")
        }
        stub?.delegate = nil
        stub = nil
    }
    
    public func onReceiveMessage(_ message: [String: Any]) {
        guard let request = NativeRPCRequest(from: message) else {
            DDLogError("[RPC]: invalid message: \(message)")
            return
        }
        
        if enableLog {
            DDLogInfo("[RPC]: receive => \(message)")
        }

        do {
            try stub?.onReceiveMessage(request)
        } catch {
            let response = NativeRPCResponse(for: request, error: NativeRPCError.from(error))
            sendMessage(response.jsonObject)
            
            DDLogError("[RPC]: Error \(response.jsonObject.jsonString ?? "response to json failed")")
        }
    }
    
    public func sendMessage(_ message: [String: Any]) {
        if enableLog {
            DDLogInfo("[RPC]: send => \(message)")
        }
    }
}
