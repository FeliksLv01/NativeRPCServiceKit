//
//  NotificationCenter+NativeRPC.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

extension Notification.Name {
    static let serviceDidPostEvent = Notification.Name("com.itoken.team.rpc.service.didPostEvent")
}

extension NotificationCenter {
    static let nativeRPC = NotificationCenter()
}
