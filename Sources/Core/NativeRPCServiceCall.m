//
//  NativeRPCServiceCall.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/15.
//

#import "NativeRPCServiceCall+Private.h"
#import "NativeRPCMessage.h"

@interface NativeRPCServiceCall ()

@property (nonatomic, strong) NativeRPCRequest *request;
@property (nonatomic, copy) NativeRPCServiceCallSuccessHandler successHandler;
@property (nonatomic, copy) NativeRPCServiceCallErrorHandler errorHandler;

@end

@implementation NativeRPCServiceCall

+ (instancetype)callFromRequest:(NativeRPCRequest *)message successHandler:(NativeRPCServiceCallSuccessHandler)successHandler errorHandler:(NativeRPCServiceCallErrorHandler)errorHandler {
    NativeRPCServiceCall *call = [NativeRPCServiceCall new];
    call.request = message;
    call.successHandler = successHandler;
    call.errorHandler = errorHandler;
    return call;
}

- (NativeRPCRequest *)request {
    return _request;
}

@end
