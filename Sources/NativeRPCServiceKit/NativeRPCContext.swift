//
//  NativeRPCContext.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import UIKit

public enum NativeRPCConnectionType: UInt {
    case none = 0
    case webView
    case jsCore
    case webSocket
}

public struct NativeRPCConnectionTypeOptions: OptionSet {
    public let rawValue: UInt

    static let webView = Self(rawValue: 1 << 1)
    static let jsCore = Self(rawValue: 1 << 2)
    static let webSocket = Self(rawValue: 1 << 3)

    static let all: Self = [.webView, .jsCore, .webSocket]

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    func supports(_ type: NativeRPCConnectionType) -> Bool {
        switch type {
        case .webView:
            return contains(.webView)
        case .jsCore:
            return contains(.jsCore)
        case .webSocket:
            return contains(.webView)
        default:
            return false
        }
    }
}

@objc
public final class NativeRPCContext: NSObject {
    public let connectionType: NativeRPCConnectionType

    public private(set) weak var rootView: UIView?
    public private(set) weak var rootViewController: UIViewController?

    public init(connectionType: NativeRPCConnectionType, rootView: UIView? = nil, rootViewController: UIViewController? = nil) {
        self.connectionType = connectionType
        self.rootView = rootView
    }
}
