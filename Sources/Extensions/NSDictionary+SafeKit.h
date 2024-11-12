//
//  NSDictionary+SafeKit.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SafeKit)

- (NSString *)stringForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
