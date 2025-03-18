import Foundation
@testable import NativeRPCServiceKit
import Testing

class NativeRPCAppService {
    public func demo(_ call: NativeRPCServiceCall) {
        let rpcCallParams = call.params ?? [:]
        guard let name = rpcCallParams["name"] as? String else {
            call.reject(NativeRPCError.invalidParams("name is missing or invalid"))
            return
        }
        print(name)
        call.resolve(["result": name])
    }

    func test(_ call: NativeRPCServiceCall) {
        print(call.context.connectionType)
        call.resolve()
    }
}

extension NativeRPCAppService: NativeRPCService {
    static var name: String = "app"
    static var supportedConnectionType: NativeRPCConnectionTypeOptions = .all
    public func canHandleMethod(_ method: String) -> Bool {
        switch method {
        case "test":
            return true
        default:
            return false
        }
    }

    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, NativeRPCServiceCall>) throws {
        guard let method = args.first?.key else {
            throw NativeRPCError.methodNotFound
        }
        guard let call = args.first?.value as? NativeRPCServiceCall else {
            throw NativeRPCError.invalidParams("Error: Invalid call object")
        }

        switch method {
        case "test":
            self.test(call)
        default:
            throw NativeRPCError.methodNotFound
        }
    }

    static func createService() -> NativeRPCService {
        return NativeRPCAppService()
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
