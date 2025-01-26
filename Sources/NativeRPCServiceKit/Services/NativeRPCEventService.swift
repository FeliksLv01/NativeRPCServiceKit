//
//  NativeRPCEventService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

@NativeRPCService("event")
class NativeRPCEventService {
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
    
    @NativeRPCMethod
    func post(name: String, params: [String: Any]?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: params)
    }
}
