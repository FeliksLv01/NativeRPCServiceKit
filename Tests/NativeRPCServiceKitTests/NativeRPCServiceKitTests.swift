import Foundation
@testable import NativeRPCServiceKit
import Testing

class NativeRPCAppService: NativeRPCService {
    func perform(with call: NativeRPCMethodCall<RPCMethod>) async throws -> NativeRPCResponseData? {
        switch call.method {
        case .test:
            test(call)
        case .demo:
            throw NativeRPCError.methodNotFound
        }
        return nil
    }
    
    static func createService(from context: NativeRPCContext) -> any NativeRPCService {
        return NativeRPCAppService()
    }
    
    static var name: String = "app"
    static var supportedConnectionType: NativeRPCConnectionTypeOptions = .all
    
    enum RPCMethod: String {
        case test
        case demo
    }

    func test(_ call: NativeRPCMethodCall<RPCMethod>) {
        print(call.context.connectionType)
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
