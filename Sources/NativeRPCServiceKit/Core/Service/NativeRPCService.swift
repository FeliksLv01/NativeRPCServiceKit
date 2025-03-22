//
//  NativeRPCService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//
import Foundation

public protocol NativeRPCDiscoverableService: AnyObject {
    static var name: String { get }
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { get }
    
    init(from context: NativeRPCContext)
}

public extension NativeRPCDiscoverableService {
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { .all }

    var name: String {
        return Self.name
    }
    
    var supportedConnectionType: NativeRPCConnectionTypeOptions {
        return Self.supportedConnectionType
    }
}

public protocol NativeRPCPerformableService: NativeRPCDiscoverableService {
    associatedtype Method: RawRepresentable where Method.RawValue == String
    func perform(with call: NativeRPCMethodCall<Method>) async throws -> NativeRPCResponseData?
}

public protocol NativeRPCEventObservableService: NativeRPCDiscoverableService {
    associatedtype Event: RawRepresentable where Event.RawValue == String
    func addEventListener(_ event: Event)
    func removeEventListener(_ event: Event)
}

extension NativeRPCEventObservableService {
    func addEventListener(_ event: Event) {}
    func removeEventListener(_ event: Event) {}
    
    func postEvent(_ event: Event, data: NativeRPCResponseData? = nil) {
        let userInfo: [AnyHashable: Any] = data != nil ? ["event": event.rawValue, "data": data!]: ["event": event]
        NotificationCenter.nativeRPC.post(name: .serviceDidPostEvent, object: self, userInfo: userInfo)
    }
}

public protocol NativeRPCService: NativeRPCPerformableService, NativeRPCEventObservableService {}
