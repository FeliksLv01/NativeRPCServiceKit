//
//  NativeRPCEventService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

class NativeRPCEventService: NativeRPCService {
    static var name: String = "event"
    
    required init(from context: NativeRPCContext) {
        
    }
    
    enum RPCMethod: String {
        case post
    }
    
    func perform(with call: NativeRPCMethodCall<RPCMethod>) async throws -> NativeRPCResponseData? {
        switch call.method {
        case .post:
            try post(call)
        }
        return nil
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

    public func post(_ call: NativeRPCMethodCall<RPCMethod>) throws {
        let rpcCallParams = call.params ?? [:]
        guard let name = rpcCallParams["name"] as? String else {
            throw NativeRPCError.invalidParams("name is missing or invalid")
        }
        let params = rpcCallParams["params"] as? [String: Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: params)
    }
}
