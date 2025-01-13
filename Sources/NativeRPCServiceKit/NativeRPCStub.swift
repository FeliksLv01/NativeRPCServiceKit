//
//  NativeRPCStub.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

protocol NativeRPCStubDelegate: AnyObject {
    func sendMessage(_ message: [String: Any])
}

/// 消息收发站
final class NativeRPCStub {
    private let context: NativeRPCContext
    private var services: [String: NativeRPCService] = [:]
    private var events: [String: Int] = [:]
        
    weak var delegate: NativeRPCStubDelegate?
    
    init(context: NativeRPCContext) {
        self.context = context
        registerNotification()
    }
    
    func service(named serviceName: String) throws -> NativeRPCService {
        guard let serviceType = NativeRPCServiceCenter.serviceType(named: serviceName) else {
            throw NativeRPCError.serviceNotFound
        }
        guard serviceType.supportedConnectionType.supports(context.connectionType) else {
            throw NativeRPCError.connectionTypeNotSupported
        }
        let service = services[serviceName]
        let serviceInstance = service ?? serviceType.init()
        if service == nil {
            services[serviceName] = serviceInstance
        }
        return serviceInstance
    }
    
    func onReceiveMessage(_ request: NativeRPCRequest) throws {
        let service = try service(named: request.service)
        
        guard request.method != "_addEventListener" else {
            addEventListener(from: request, to: service)
            return
        }
        
        guard request.method != "_removeEventListener" else {
            removeEventListener(from: request, to: service)
            return
        }
        
        // 普通方法调用
        let selector = Selector("\(request.method):")
        guard service.responds(to: selector) else {
            throw NativeRPCError.methodNotFound
        }
        
        let call = NativeRPCServiceCall(context: context, params: request.params) { [weak self] result in
            guard let self = self else { return }
            let response = NativeRPCResponse(for: request)
            switch result {
            case .success(let data):
                response.data = data
            case .failure(let error):
                response.error = error
            }
            sendMessage(response)
        }
        service.perform(selector, with: call)
    }
    
    private func registerNotification() {
        NotificationCenter.nativeRPC.addObserver(forName: .serviceDidPostEvent, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            guard let service = notification.object as? NativeRPCService,
                  let userInfo = notification.userInfo,
                  let event = userInfo["event"] as? String,
                  let count = events["\(service.name).\(event)"],
                  count > 0,
                  let currentService = services[service.name],
                  currentService === service
            else {
                return
            }
            let response = NativeRPCResponse(service: service.name, method: "_event", event: event)
            let data = userInfo["data"]
            if let data = data as? NativeRPCResponseData {
                response.data = data
            }
            sendMessage(response)
        }
    }

    private func addEventListener(from request: NativeRPCRequest, to service: NativeRPCService) {
        guard let event = request.event else {
            sendMessage(.init(for: request, error: .invalidMessage))
            return
        }
        let eventSignature = "\(request.service).\(event)"
        let count = events[eventSignature] ?? 0
        events[eventSignature] = count + 1
        if count == 0 {
            service.addEventListener(event)
        }
        sendMessage(.init(for: request))
    }
    
    private func removeEventListener(from request: NativeRPCRequest, to service: NativeRPCService) {
        guard let event = request.event else {
            sendMessage(.init(for: request, error: .invalidMessage))
            return
        }
        let eventSignature = "\(request.service).\(event)"
        let count = events[eventSignature] ?? 0
        events[eventSignature] = max(0, count - 1)
        if count - 1 == 0 {
            service.removeEventListener(event)
        }
        sendMessage(.init(for: request))
    }
    
    private func sendMessage(_ message: NativeRPCResponse) {
        delegate?.sendMessage(message.jsonObject)
    }
}
