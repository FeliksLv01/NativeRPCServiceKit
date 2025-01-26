//
//  NativeRPCServiceCenter.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

import Foundation

public final class NativeRPCServiceCenter {
    public static let shared = NativeRPCServiceCenter()
    
    private var serviceMap: [String: NativeRPCService.Type] = [
        NativeRPCEventService.name: NativeRPCEventService.self
    ]
    
    private init() {}

    private func registerService<T: NativeRPCService>(_ service: T.Type) {
        serviceMap[T.name] = service
    }

    private func serviceType(named serviceName: String) -> NativeRPCService.Type? {
        return serviceMap[serviceName]
    }

    public static func registerService<T: NativeRPCService>(_ service: T.Type) {
        shared.registerService(service)
    }

    static func serviceType(named serviceName: String) -> NativeRPCService.Type? {
        return shared.serviceType(named: serviceName)
    }
}
