//
//  NativeRPCServiceCenter.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/9.
//

#import "NativeRPCServiceCenter.h"
#import "NativeRPCAppService.h"

@interface NativeRPCServiceCenter ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *serviceMap;

@end

@implementation NativeRPCServiceCenter

+ (NativeRPCServiceCenter *)sharedCenter {
    static NativeRPCServiceCenter *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[NativeRPCServiceCenter alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _serviceMap = [NSMutableDictionary dictionaryWithDictionary:@{
            @"app": [NativeRPCAppService class],
        }];
    }

    return self;
}

- (void)registerService:(Class)service {
    if ([service conformsToProtocol:@protocol(NativeRPCService)]) {
        NSString *serviceName = [service serviceName];

        if (serviceName) {
            [_serviceMap setObject:service forKey:serviceName];
        }
    }
}

- (Class)serviceWithServiceName:(NSString *)serviceName {
    return [_serviceMap objectForKey:serviceName];
}

@end
