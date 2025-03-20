//
//  NativeRPCConnection.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

/// Native RPC 连接，连接是复用的，一次连接可以传输多个数据
open class NativeRPCConnection: NativeRPCStubDelegate {
    public let context: NativeRPCContext
    private var stub: NativeRPCStub?

    public init(context: NativeRPCContext) {
        self.context = context
    }

    public func start() {
        stub = NativeRPCStub(context: context)
        stub?.delegate = self
        RPCLog.debug("[RPC]: Connection Start")
    }

    public func close() {
        stub?.delegate = nil
        stub = nil
        RPCLog.debug("[RPC]: Connection Close")
    }

    public func onReceiveMessage(_ message: [String: Any]) {
        guard let request = NativeRPCRequest(from: message) else {
            RPCLog.error("[RPC]: invalid message: %@", message)
            return
        }
        RPCLog.debug("[RPC]: receive => %@", message)

        Task {
            do {
                try await stub?.onReceiveMessage(request)
            } catch {
                let response = NativeRPCResponse(for: request, error: NativeRPCError.from(error))
                sendMessage(response.jsonObject)
                RPCLog.error(
                    "[RPC]: Error %@", response.jsonObject.jsonString ?? "response to json failed")
            }
        }
    }

    public func sendMessage(_ message: [String: Any]) {
        RPCLog.debug("[RPC]: send => %@", message)
    }
}
