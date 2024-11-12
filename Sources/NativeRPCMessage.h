//
//  NativeRPCMessage.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeRPCMessage : NSObject
@property (nonatomic, copy, readonly) NSString *service;
@property (nonatomic, copy, readonly) NSString *method;
+ (instancetype)messageWithJSONObject:(NSDictionary *)json;
@end

@class NativeRPCResponse;
@interface NativeRPCRequest : NativeRPCMessage

@property (nonatomic, copy, readonly) NSDictionary *params;
+ (instancetype)messageWithJSONObject:(NSDictionary *)json;
- (NativeRPCResponse *)makeResponse;

@end

@class NativeRPCError;
@interface NativeRPCResponse : NativeRPCMessage
@property (nonatomic, copy, nullable) NSDictionary *data;
@property (nonatomic, strong, nullable) NativeRPCError *error;

+ (instancetype)responseForRequest:(NativeRPCMessage *)request;
- (NSDictionary *)JSONObject;
@end

NS_ASSUME_NONNULL_END
