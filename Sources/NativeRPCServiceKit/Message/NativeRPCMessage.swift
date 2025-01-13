//
//  NativeRPCMessage.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

protocol NativeRPCMessageMeta {
    var callbackId: String? { get }
    var event: String? { get }
}

class NativeRPCMessage: NativeRPCMessageMeta {
    let service: String
    let method: String
    let callbackId: String?
    let event: String?

    init(service: String, method: String, callbackId: String? = nil, event: String? = nil) {
        self.service = service
        self.method = method
        self.callbackId = callbackId
        self.event = event
    }
    
    convenience init?(from json: [String: Any]) {
        guard let service = json["service"] as? String,
              let method = json["method"] as? String
        else {
            return nil
        }
        
        let meta = json["_meta"] as? [String: Any]
        let callbackId = meta?["callbackId"] as? String
        let event = meta?["event"] as? String
        
        self.init(service: service, method: method, callbackId: callbackId, event: event)
    }
}

