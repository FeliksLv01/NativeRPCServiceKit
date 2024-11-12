//
//  NSMutableDictionary+SafeKit.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (SafeKit)

- (void)safe_setObject:(id)value forKey:(id <NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
