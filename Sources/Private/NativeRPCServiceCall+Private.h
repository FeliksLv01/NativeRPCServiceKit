//
//  NativeRPCServiceCall+Private.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/15.
//

#import "NativeRPCServiceCall.h"
#import "NativeRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeRPCServiceCall ()

+ (instancetype)callFromRequest:(NativeRPCRequest *)message successHandler:(NativeRPCServiceCallSuccessHandler)successHandler errorHandler:(NativeRPCServiceCallErrorHandler)errorHandler;

- (NativeRPCRequest *)request;

@end

NS_ASSUME_NONNULL_END
