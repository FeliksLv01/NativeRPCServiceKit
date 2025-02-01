//
//  NativeRPCWebViewJSBridge.swift
//  PocketCampus
//
//  Created by FeliksLv on 2025/1/13.
//

import WebKit

open class NativeRPCWebViewJSBridge: NSObject, WKScriptMessageHandler {
    private let connection: NativeRPCConnection

    private let handlerName = "bridge"
    public init(webView: WKWebView, viewController: NativeViewController?) {
        connection = NativeRPCWebViewConnection(
            webView: webView, rootViewController: viewController)
        super.init()
    }

    open func startConnection() {
        guard let webView = connection.context.rootView as? WKWebView else {
            return
        }
        webView.configuration.userContentController.removeScriptMessageHandler(forName: handlerName)
        webView.configuration.userContentController.add(self, name: handlerName)
        connection.start()
    }
    
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
