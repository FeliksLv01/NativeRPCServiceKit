//
//  NativeRPCResponse.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

class NativeRPCResponse: NativeRPCMessage {
    var error: NativeRPCError?
    var data: NativeRPCResponseData?
    
    convenience init(for request: NativeRPCRequest, data: NativeRPCResponseData? = nil, error: NativeRPCError? = nil) {
        self.init(service: request.service, method: request.method, callbackId: request.callbackId, event: request.event)
        self.error = error
    }
    
    var jsonObject: NativeRPCResponseData {
        var json: [String: Any] = [:]
        var meta: [String: Any] = [:]
        
        if let callbackId = callbackId {
            meta["callbackId"] = callbackId
        } else if let event = event {
            meta["event"] = event
        }
        json["_meta"] = meta
        
        if let error = error {
            json["code"] = error.errorCode
            json["message"] = error.localizedDescription
        } else {
            json["code"] = 1000
            if let data = data {
                json["data"] = data
            }
        }
        return json
    }
}
