//
//  NativeRPCStub.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/11.
//

import Foundation

protocol NativeRPCStubDelegate: AnyObject {
    func sendMessage(_ message: [String: Any]) async
}

/// 消息收发站
final class NativeRPCStub {
    private weak var context: NativeRPCContext?
    private var services: [String: any NativeRPCServiceRepresentable] = [:]
    private var events: [String: Int] = [:]

    weak var delegate: NativeRPCStubDelegate?

    init(context: NativeRPCContext) {
        self.context = context
        registerNotification()
    }

    func service(named serviceName: String) throws -> any NativeRPCServiceRepresentable {
        guard let serviceType = NativeRPCServiceCenter.serviceType(named: serviceName) else {
            throw NativeRPCError.serviceNotFound
        }
        guard let context = context,
              serviceType.supportedConnectionType.supports(context.connectionType)
        else {
            throw NativeRPCError.connectionTypeNotSupported
        }
        let service = services[serviceName]
        let serviceInstance = service ?? serviceType.init(from: context)
        if service == nil {
            services[serviceName] = serviceInstance
        }
        return serviceInstance
    }

    func onReceiveMessage(_ request: NativeRPCRequest) async throws {
        let service = try service(named: request.service)
        if request.method == "_addEventListener" {
            try addEventListener(from: request, to: service)
            return
        }
        
        if request.method == "_removeEventListener" {
            try removeEventListener(from: request, to: service)
            return
        }
        
        guard let service = service as? (any NativeRPCService) else {
            return
        }

        let rpcService = AnyNativeRPCService(service)

        // 普通方法调用
        guard let context = context, rpcService.canHandleMethod(request.method) else {
            throw NativeRPCError.methodNotFound
        }

        let call = AnyNativeRPCMethodCall(
            context: context, method: request.method, params: request.params
        )
        do {
            let data = try await rpcService.perform(with: call)
            let response = NativeRPCResponse(for: request, data: data)
            sendMessage(response)
        } catch {
            let response = NativeRPCResponse(for: request)
            if let error = error as? NativeRPCError {
                response.error = error
            } else {
                response.error = NativeRPCError.userDefined(error.localizedDescription)
            }
            sendMessage(response)
        }
    }

    private func registerNotification() {
        NotificationCenter.nativeRPC.addObserver(
            forName: .serviceDidPostEvent, object: nil, queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            guard let service = notification.object as? (any NativeRPCService),
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

    private func addEventListener(from request: NativeRPCRequest, to service: any NativeRPCServiceRepresentable) throws {
        guard let event = request.event else {
            throw NativeRPCError.invalidMessage
        }
        
        let eventHandler: (String) -> Void
        
        // 确定事件处理器
        if request.event == "event" {
            guard let eventService = service as? NativeRPCEventService else {
                throw NativeRPCError.serviceNotFound
            }
            eventHandler = eventService.addEventListener
        } else {
            guard let observableService = service as? (any NativeRPCServiceObservable) else {
                throw NativeRPCError.serviceNotFound
            }
            let wrapper = AnyNativeRPCServiceObservable(observableService)
            eventHandler = wrapper.addEventListener
        }
        
        // 处理事件注册
        let eventSignature = "\(request.service).\(event)"
        let count = events[eventSignature] ?? 0
        events[eventSignature] = count + 1
        
        if count == 0 {
            eventHandler(event)
        }
    }

    private func removeEventListener(from request: NativeRPCRequest, to service: any NativeRPCServiceRepresentable) throws {
        guard let event = request.event else {
            throw NativeRPCError.invalidMessage
        }
        
        let eventHandler: (String) -> Void
        
        if request.event == "event" {
            guard let eventService = service as? NativeRPCEventService else {
                throw NativeRPCError.serviceNotFound
            }
            eventHandler = eventService.removeEventListener
        } else {
            guard let observableService = service as? (any NativeRPCServiceObservable) else {
                throw NativeRPCError.serviceNotFound
            }
            let wrapper = AnyNativeRPCServiceObservable(observableService)
            eventHandler = wrapper.removeEventListener
        }
        
        let eventSignature = "\(request.service).\(event)"
        let count = events[eventSignature] ?? 0
        events[eventSignature] = max(0, count - 1)
        if count - 1 == 0 {
            eventHandler(event)
        }
    }

    private func sendMessage(_ message: NativeRPCResponse) {
        Task { [weak self] in
            guard let self else { return }
            await delegate?.sendMessage(message.jsonObject)
        }
    }
}
