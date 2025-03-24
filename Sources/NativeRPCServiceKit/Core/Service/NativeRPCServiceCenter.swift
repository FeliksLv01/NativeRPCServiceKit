//
//  NativeRPCServiceCenter.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

import Foundation

public final class NativeRPCServiceCenter {
    private static let shared = NativeRPCServiceCenter()

    private var serviceMap: [String: any NativeRPCServiceRepresentable.Type] = [
        NativeRPCEventService.name: NativeRPCEventService.self,
        NativeRPCAppService.name: NativeRPCAppService.self
    ]

    private init() {}

    private func registerService<T: NativeRPCServiceRepresentable>(_ service: T.Type) {
        serviceMap[T.name] = service
    }

    private func serviceType(named serviceName: String) -> (any NativeRPCServiceRepresentable.Type)? {
        return serviceMap[serviceName]
    }

    /// Registers a custom service type with the Native RPC system.
    /// 
    /// Use this method to register your custom service implementations that conform to
    /// the `NativeRPCServiceRepresentable` protocol. Once registered, the service can be
    /// used to handle RPC calls from clients.
    /// 
    /// - Parameter service: The service type to register. Must conform to `NativeRPCServiceRepresentable`
    /// 
    /// Example:
    /// ```swift
    /// // Register a custom service
    /// NativeRPCServiceCenter.registerService(MyCustomService.self)
    /// ```
    public static func registerService<T: NativeRPCServiceRepresentable>(_ service: T.Type) {
        shared.registerService(service)
    }

    static func serviceType(named serviceName: String) -> (any NativeRPCServiceRepresentable.Type)? {
        return shared.serviceType(named: serviceName)
    }
}
