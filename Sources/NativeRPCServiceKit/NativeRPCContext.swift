//
//  NativeRPCContext.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

#if os(iOS)
import UIKit
public typealias NativeView = UIView
public typealias NativeViewController = UIViewController
#elseif os(macOS)
import AppKit
public typealias NativeView = NSView
public typealias NativeViewController = NSViewController
#endif

public enum NativeRPCConnectionType: UInt {
    case none = 0
    case webView
    case jsCore
    case webSocket
}

public struct NativeRPCConnectionTypeOptions: OptionSet {
    public let rawValue: UInt

    public static let webView = Self(rawValue: 1 << 1)
    public static let jsCore = Self(rawValue: 1 << 2)
    public static let webSocket = Self(rawValue: 1 << 3)

    public static let all: Self = [.webView, .jsCore, .webSocket]

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

    public private(set) weak var rootView: NativeView?
    public private(set) weak var rootViewController: NativeViewController?

    public init(connectionType: NativeRPCConnectionType, rootView: NativeView? = nil, rootViewController: NativeViewController? = nil) {
        self.connectionType = connectionType
        self.rootView = rootView
    }
}
