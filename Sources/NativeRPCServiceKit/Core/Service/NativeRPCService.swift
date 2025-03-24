//
//  NativeRPCService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//
import Foundation

/// A base protocol that all RPC services must conform to, providing core service identification
/// and connection type support.
///
/// This protocol defines the basic requirements for any service that can be registered
/// and used within the Native RPC system. It ensures that services can be uniquely identified
/// and properly initialized with the appropriate context.
public protocol NativeRPCServiceRepresentable: AnyObject {
    /// The unique identifier for this service type.
    /// This name is used to register and lookup the service in the RPC system.
    static var name: String { get }
    
    /// The connection types that this service supports.
    /// Defines which transport mechanisms (e.g. WebView, Native) the service can work with.
    static var supportedConnectionType: NativeRPCConnectionTypeOptions { get }
    
    /// Creates a new instance of the service with the given context.
    /// - Parameter context: The context containing configuration and runtime information
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

/// A protocol defining a service that can handle RPC method calls.
///
/// Services conforming to this protocol can process method calls from clients
/// and return responses asynchronously. The protocol uses an associated type
/// for method definitions to ensure type safety.
public protocol NativeRPCService: NativeRPCServiceRepresentable {
    /// The type representing valid methods for this service.
    /// Must be RawRepresentable with String to enable serialization.
    associatedtype Method: RawRepresentable where Method.RawValue == String
    
    /// Performs the requested RPC method call and returns the result.
    /// - Parameter call: The method call containing the context, method, and parameters
    /// - Returns: Optional response data if the method produces a result
    /// - Throws: Any errors that occur during method execution
    func perform(with call: NativeRPCMethodCall<Method>) async throws -> NativeRPCResponseData?
}

/// A protocol for services that support event-based communication.
///
/// Services conforming to this protocol can emit events that clients can subscribe to.
/// This enables push-based communication patterns where the service can notify
/// clients of state changes or other events.
public protocol NativeRPCServiceObservable: NativeRPCServiceRepresentable {
    /// The type representing valid events for this service.
    /// Must be RawRepresentable with String to enable serialization.
    associatedtype Event: RawRepresentable where Event.RawValue == String
    
    /// Registers a listener for the specified event type.
    /// - Parameter event: The event type to listen for
    func addEventListener(_ event: Event)
    
    /// Removes a listener for the specified event type.
    /// - Parameter event: The event type to stop listening for
    func removeEventListener(_ event: Event)
}

/// Default implementation for NativeRPCServiceObservable protocol.
extension NativeRPCServiceObservable {
    func addEventListener(_ event: Event) {}
    func removeEventListener(_ event: Event) {}
    
    /// Posts an event to all registered listeners.
    /// - Parameters:
    ///   - event: The event being posted
    ///   - data: Optional data associated with the event
    func postEvent(_ event: Event, data: NativeRPCResponseData? = nil) {
        let userInfo: [AnyHashable: Any] = data != nil ? ["event": event.rawValue, "data": data!]: ["event": event]
        NotificationCenter.nativeRPC.post(name: .serviceDidPostEvent, object: self, userInfo: userInfo)
    }
}
