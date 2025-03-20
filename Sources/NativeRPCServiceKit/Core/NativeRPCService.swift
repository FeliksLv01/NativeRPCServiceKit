//
//  NativeRPCService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//
import Foundation

public protocol NativeRPCService: AnyObject {
    static var name: String { get }
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { get }
    
    init(from context: NativeRPCContext)
    
    associatedtype RPCMethod: RawRepresentable where RPCMethod.RawValue == String
    func perform(with call: NativeRPCMethodCall<RPCMethod>) async throws -> NativeRPCResponseData?

    func addEventListener(_ event: String)
    func removeEventListener(_ event: String)
    func postEvent(_ event: String, data: NativeRPCResponseData?)
}

public extension NativeRPCService {
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { .all }

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
