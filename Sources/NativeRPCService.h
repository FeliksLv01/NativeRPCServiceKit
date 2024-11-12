//
//  NativeRPCService.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import <Foundation/Foundation.h>
#import "NativeRPCConnection.h"
#import "NativeRPCMessage.h"
#import "NativeRPCError.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NativeRPCServiceCallback)(NSDictionary *_Nullable, NativeRPCError *_Nullable);

@protocol NativeRPCService <NSObject>

+ (NSString *)serviceName;
+ (NativeRPCConnectionType)supportedConnectionType;
- (void)receiveMessage:(NativeRPCRequest *)message;
- (BOOL)canHandleMethod:(NSString *)method;

@end

@class NativeRPCStub;


#define RPC_EXPORT_METHOD(_name)                     \
- (void)_name:(NativeRPCRequest *)message callback:(NativeRPCServiceCallback)callback

/// Native 基础能力 RPC 服务
@interface NativeRPCService : NSObject <NativeRPCService>

@property (nonatomic, weak, nullable) NativeRPCStub *stub;

+ (NSString *)serviceName;
+ (NativeRPCConnectionType)supportedConnectionType;

- (void)handleMessage:(NativeRPCRequest *)message callback:(NativeRPCServiceCallback)callback;

- (void)postEvent:(NSString *)event data:(nullable NSDictionary *)data;
- (void)postEvent:(NSString *)event error:(NativeRPCError *)error;

- (void)addEventListener:(NSString *)event;
- (void)removeEventListener:(NSString *)event;

@end

NS_ASSUME_NONNULL_END
