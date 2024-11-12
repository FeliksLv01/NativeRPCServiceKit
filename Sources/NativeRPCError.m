//
//  NativeRPCError.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/7.
//

#import "NativeRPCError.h"

@implementation NativeRPCError

+ (instancetype)errorWithCode:(NativeRPCResponseCode)code
                      message:(NSString *)message {
    NSDictionary *userInfo = message ? @{
            @"message": message
        } : nil;

    return [self errorWithDomain:@"com.itoken.team.rpc"
                            code:code
                        userInfo:userInfo];
}

+ (instancetype)invalidParamsErrorWithMessage:(NSString *)message {
    return [self errorWithCode:NativeRPCResponseCodeInvalidParams
                       message:message];
}

+ (instancetype)unauthorizedError {
    return [self errorWithCode:NativeRPCResponseCodeUnauthorized
                       message:@"Unauthorized"];
}

+ (instancetype)accessDeniedError:(NSString *)message {
    return [self errorWithCode:NativeRPCResponseCodeAccessDenied message:message];
}

+ (instancetype)userDefinedError:(NSString *)message {
    return [self errorWithCode:NativeRPCResponseCodeUserDefined
                       message:message ? : @"Unknow error"];
}

@end
