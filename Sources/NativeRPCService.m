//
//  NativeRPCService.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import <objc/message.h>
#import "NativeRPCMessage+Private.h"
#import "NativeRPCService.h"
#import "NativeRPCServiceCenter.h"
#import "NativeRPCStub.h"
#import "NativeRPCLog.h"

#define weakify(var)   __weak typeof(var) weak ## var = var;
#define strongify(var) __strong typeof(weak ## var) var = weak ## var;

static inline BOOL isEmptyString(NSString *str) {
    if (str.length == 0
        || [str isKindOfClass:[NSNull class]]
        || [str isEqualToString:@""]
        || [str isEqualToString:NULL]
        || [str isEqualToString:@"(null)"]
        || str == nil
        || [str isEqualToString:@"<null>"]) {
        return YES;
    }

    return NO;
}

@interface NativeRPCService ()
@property (nonatomic) NSMutableDictionary<NSString *, NSNumber *> *events;
@end

@implementation NativeRPCService

+ (void)load {
    // 确保父类不执行逻辑
    if (self == [NativeRPCService class]) {
        return;
    }

    [[NativeRPCServiceCenter sharedCenter] registerService:self];
}

+ (NSString *)serviceName {
    NSAssert(false, @"Must override +[%@ %s]", NSStringFromClass(self), sel_getName(_cmd));
    return @"";
}

+ (NativeRPCConnectionType)supportedConnectionType {
    return NativeRPCConnectionTypeUnknown;
}

- (BOOL)canHandleMethod:(NSString *)method {
    SEL sel = sel_getUid([method stringByAppendingString:@":callback:"].UTF8String);

    return [self respondsToSelector:sel];
}

- (void)receiveMessage:(NativeRPCRequest *)message {
    weakify(self);
    [self handleMessage:message callback:^(NSDictionary *data, NativeRPCError *error) {
        strongify(self);
        NativeRPCResponse *callbackMessage = [NativeRPCResponse responseForRequest:message];
        callbackMessage.data = data;
        callbackMessage.error = error;
        [self.stub sendMessage:callbackMessage];
    }];
}

- (void)handleMessage:(NativeRPCRequest *)message callback:(NativeRPCServiceCallback)callback {
    SEL sel = sel_getUid([message.method stringByAppendingString:@":callback:"].UTF8String);
    if (![self respondsToSelector:sel]) {
        RPCLogError("Service:%@ cannot handle method:%@", message.service, message.method);
        NSString *msg = [NSString stringWithFormat:@"Service:%@ cannot handle method:%@", message.service, message.method];
        NativeRPCError *error = [NativeRPCError errorWithCode:NativeRPCResponseCodeNotFound message:msg];
        callback(nil, error);
        return;
    }

    ((void (*)(id, SEL, NativeRPCRequest *, NativeRPCServiceCallback))objc_msgSend)(self, sel, message, callback);
}

RPC_EXPORT_METHOD(_addEventListener) {
    NSString *event = message.meta.event;
    if (isEmptyString(event)) {
        callback(nil, [NativeRPCError invalidParamsErrorWithMessage:@"event is null"]);
        return;
    }
            
    NSInteger count = [self.events objectForKey:event].integerValue;
    [self.events setObject:@(count + 1) forKey:event];
    if (count == 0) {
        [self addEventListener:event];
    }
    callback(@{}, nil);
}

RPC_EXPORT_METHOD(_removeEventListener) {
    NSString *event = message.meta.event;
    if (event) {
        NSInteger count = [self.events objectForKey:event].integerValue;
        [self.events setObject:@(MAX(0, count - 1)) forKey:event];

        if (count - 1 == 0) {
            [self removeEventListener:event];
        }

        callback(@{}, nil);
    } else {
        callback(nil, [NativeRPCError invalidParamsErrorWithMessage:@"event is null"]);
    }
}

- (void)addEventListener:(NSString *)event {}
- (void)removeEventListener:(NSString *)event {}

- (void)postEvent:(NSString *)event data:(NSDictionary *)data {
    [self postEvent:event data:data error:nil];
}

- (void)postEvent:(NSString *)event error:(NativeRPCError *)error {
    [self postEvent:event data:nil error:error];
}

- (void)postEvent:(NSString *)event data:(NSDictionary *)data error:(NativeRPCError *)error {
    if (event) {
        NSInteger count = [self.events objectForKey:event].integerValue;
        if (count) {
            NativeRPCResponse *message = [NativeRPCResponse new];
            message.method = @"_event";
            message.service = [self.class serviceName];
            message.meta.event = event;
            message.data = data;
            message.error = error;
            [self.stub sendMessage:message];
        }
    }
}


- (NSMutableDictionary<NSString *,NSNumber *> *)events {
    if (!_events) {
        _events = [NSMutableDictionary dictionary];
    }
    return _events;
}

@end
