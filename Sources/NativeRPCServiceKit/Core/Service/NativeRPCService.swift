//
//  NativeRPCService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//
import Foundation

public protocol NativeRPCServiceRepresentable: AnyObject {
    static var name: String { get }
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { get }
    
    init(from context: NativeRPCContext)
}

public extension NativeRPCServiceRepresentable {
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { .all }

    var name: String {
        return Self.name
    }
    
    var supportedConnectionType: NativeRPCConnectionTypeOptions {
        return Self.supportedConnectionType
    }
}

public protocol NativeRPCService: NativeRPCServiceRepresentable {
    associatedtype Method: RawRepresentable where Method.RawValue == String
    func perform(with call: NativeRPCMethodCall<Method>) async throws -> NativeRPCResponseData?
}

public protocol NativeRPCServiceObservable: NativeRPCServiceRepresentable {
    associatedtype Event: RawRepresentable where Event.RawValue == String
    func addEventListener(_ event: Event)
    func removeEventListener(_ event: Event)
}

extension NativeRPCServiceObservable {
    func addEventListener(_ event: Event) {}
    func removeEventListener(_ event: Event) {}
    
    func postEvent(_ event: Event, data: NativeRPCResponseData? = nil) {
        let userInfo: [AnyHashable: Any] = data != nil ? ["event": event.rawValue, "data": data!]: ["event": event]
        NotificationCenter.nativeRPC.post(name: .serviceDidPostEvent, object: self, userInfo: userInfo)
    }
}
