//
//  AnyNativeRPCService.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/3/19.
//

struct AnyNativeRPCService {
    private let _canHandleMethod: (String) -> Bool
    private let _perform: (String, NativeRPCMethodCall) throws -> Void
    
    // 初始化方法，接受一个具体的 NativeRPCService 实现
    init<T: NativeRPCService>(_ service: T) {
        self._canHandleMethod = { method in
            if let _ = T.RPCMethod(rawValue: method) {
                return true
            }
            return false
        }
        
        self._perform = { method, call in
            guard let rpcMethod = T.RPCMethod(rawValue: method) else {
                call.reject(.methodNotFound)
                return
            }
            try service.perform(rpcMethod, with: call)
        }
    }
    
    // 暴露一个通用的 canHandleMethod 方法
    func canHandleMethod(_ method: String) -> Bool {
        return _canHandleMethod(method)
    }
    
    func perform(_ method: String, with call: NativeRPCMethodCall) throws {
        return try _perform(method, call)
    }
}
