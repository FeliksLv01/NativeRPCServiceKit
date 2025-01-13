//
//  NativeRPCService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//
import Foundation

public protocol NativeRPCService: NSObjectProtocol {
    static var name: String { get }
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { get }

    func addEventListener(_ event: String)
    func removeEventListener(_ event: String)
    func postEvent(_ event: String, data: NativeRPCResponseData?)
}

public extension NativeRPCService {
    var name: String {
        return Self.name
    }
    
    var supportedConnectionType: NativeRPCConnectionTypeOptions {
        return Self.supportedConnectionType
    }
    
    func addEventListener(_ event: String) {}
    func removeEventListener(_ event: String) {}
    
    func postEvent(_ event: String) {
        postEvent(event, data: nil)
    }
    
    func postEvent(_ event: String, data: NativeRPCResponseData?) {
        NotificationCenter.nativeRPC.post(name: .serviceDidPostEvent, object: self, userInfo: [
            "event": event,
            "data": data ?? [:]
        ])
    }
}
