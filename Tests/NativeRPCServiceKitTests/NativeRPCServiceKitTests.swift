import Testing
@testable import NativeRPCServiceKit
import Foundation

@NativeRPCService("app")
class NativeRPCAppService {
    
    @NativeRPCMethod
    func demo(name: String) -> String {
        print(name)
        return name
    }
    
    @NativeRPCMethodExport
    func test(_ call: NativeRPCServiceCall) {
        print(call.context.connectionType)
        call.resolve()
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
