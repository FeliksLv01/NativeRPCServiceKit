//
//  NativeRPCServiceCenter.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/12.
//

import Foundation

public final class NativeRPCServiceCenter {
    typealias NativeRPCServiceType = NSObject & NativeRPCService

    public static let shared = NativeRPCServiceCenter()
    private var serviceMap: [String: NativeRPCServiceType.Type] = [
        NativeRPCEventService.name: NativeRPCEventService.self
    ]
    private init() {}

    private func registerService<T: NativeRPCServiceType>(_ service: T.Type) {
        serviceMap[T.name] = service
    }

    private func serviceType(named serviceName: String) -> NativeRPCServiceType.Type? {
        return serviceMap[serviceName]
    }

    public static func registerService<T: NativeRPCService & NSObject>(_ service: T.Type) {
        shared.registerService(service)
    }

    static func serviceType(named serviceName: String) -> NativeRPCServiceType.Type? {
        return shared.serviceType(named: serviceName)
    }
}
