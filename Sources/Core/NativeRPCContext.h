//
//  NativeRPCContext.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, NativeRPCConnectionType) {
    NativeRPCConnectionTypeUnknown   = 0,
    NativeRPCConnectionTypeWebView   = 1 << 1,
    NativeRPCConnectionTypeJSCore    = 1 << 2,
    NativeRPCConnectionTypeWebSocket = 1 << 3,
    NativeRPCConnectionTypeFlutter   = 1 << 4,
    NativeRPCConnectionTypeAll       = ~0UL
};

/// RPC上下文
@interface NativeRPCContext : NSObject

@property (nonatomic, assign) NativeRPCConnectionType connectionType;
// WebView/RCTRootView/...
@property (nonatomic, weak, nullable) __kindof UIView *rootView;
@property (nonatomic, weak, nullable) UIViewController *viewController;

+ (instancetype)contextWithConnectionType:(NativeRPCConnectionType)connectionType rootView:(nullable UIView *)rootView viewController:(nullable UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
