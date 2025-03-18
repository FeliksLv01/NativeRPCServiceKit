//
//  NativeRPCRequest.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

class NativeRPCRequest: NativeRPCMessage {
    let params: [String: Any]?

    init(service: String, method: String, params: [String: Any]?, callbackId: String? = nil, event: String? = nil) {
        self.params = params
        super.init(service: service, method: method, callbackId: callbackId, event: event)
    }

    convenience init?(from json: [String: Any]) {
        guard let message = NativeRPCMessage(from: json) else {
            return nil
        }
        let params = json["params"] as? [String: Any]
        self.init(service: message.service, method: message.method, params: params, callbackId: message.callbackId, event: message.event)
    }
}
