//
//  NativeRPCServiceCenter.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import <Foundation/Foundation.h>
#import "NativeRPCService.h"

NS_ASSUME_NONNULL_BEGIN

/// 服务中心，管理服务注册和调用
@interface NativeRPCServiceCenter : NSObject

@property (nonatomic, class, readonly) NativeRPCServiceCenter *sharedCenter;

- (void)registerService:(Class)service;
- (Class)serviceWithServiceName:(NSString *)serviceName;

@end

NS_ASSUME_NONNULL_END
