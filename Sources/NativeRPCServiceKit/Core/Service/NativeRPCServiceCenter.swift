//
//  NativeRPCServiceCenter.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

import Foundation

public final class NativeRPCServiceCenter {
    private static let shared = NativeRPCServiceCenter()

    private var serviceMap: [String: any NativeRPCDiscoverableService.Type] = [
        NativeRPCEventService.name: NativeRPCEventService.self,
        NativeRPCAppService.name: NativeRPCAppService.self
    ]

    private init() {}

    private func registerService<T: NativeRPCDiscoverableService>(_ service: T.Type) {
        serviceMap[T.name] = service
    }

    private func serviceType(named serviceName: String) -> (any NativeRPCDiscoverableService.Type)? {
        return serviceMap[serviceName]
    }

    public static func registerService<T: NativeRPCDiscoverableService>(_ service: T.Type) {
        shared.registerService(service)
    }

    static func serviceType(named serviceName: String) -> (any NativeRPCDiscoverableService.Type)? {
        return shared.serviceType(named: serviceName)
    }
}
