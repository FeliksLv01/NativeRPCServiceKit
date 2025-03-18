//
//  NativeRPCEventService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

class NativeRPCEventService: NativeRPCService {
    static var name: String = "event"
    
    enum RPCMethod: String {
        case post
    }

    public func perform(_ method: RPCMethod, with call: NativeRPCMethodCall) throws {
        switch method {
        case .post:
            post(call)
        }
    }

    static func createService(from context: NativeRPCContext) -> any NativeRPCService {
        return NativeRPCEventService()
    }

    // MARK: - Event Listener Management

    func addEventListener(_ event: String) {
        NotificationCenter.default.addObserver(forName: .init(rawValue: event), object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            let userInfo = notification.userInfo as? [String: Any]
            postEvent(notification.name.rawValue, data: userInfo)
        }
    }

    func removeEventListener(_ event: String) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: event), object: nil)
    }

    public func post(_ call: NativeRPCMethodCall) {
        let rpcCallParams = call.params ?? [:]
        guard let name = rpcCallParams["name"] as? String else {
            call.reject(NativeRPCError.invalidParams("name is missing or invalid"))
            return
        }
        let params = rpcCallParams["params"] as? [String: Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: params)
        call.resolve()
    }
}
