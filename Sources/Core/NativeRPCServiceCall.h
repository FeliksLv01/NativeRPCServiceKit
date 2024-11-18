//
//  NativeRPCServiceCall.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/15.
//

#import <Foundation/Foundation.h>
#import "NativeRPCError.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NativeRPCServiceCallSuccessHandler)(NSDictionary *_Nullable data);
typedef void(^NativeRPCServiceCallErrorHandler)(NativeRPCError *error);

@interface NativeRPCServiceCall : NSObject

@property (nonatomic, copy, readonly, nullable) NSDictionary *params;
@property (nonatomic, copy, readonly) NativeRPCServiceCallSuccessHandler successHandler;
@property (nonatomic, copy, readonly) NativeRPCServiceCallErrorHandler errorHandler;

@end

NS_ASSUME_NONNULL_END
