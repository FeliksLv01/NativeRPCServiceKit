//
//  NativeRPCConnection.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

/// Native RPC connection class that handles message transmission. A single connection can be reused for multiple data transfers.
open class NativeRPCConnection: NativeRPCStubDelegate {
    /// The context object containing connection configuration and settings
    public let context: NativeRPCContext
    private var stub: NativeRPCStub?

    /// Initializes a new RPC connection with the specified context
    /// - Parameter context: The context object containing connection configuration
    public init(context: NativeRPCContext) {
        self.context = context
    }

    /// Starts the RPC connection by initializing the stub and setting up message handling
    public func start() {
        stub = NativeRPCStub(context: context)
        stub?.delegate = self
        NativeRPCLog.debug("[RPC]: Connection Start")
    }

    /// Closes the RPC connection and cleans up resources
    public func close() {
        stub?.delegate = nil
        stub = nil
        NativeRPCLog.debug("[RPC]: Connection Close")
    }

    /// Handles incoming RPC messages by processing them through the stub
    /// - Parameter message: A dictionary containing the RPC message data
    public func onReceiveMessage(_ message: [String: Any]) {
        guard let request = NativeRPCRequest(from: message) else {
            NativeRPCLog.error("[RPC]: invalid message format: \(message)")
            return
        }
        NativeRPCLog.debug("[RPC]: receive => \(message)")

        Task {
            do {
                try await stub?.onReceiveMessage(request)
            } catch {
                let response = NativeRPCResponse(for: request, error: NativeRPCError.from(error))
                await sendMessage(response.jsonObject)
                NativeRPCLog.error(
                    "[RPC]: Error \(response.jsonObject.jsonString ?? "response to json failed")")
            }
        }
    }

    /// Sends an RPC message through the connection
    /// - Parameter message: A dictionary containing the RPC message to be sent
    public func sendMessage(_ message: [String: Any]) async {
        NativeRPCLog.debug("[RPC]: send => \(message)")
    }
}
