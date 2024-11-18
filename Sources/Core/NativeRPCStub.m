//
//  NativeRPCStub.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import <WebKit/WebKit.h>
#import "NativeRPCService.h"
#import "NativeRPCServiceCenter.h"
#import "NativeRPCStub.h"
#import "NSDictionary+SafeKit.h"
#import "NativeRPCLog.h"
#import "NativeRPCService+Private.h"

@interface NativeRPCStub ()
@property (nonatomic, strong) NSMapTable<NSString *, NativeRPCService *> *services;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *events;
@property (nonatomic, weak) NativeRPCContext *context;
@end

@implementation NativeRPCStub

+ (instancetype)stubWithContext:(NativeRPCContext *)context {
    NativeRPCStub *stub = [[NativeRPCStub alloc] init];
    stub.context = context;
    return stub;
}

- (instancetype)init {
    if (self = [super init]) {
        _services = [NSMapTable strongToStrongObjectsMapTable];
        _events = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)onReceiveMessage:(NSDictionary *)message {
#if DEBUG
    RPCLogDebug("receiveMessage: %@", [message jsonString]);
#endif
    NativeRPCRequest *request = [NativeRPCRequest messageWithJSONObject:message];
    if (!request) {
        RPCLogError("invalid request message %@", [message jsonString]);
        return;
    }
    NativeRPCService *service = [_services objectForKey:request.service];
    if (!service) {
        Class serviceType = [[NativeRPCServiceCenter sharedCenter] serviceWithServiceName:request.service];
        if (!serviceType) {
            RPCLogError("Cannot found service %@", request.service);
            return;
        }
        service = [[serviceType alloc] init];
        service.stub = self;
        [_services setObject:service forKey:request.service];
    }
    [service receiveMessage:request];
}

- (void)sendMessage:(NSDictionary *)message {
    switch (self.context.connectionType) {
        case NativeRPCConnectionTypeWebView:
            [self sendMessageToWebView:message];
            break;

        default:
            break;
    }
}

- (void)sendMessageToWebView:(NSDictionary *)message {
    NSString *dataString = [message jsonString];
#if DEBUG
    RPCLogDebug("sendMessage: %@", dataString);
#endif
    if (self.context.connectionType == NativeRPCConnectionTypeWebView &&
        [self.context.rootView isKindOfClass:[WKWebView class]]) {
        WKWebView *webview = self.context.rootView;
        NSString *jsCode = [NSString stringWithFormat:@"window.rpcClient.onReceive(%@)", dataString];
        [webview evaluateJavaScript:jsCode completionHandler:^(id data, NSError *error) {
            if (error) {
                RPCLogError("sendMessageToWebView error: %@", error.localizedDescription);
            }
        }];
    }
}

@end
