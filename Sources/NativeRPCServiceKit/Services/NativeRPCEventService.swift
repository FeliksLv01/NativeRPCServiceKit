//
//  NativeRPCEventService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

class NativeRPCEventService: NSObject, NativeRPCService {
    static var name: String = "event"
    static var supportedConnectionType: NativeRPCConnectionTypeOptions = .all
    
    func addEventListener(_ event: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(_:)), name: NSNotification.Name(rawValue: event), object: nil)
    }
    
    func removeEventListener(_ event: String) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: event), object: nil)
    }
    
    @objc
    func post(_ call: NativeRPCServiceCall) {
        guard let name = call.params?["name"] as? String else {
            call.reject(.invalidParams("empty event"))
            return
        }
        let params = call.params?["params"] as? [String: Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: params)
        call.resolve()
    }
    
    @objc
    func onNotification(_ noti: Notification) {
        let userInfo = noti.userInfo as? [String: Any]
        postEvent(noti.name.rawValue, data: userInfo)
    }
}
