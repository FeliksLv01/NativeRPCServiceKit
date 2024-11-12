//
//  NativeRPCContext.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/7.
//

#import "NativeRPCContext.h"

@implementation NativeRPCContext

+ (instancetype)contextWithConnectionType:(NativeRPCConnectionType)connectionType
                                 rootView:(UIView *)rootView
                           viewController:(UIViewController *)viewController {
    NativeRPCContext *context = [[NativeRPCContext alloc] init];

    context.connectionType = connectionType;
    context.rootView = rootView;
    context.viewController = viewController;
    return context;
}

@end
