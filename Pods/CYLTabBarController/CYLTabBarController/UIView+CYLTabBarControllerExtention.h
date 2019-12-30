//
//  CYLTabBarController.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYLConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CYLTabBarControllerExtention)

- (BOOL)cyl_isPlusButton;
- (BOOL)cyl_isTabButton;
- (BOOL)cyl_isTabImageView;
- (BOOL)cyl_isTabLabel;
- (BOOL)cyl_isTabBadgeView;
- (BOOL)cyl_isTabBackgroundView;
- (nullable UIView *)cyl_tabBadgeView;
- (nullable UIImageView *)cyl_tabImageView;
- (nullable UILabel *)cyl_tabLabel;
- (nullable UIImageView *)cyl_tabShadowImageView;
- (nullable UIVisualEffectView *)cyl_tabEffectView;
- (BOOL)cyl_isLottieAnimationView;
- (nullable UIView *)cyl_tabBackgroundView;
+ (UIView *)cyl_tabBadgePointViewWithClolor:(UIColor *)color radius:(CGFloat)radius;
- (NSArray *)cyl_allSubviews;

@end

@interface UIView (CYLTabBarControllerExtentionDeprecated)
- (nullable UIView *)cyl_tabBadgeBackgroundView CYL_DEPRECATED("Deprecated in 1.6.0. Use `+[CYLPlusButton cyl_tabBackgroundView]` instead.");
- (nullable UIView *)cyl_tabBadgeBackgroundSeparator CYL_DEPRECATED("Deprecated in 1.6.0. Use `+[CYLPlusButton cyl_tabShadowImageView]` instead.");


@end

NS_ASSUME_NONNULL_END
