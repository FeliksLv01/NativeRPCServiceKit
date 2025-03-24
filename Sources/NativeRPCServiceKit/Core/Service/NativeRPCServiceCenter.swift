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

    public static func registerService<T: NativeRPCServiceRepresentable>(_ service: T.Type) {
        shared.registerService(service)
    }

    static func serviceType(named serviceName: String) -> (any NativeRPCServiceRepresentable.Type)? {
        return shared.serviceType(named: serviceName)
    }
}
