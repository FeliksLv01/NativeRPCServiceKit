//
//  NativeRPCService+Private.h
//  Pods
//
//  Created by FeliksLv on 2024/11/15.
//

#ifndef NativeRPCService_Private_h
#define NativeRPCService_Private_h

#import "NativeRPCConnection.h"
#import "NativeRPCService.h"
#import "NativeRPCMessage.h"

@protocol NativeRPCService <NSObject>

+ (NSString *)serviceName;
+ (NativeRPCConnectionType)supportedConnectionType;

@end

@interface NativeRPCService () <NativeRPCService>

- (void)receiveMessage:(NativeRPCRequest *)message;
- (BOOL)canHandleMethod:(NSString *)method;

@end

#endif /* NativeRPCService_Private_h */
