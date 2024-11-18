//
//  NSDictionary+SafeKit.m
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/6.
//

#import "NativeRPCLog.h"
#import "NSDictionary+SafeKit.h"

@implementation NSDictionary (SafeKit)

- (NSString *)jsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (error) {
            RPCLogError("Error serializing to JSON: %@", error.localizedDescription);
            return @"";
        }
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ? : @"";
    }
    return @"";
}

- (NSString *)stringForKey:(id)key {
    id value = [self objectForKey:key];

    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [(id)value stringValue];
    }

    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)key {
    id value = [self objectForKey:key];

    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }

    return nil;
}

@end
