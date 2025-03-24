//
//  AnyNativeRPCServiceObservable.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/3/22.
//

struct AnyNativeRPCServiceObservable {
    private let _canHandleEvent: (String) -> Bool
    private let _addEventListener: (String) -> Void
    private let _removeEventListener: (String) -> Void

    // 初始化方法，接受一个具体的 NativeRPCServiceObservable 实现
    init<T: NativeRPCServiceObservable>(_ service: T) {
        self._canHandleEvent = { eventName in
            if T.Event(rawValue: eventName) != nil {
                return true
            }
            return false
        }

        self._addEventListener = { eventName in
            guard let event = T.Event(rawValue: eventName) else { return }
            service.addEventListener(event)
        }

        self._removeEventListener = { eventName in
            guard let event = T.Event(rawValue: eventName) else { return }
            service.removeEventListener(event)
        }
    }

    // 暴露一个通用的 canHandleEvent 方法
    func canHandleEvent(_ event: String) -> Bool {
        return _canHandleEvent(event)
    }

    func addEventListener(_ event: String) {
        _addEventListener(event)
    }

    func removeEventListener(_ event: String) {
        _removeEventListener(event)
    }
}
