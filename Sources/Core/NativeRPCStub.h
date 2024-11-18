//
//  NativeRPCStub.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import <Foundation/Foundation.h>
#import "NativeRPCContext.h"

NS_ASSUME_NONNULL_BEGIN
// 消息收发站
@interface NativeRPCStub : NSObject
+ (instancetype)stubWithContext:(NativeRPCContext *)context;

- (void)onReceiveMessage:(NSDictionary *)message;
- (void)sendMessage:(NSDictionary *)message;
@end

NS_ASSUME_NONNULL_END
