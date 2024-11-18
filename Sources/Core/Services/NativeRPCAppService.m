//
//  NativeRPCAppService.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/13.
//

#import "NativeRPCAPPService.h"

static NSString * const NativeRPCServiceEnterBackgroundEvent = @"enterBackground";
static NSString * const NativeRPCServiceEnterForegroundEvent = @"enterForeground";

@implementation NativeRPCAppService

+ (NSString *)serviceName {
    return @"app";
}

+ (NativeRPCConnectionType)supportedConnectionType {
    return NativeRPCConnectionTypeAll;
}

- (void)addEventListener:(NSString *)event {
    if ([event isEqualToString:NativeRPCServiceEnterBackgroundEvent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(enterBackground:)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:nil];
        
    }
    else if ([event isEqualToString:NativeRPCServiceEnterForegroundEvent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(enterForeground:)
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
    }
}

- (void)enterBackground:(NSNotification *)noti {
    [self postEvent:NativeRPCServiceEnterBackgroundEvent data:nil];
}

- (void)enterForeground:(NSNotification *)noti {
    [self postEvent:NativeRPCServiceEnterForegroundEvent data:nil];
}

@end
