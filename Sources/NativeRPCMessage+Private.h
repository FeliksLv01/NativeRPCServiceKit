//
//  NativeRPCMessage+Private.h
//  Pods
//
//  Created by FeliksLv on 2024/11/7.
//

#ifndef NativeRPCMessage_Private_h
#define NativeRPCMessage_Private_h

#import "NativeRPCMessage.h"

@protocol NativeRPCMessageMeta <NSObject>
@property (nonatomic, copy, nullable) NSString *callbackId;
@property (nonatomic, copy, nullable) NSString *event;
@end


@interface NativeRPCMessage () <NativeRPCMessageMeta>
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, readonly) id<NativeRPCMessageMeta> meta;
@end


#endif /* NativeRPCMessage_Private_h */
