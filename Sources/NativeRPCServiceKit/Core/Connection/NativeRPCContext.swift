//
//  NativeRPCContext.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

#if os(iOS)
import UIKit
/// Platform-specific type alias for the native view class (UIView on iOS)
public typealias NativeView = UIView
/// Platform-specific type alias for the native view controller class (UIViewController on iOS)
public typealias NativeViewController = UIViewController
#elseif os(macOS)
import AppKit
/// Platform-specific type alias for the native view class (NSView on macOS)
public typealias NativeView = NSView
/// Platform-specific type alias for the native view controller class (NSViewController on macOS)
public typealias NativeViewController = NSViewController
#endif

/// Represents the type of connection used for native RPC communication
public enum NativeRPCConnectionType: UInt {
    /// No connection type specified
    case none = 0
    /// WebView-based connection for web content integration
    case webView
    /// JavaScriptCore-based connection for direct JS execution
    case jsCore
    /// WebSocket-based connection for real-time communication
    case webSocket
}

/// A set of options that defines supported connection types for RPC services
public struct NativeRPCConnectionTypeOptions: OptionSet {
    public let rawValue: UInt

    /// Support for WebView-based connections
    public static let webView = Self(rawValue: 1 << 1)
    /// Support for JavaScriptCore-based connections
    public static let jsCore = Self(rawValue: 1 << 2)
    /// Support for WebSocket-based connections
    public static let webSocket = Self(rawValue: 1 << 3)

    /// Supports all available connection types
    public static let all: Self = [.webView, .jsCore, .webSocket]

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    /// Checks if a specific connection type is supported by the current options
    /// - Parameter type: The connection type to check for support
    /// - Returns: A boolean indicating whether the connection type is supported
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

/// A context object that holds configuration and state for native RPC connections
///
/// The context maintains information about the connection type and references to the UI components
/// involved in the RPC communication. It supports different platforms (iOS/macOS) through type aliases
/// and provides a unified interface for managing RPC connections.
public final class NativeRPCContext {
    /// The type of connection being used for RPC communication
    public let connectionType: NativeRPCConnectionType
    /// The root view associated with this RPC context (platform-specific type)
    public private(set) weak var rootView: NativeView?
    /// The root view controller associated with this RPC context (platform-specific type)
    public private(set) weak var rootViewController: NativeViewController?

    /// Initializes a new RPC context with the specified configuration
    /// - Parameters:
    ///   - connectionType: The type of connection to use for RPC communication
    ///   - rootView: The root view to associate with this context (optional)
    ///   - rootViewController: The root view controller to associate with this context (optional)
    public init(connectionType: NativeRPCConnectionType, rootView: NativeView? = nil, rootViewController: NativeViewController? = nil) {
        self.connectionType = connectionType
        self.rootView = rootView
        self.rootViewController = rootViewController
    }
}
