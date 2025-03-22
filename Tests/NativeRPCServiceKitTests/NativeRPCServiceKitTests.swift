import Foundation
@testable import NativeRPCServiceKit
import Testing

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let connection = NativeRPCConnection(context: .init(connectionType: .webSocket))
    connection.start()

    await withCheckedContinuation { continuation in
        connection.onReceiveMessage([
            "service": "app",
            "method": "info",
            "_meta": [
                "callbackId": "11"
            ],
            "params": [
                "test": "123",
                "name": "FeliksLv"
            ]
        ])

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 模拟等待 Task 完成
            continuation.resume()
        }
    }
}
