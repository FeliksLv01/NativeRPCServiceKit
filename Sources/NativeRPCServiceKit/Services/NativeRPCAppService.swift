//
//  NativeRPCAppService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/3/22.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

class NativeRPCAppService: NativeRPCService {
    
    static var name: String = "app"
    enum Method: String {
        case info
    }
    
    enum Event: String {
        case enterForeground
        case enterBackground
    }
    
    required init(from context: NativeRPCContext) {}
    
    func info() -> NativeRPCResponseData {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Unknown"
        let bundleId = Bundle.main.bundleIdentifier ?? "Unknown"
        let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        return [
            "version": appVersion,
            "osType": platformInfo.osType,
            "osVersion": platformInfo.osVersion,
            "device": platformInfo.deviceModel,
            "name": appName,
            "bundleId": bundleId,
            "buildVersion": buildVersion
        ]
    }
    
    /// 定义宏来封装平台相关的逻辑
    private var platformInfo: (osType: String, osVersion: String, deviceModel: String) {
#if os(iOS)
        let osType = "iOS"
        let osVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
#elseif os(macOS)
        let osType = "macOS"
        let osVersion = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        }()
        let deviceModel = {
            let task = Process()
            task.launchPath = "/usr/sbin/system_profiler"
            task.arguments = ["SPHardwareDataType"]
            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                if let model = output.components(separatedBy: "Model Name: ").dropFirst().first?.components(separatedBy: "\n").first {
                    return model.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            return "Unknown"
        }()
#endif
        return (osType, osVersion, deviceModel)
    }
    
    func perform(with call: NativeRPCMethodCall<Method>) async throws -> NativeRPCResponseData? {
        switch call.method {
        case .info:
            return info()
        }
    }
    
    func addEventListener(_ event: Event) {
#if os(iOS)
        switch event {
        case .enterBackground:
            NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] _ in
                self?.postEvent(.enterBackground)
            }
        case .enterForeground:
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [weak self] _ in
                self?.postEvent(.enterForeground)
            }
        }
#endif
    }
    
    func removeEventListener(_ event: Event) {
#if os(iOS)
        switch event {
        case .enterBackground:
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        case .enterForeground:
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
#endif
    }
}
