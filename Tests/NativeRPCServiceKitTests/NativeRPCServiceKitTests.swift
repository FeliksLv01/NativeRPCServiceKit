import Foundation
@testable import NativeRPCServiceKit
import Testing

class NativeRPCAppService {
    public func demo(_ call: NativeRPCMethodCall) {
        let rpcCallParams = call.params ?? [:]
        guard let name = rpcCallParams["name"] as? String else {
            call.reject(NativeRPCError.invalidParams("name is missing or invalid"))
            return
        }
        print(name)
        call.resolve(["result": name])
    }

    func test(_ call: NativeRPCMethodCall) {
        print(call.context.connectionType)
        call.resolve()
    }
}

extension NativeRPCAppService: NativeRPCService {
    static func createService(from context: NativeRPCContext) -> any NativeRPCService {
        return NativeRPCAppService()
    }
    
    static var name: String = "app"
    static var supportedConnectionType: NativeRPCConnectionTypeOptions = .all
    
    enum RPCMethod: String {
        case test
        case demo
    }
    
    func perform(_ method: RPCMethod, with call: NativeRPCMethodCall) throws {
        switch method {
        case .test:
            test(call)
        default:
            throw NativeRPCError.methodNotFound
        }
    }
}

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    NativeRPCServiceCenter.registerService(NativeRPCAppService.self)
    let connection = NativeRPCConnection(context: .init(connectionType: .webSocket))
    connection.start()

    connection.onReceiveMessage([
        "service": "app",
        "method": "demo",
        "_meta": [
            "callbackId": 111
        ],
        "params": [
            "test": "123",
            "name": "FeliksLv"
        ]
    ])
}
