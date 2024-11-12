//
//  NativeRPCError.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NativeRPCResponseCode) {
    NativeRPCResponseCodeSuccess             = 1000,
    NativeRPCResponseCodeInvalidParams       = 1001,
    NativeRPCResponseCodeUnauthorized        = 1002,
    NativeRPCResponseCodeAccessDenied        = 1003,
    NativeRPCResponseCodeNotFound            = 1004,
    NativeRPCResponseCodeUserDefined         = 1099,
};

@class NativeRPCMessage;
@interface NativeRPCError : NSError

+ (instancetype)errorWithCode:(NativeRPCResponseCode)code message:(nullable NSString *)message;
+ (instancetype)invalidParamsErrorWithMessage:(nullable NSString *)message;
+ (instancetype)accessDeniedError:(nullable NSString *)message;
+ (instancetype)userDefinedError:(nullable NSString *)message;

@end

NS_ASSUME_NONNULL_END
