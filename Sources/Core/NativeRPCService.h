//
//  NativeRPCService.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import <Foundation/Foundation.h>
#import "NativeRPCConnection.h"
#import "NativeRPCError.h"

NS_ASSUME_NONNULL_BEGIN

@class NativeRPCStub;

/// Native 基础能力 RPC 服务
@interface NativeRPCService : NSObject

@property (nonatomic, weak, nullable) NativeRPCStub *stub;

+ (NSString *)serviceName;
+ (NativeRPCConnectionType)supportedConnectionType;

- (void)postEvent:(NSString *)event data:(nullable NSDictionary *)data;
- (void)postEvent:(NSString *)event error:(NativeRPCError *)error;

- (void)addEventListener:(NSString *)event;
- (void)removeEventListener:(NSString *)event;

@end

NS_ASSUME_NONNULL_END
