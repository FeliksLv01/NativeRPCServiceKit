//
//  NativeRPCWebViewJSBridge.swift
//  PocketCampus
//
//  Created by FeliksLv on 2025/1/13.
//

import WebKit

@MainActor
open class NativeRPCWebViewJSBridge: NSObject, WKScriptMessageHandler {
    private let connection: NativeRPCConnection

    private let handlerName = "bridge"
    public init(webView: WKWebView, viewController: UIViewController?) {
        connection = NativeRPCWebViewConnection(
            webView: webView, rootViewController: viewController)
        super.init()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: handlerName)
        webView.configuration.userContentController.add(self, name: handlerName)
    }

    open func startConnection() {
        connection.start()
    }

    open func userContentController(
        _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
        let body = message.body
        guard let dict = body as? [String: Any] else { return }
        connection.onReceiveMessage(dict)
    }
}
