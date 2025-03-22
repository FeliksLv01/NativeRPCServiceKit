//
//  AnyNativeRPCPerformableService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/3/19.
//

struct AnyNativeRPCPerformableService {
    private let _canHandleMethod: (String) -> Bool
    private let _perform: (AnyNativeRPCMethodCall) async throws -> NativeRPCResponseData?

    // 初始化方法，接受一个具体的 NativeRPCService 实现
    init<T: NativeRPCPerformableService>(_ service: T) {
        self._canHandleMethod = { method in
            if let _ = T.Method(rawValue: method) {
                return true
            }
            return false
        }

        self._perform = { wrapper in
            guard let method = T.Method(rawValue: wrapper.method) else {
                throw NativeRPCError.methodNotFound
            }
            let call = NativeRPCMethodCall(context: wrapper.context, method: method, params: wrapper.params)
            return try await service.perform(with: call)
        }
    }

    // 暴露一个通用的 canHandleMethod 方法
    func canHandleMethod(_ method: String) -> Bool {
        return _canHandleMethod(method)
    }

    func perform(with call: AnyNativeRPCMethodCall) async throws -> NativeRPCResponseData? {
        return try await _perform(call)
    }
}
