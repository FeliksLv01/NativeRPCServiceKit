//
//  ViewController.swift
//  NativeRPCServiceDemo
//
//  Created by FeliksLv on 2025/10/25.
//

import NativeRPCServiceKit
import SnapKit
import UIKit
import WebKit

class ViewController: UIViewController {
    public lazy var bridge: NativeRPCWebViewJSBridge = .init(webView: webView, viewController: self)
        
    open lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 16.4, *) {
            #if DEBUG
                webView.isInspectable = true
            #endif
        }
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.uiDelegate = self
        return webView
    }()
        
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: .zero)
        progressView.backgroundColor = .clear
        progressView.trackTintColor = .clear
        progressView.progressTintColor = UIColor(red: 0, green: 0.52, blue: 1, alpha: 1)
        progressView.isHidden = true
        return progressView
    }()
        
    private var titleObservation: NSKeyValueObservation?
    private var progressObservation: NSKeyValueObservation?
        
    deinit {
        bridge.closeConnection()
        titleObservation?.invalidate()
        progressObservation?.invalidate()
    }
        
    override open func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            }
            return .white
        })
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
            
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(2)
        }
    }
        
    override open func viewDidLoad() {
        super.viewDidLoad()
            
        titleObservation = webView.observe(\.title, options: [.new]) { [weak self] webView, _ in
            self?.title = webView.title
        }

        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            guard let self = self else { return }
            let progress = webView.estimatedProgress
            if progress < 1.0 {
                progressView.isHidden = false
                progressView.progress = Float(progress)
            } else {
                progressView.isHidden = true
                progressView.progress = 0.0
            }
        }
            
        bridge.startConnection()
        webView.load(URLRequest(url: URL(string: "http://localhost:5173/")!))
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true)
    }
        
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(true)
        }))
        present(alertController, animated: true)
    }
        
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: webView.title, message: prompt, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            completionHandler(nil)
        }))
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(alertController.textFields?.first?.text)
        }))
        present(alertController, animated: true)
    }
}
