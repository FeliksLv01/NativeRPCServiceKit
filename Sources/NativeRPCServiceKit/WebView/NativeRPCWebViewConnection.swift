//
//  NativeRPCWebViewConnection.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation
import WebKit

public class NativeRPCWebViewConnection: NativeRPCConnection {
    public convenience init(webView: WKWebView, rootViewController: NativeViewController?) {
        self.init(context: .init(connectionType: .webView, rootView: webView, rootViewController: rootViewController))
    }
    
    public override func sendMessage(_ message: [String : Any]) async {
        guard let webView = self.context.rootView as? WKWebView,
              let jsonString = message.jsonString else {
            RPCLog.error("[RPC]: message send Error: %@", message)
            return
        }
        
        let jsCode = "window.rpcClient.onReceive(\(jsonString))"
        
        await MainActor.run {
            webView.evaluateJavaScript(jsCode) { data, error in
                if let error = error {
                    RPCLog.error("[RPC]: WebView onReceive Message Error %@", error.localizedDescription)
                }
            }
        }
        await super.sendMessage(message)
    }
}
