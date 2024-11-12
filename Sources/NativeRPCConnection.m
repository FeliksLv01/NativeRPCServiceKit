//
//  NativeRPCConnection.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/8.
//

#import "NativeRPCConnection.h"
#import "NativeRPCStub.h"

@interface NativeRPCConnection ()
@property(nonatomic) NativeRPCContext *context;
@property(nonatomic) NativeRPCStub *stub;
@end

@implementation NativeRPCConnection

+ (instancetype)connectionWithContext:(NativeRPCContext *)context {
  NativeRPCConnection *connection = [[NativeRPCConnection alloc] init];
  connection.context = context;
  return connection;
}

- (void)start {
  self.stub = [NativeRPCStub stubWithContext:self.context];
}

- (void)close {
  // 销毁 stub
  self.stub = nil;
}

- (void)onReceiveMessage:(NSDictionary *)message {
  [self.stub onReceiveMessage:message];
}

- (void)sendMessage:(NativeRPCResponse *)message {
    [self.stub sendMessage:message];
}

@end
