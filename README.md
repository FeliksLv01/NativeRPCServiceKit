# NativeRPCServiceKit

Cross Platform Communication Framework.

## How To Use

1. Create a NativeRPCService to expose your native code. You can implement method calls and event notifications separately.

```swift
import NativeRPCServiceKit

class NativeRPCAppService: NativeRPCService {
    // Define service name
    static var name: String = "app"
    
    // Define method types
    enum Method: String {
        case info
    }
    
    // Define event types
    enum Event: String {
        case enterForeground
        case enterBackground
    }
    
    required init(from context: NativeRPCContext) {}
    
    // Implement method calls
    func perform(with call: NativeRPCMethodCall<Method>) async throws -> NativeRPCResponseData? {
        switch call.method {
        case .info:
            return [
                "version": "1.0.0",
                "osType": "iOS",
                "osVersion": "17.0"
            ]
        }
    }
    
    // Implement event notifications
    func addEventListener(_ event: Event) {
        switch event {
        case .enterBackground:
            NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] _ in
                self?.postEvent(.enterBackground)
            }
        case .enterForeground:
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [weak self] _ in
                self?.postEvent(.enterForeground)
            }
        }
    }
    
    func removeEventListener(_ event: Event) {
        // Remove event listener implementation
    }
}
```

2. Register your service and establish connection.

```swift
// Register your service
NativeRPCServiceCenter.registerService(NativeRPCAppService.self)

// Create and start a connection
let connection = NativeRPCConnection(context: .init(connectionType: .webSocket))
connection.start()
```

3. Send messages to invoke methods or listen to events.

```swift
// Method call format
connection.onReceiveMessage([
    "service": "app",        // Service name defined in NativeRPCService
    "method": "info",        // Method name to call
    "_meta": [
        "callbackId": "111"    // Callback ID for async operations
    ],
    "params": [             // Method parameters
        "name": "FeliksLv"
    ]
])

// Event subscription format
connection.onReceiveMessage([
    "service": "app",        // Service name defined in NativeRPCService
    "event": "enterForeground", // Event name to subscribe
    "_meta": [
        "callbackId": "222"    // Callback ID for event notifications
    ]
])
```

### WKWebView Integration

NativeRPCServiceKit provides seamless integration with WKWebView through the `NativeRPCWebViewJSBridge` class, enabling smooth communication between web content and native code.

```swift
import NativeRPCServiceKit

class ViewController: UIViewController {
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        return webView
    }()

    lazy var bridge: NativeRPCWebViewJSBridge = {
        return NativeRPCWebViewJSBridge(webView: webView, viewController: self)
    }()

    deinit {
        // Close the connection when the view controller is deinitialized
        bridge.closeConnection()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register your service
        NativeRPCServiceCenter.registerService(NativeRPCAppService.self)
        // Establish connection with the bridge
        bridge.startConnection(connection)
    }
}
```

In the web page, you can use the `native-rpc-h5` npm package to send messages and invoke methods.

```ts
import NativeRPC from 'iwut-native-rpc-h5';

// Method call example
type AppInfo = {
    appId: string;
    appName: string;
    appVersion: string;
    systemVersion: string;
};

const response = await NativeRPC.call<AppInfo>('app.info');
console.log(response.appVersion);

// Event subscription example
NativeRPC.on('app.enterForeground', () => {
    console.log('App entered foreground');
});
```

See [here](https://github.com/FeliksLv01/native-rpc-h5) for more details.

## Features

Current Features:

-   WKWebView integration support
-   Separated method calls and event notifications
    -   Event subscription and notification support
    -   Bidirectional event dispatch and handling
-   Type-safe parameter passing and return values
-   Async operation support with callback IDs
-   Bidirectional communication support:
    -   Cross-platform method invocation
    -   Native notification listening
    -   Cross-platform notification dispatch
-   Connection context awareness

Coming Soon:

-   JavaScriptCore integration
-   WebSocket connection support
-   More connection types...

## Requirements

-   iOS/macOS
-   Swift 5.0+
