//
//  NSMutableDictionary+SafeKit.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/12.
//

#import "NSMutableDictionary+SafeKit.h"

@implementation NSMutableDictionary (SafeKit)

- (void)safe_setObject:(id)value forKey:(id<NSCopying>)key {
    if (!value) {
        return;
    }
    [self setObject:value forKey:key];
}

@end
