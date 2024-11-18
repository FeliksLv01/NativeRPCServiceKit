//
//  NativeRPCConnection.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/8.
//

#import <Foundation/Foundation.h>
#import "NativeRPCContext.h"
#import "NativeRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/// Native RPC 连接，连接是复用的，一次连接可以传输多个数据
@interface NativeRPCConnection : NSObject
@property (nonatomic, readonly, nonnull) NativeRPCContext *context;
+ (instancetype)connectionWithContext:(NativeRPCContext *)context;

// 开启连接，初始化 stub
- (void)start;
// 手动断开连接，销毁 stub，同时会释放依赖的 NativeRPCService 实例
- (void)close;

- (void)onReceiveMessage:(NSDictionary *)message;
- (void)sendMessage:(NativeRPCResponse *)message;

@end

NS_ASSUME_NONNULL_END
