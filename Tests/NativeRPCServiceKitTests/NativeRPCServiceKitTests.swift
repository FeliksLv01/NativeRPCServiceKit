import Testing
@testable import NativeRPCServiceKit
import Foundation
import CocoaLumberjackSwift

class NativeRPCAppService: NSObject, NativeRPCService {
    static var name: String = "app"
    
    static var supportedConnectionType: NativeRPCConnectionTypeOptions = .all
    
    @objc
    func test(_ call: NativeRPCServiceCall) {
        print(call.context.connectionType)
        call.resolve()
    }
}

@Test func example() async throws {
    DDLog.add(DDOSLogger.sharedInstance)
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    NativeRPCServiceCenter.registerService(NativeRPCAppService.self)
    let connection = NativeRPCConnection(context: .init(connectionType: .webSocket))
    connection.enableLog = true
    connection.start()
    
    connection.onReceiveMessage([
        "service": "app",
        "method": "test",
        "_meta": [
            "callbackId": 111
        ],
        "params": [
            "test": "123"
        ]
    ])
}
