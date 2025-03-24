//
//  NativeRPCWebViewJSBridge.swift
//  PocketCampus
//
//  Created by FeliksLv on 2025/1/13.
//

import WebKit

/// A bridge class that handles JavaScript-to-Native communication in WKWebView.
/// This class manages the connection between web content and native code, allowing bidirectional message passing.
open class NativeRPCWebViewJSBridge: NSObject, WKScriptMessageHandler {
    private let connection: NativeRPCConnection

    private let handlerName = "bridge"
    
    /// Initializes a new bridge instance for handling JavaScript-to-Native communication.
    /// - Parameters:
    ///   - webView: The WKWebView instance that will be used for web content display and JavaScript execution.
    ///   - viewController: The view controller that hosts the web view. This can be used for presenting native UI components.
    public init(webView: WKWebView, viewController: NativeViewController?) {
        connection = NativeRPCWebViewConnection(
            webView: webView, rootViewController: viewController)
        super.init()
    }

    /// Establishes the connection between JavaScript and native code.
    /// This method sets up the message handler and initializes the bridge connection.
    /// Call this method after initializing the bridge and before any JavaScript-to-Native communication.
    open func startConnection() {
        guard let webView = connection.context.rootView as? WKWebView else {
            return
        }
        webView.configuration.userContentController.removeScriptMessageHandler(forName: handlerName)
        webView.configuration.userContentController.add(self, name: handlerName)
        connection.start()
    }
    
    /// Closes the connection and removes the message handler.
    /// Call this method when you no longer need the bridge, typically in the deinit of your view controller.
    open func closeConnection() {
        guard let webView = connection.context.rootView as? WKWebView else {
            return
        }
        webView.configuration.userContentController.removeScriptMessageHandler(forName: handlerName)
        connection.close()
    }

    open func userContentController(
        _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
        let body = message.body
        guard let dict = body as? [String: Any] else { return }
        connection.onReceiveMessage(dict)
    }
}
