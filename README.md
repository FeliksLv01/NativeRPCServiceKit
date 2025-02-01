# NativeRPCServiceKit

Cross Platform Communication Framework.

## How To Use

1. Create a NativeRPCService to expose your native code.

````swift
import NativeRPCServiceKit

@NativeRPCService("app")
class NativeRPCAppService {

    // Simple method with direct parameters and return value
    @NativeRPCMethod
    func demo(name: String) -> String {
        return name
    }

    // Method using NativeRPCServiceCall for more control
    @NativeRPCMethodExport
    func test(_ call: NativeRPCServiceCall) {
        // Access connection context
        print(call.context.connectionType)
        // Resolve the call
        call.resolve()
    }
}

2. Register your service and establish connection.

```swift
// Register your service
NativeRPCServiceCenter.registerService(NativeRPCAppService.self)

// Create and start a connection
let connection = NativeRPCConnection(context: .init(connectionType: .webSocket))
connection.start()
````

3. Send messages to invoke methods.

```swift
// Message format
connection.onReceiveMessage([
    "service": "app",        // Service name defined in @NativeRPCService
    "method": "demo",        // Method name to call
    "_meta": [
        "callbackId": 111    // Callback ID for async operations
    ],
    "params": [             // Method parameters
        "name": "FeliksLv"
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
import NativeRPC from '@iwut/native-rpc-h5';

type AppInfo = {
	appId: string;
	appName: string;
	appVersion: string;
	systemVersion: string;
};

NativeRPC.call<AppInfo>('app.info').then((res) => {
	console.log(res.appVersion);
});

const response = await NativeRPC.call<AppInfo>('app.info');
console.log(response.appVersion);
```

See [here](https://github.com/FeliksLv01/native-rpc-h5) for more details.

## Features

Current Features:

-   WKWebView integration support
-   Method decoration with `@NativeRPCMethod` and `@NativeRPCMethodExport`
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
