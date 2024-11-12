//
//  NativeRPCMessage.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/6.
//

#import "NativeRPCError.h"
#import "NativeRPCMessage+Private.h"
#import "NativeRPCMessage.h"
#import "NSDictionary+SafeKit.h"
#import "NSMutableDictionary+SafeKit.h"

@implementation NativeRPCMessage
@synthesize callbackId = _callbackId, event = _event;

+ (instancetype)messageWithJSONObject:(NSDictionary *)json {
    NSString *service = [json stringForKey:@"service"];
    NSString *method = [json stringForKey:@"method"];

    if (service == nil || method == nil) {
        return nil;
    }

    NSDictionary *meta = [json dictionaryForKey:@"_meta"];
    NSString *callbackId = [meta stringForKey:@"callbackId"];
    NSString *event = [meta stringForKey:@"event"];
    NativeRPCMessage *message = [[self alloc] init];
    message->_service = service;
    message->_method = method;
    message->_callbackId = callbackId;
    message->_event = event;
    return message;
}

- (id<NativeRPCMessageMeta>)meta {
    return self;
}

@end

@interface NativeRPCRequest ()
@property (nonatomic, copy) NSDictionary *params;
@end

@implementation NativeRPCRequest

+ (instancetype)messageWithJSONObject:(NSDictionary *)json {
    NativeRPCRequest *message = [super messageWithJSONObject:json];

    message.params = [json dictionaryForKey:@"params"];
    return message;
}

@end

@implementation NativeRPCResponse

+ (instancetype)responseForRequest:(NativeRPCMessage *)request {
    NativeRPCResponse *response = [NativeRPCResponse new];

    response.callbackId = request.callbackId;
    response.service = request.service;
    response.method = request.method;
    return response;
}

- (NSDictionary *)JSONObject {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json safe_setObject:self.service forKey:@"service"];
    [json safe_setObject:self.method forKey:@"method"];
    NSMutableDictionary *meta = [NSMutableDictionary dictionary];
    
    [meta safe_setObject:self.meta.callbackId forKey:@"callbackId"];
    [meta safe_setObject:self.meta.event forKey:@"event"];
    json[@"_meta"] = meta;
    if (self.error) {
        [json safe_setObject:@(self.error.code) forKey:@"code"];
        [json safe_setObject:self.error.description forKey:@"message"];
    } else {
        [json safe_setObject:@(NativeRPCResponseCodeSuccess) forKey:@"code"];
        [json safe_setObject:self.data forKey:@"data"];
    }

    return json;
}

@end
