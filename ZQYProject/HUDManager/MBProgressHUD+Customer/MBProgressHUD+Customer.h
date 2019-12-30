//
//  MBProgressHUD+Customer.h
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 gupeng. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Customer)

+ (void)showLoading:(NSString *)loading toView:(UIView *)view;

/** 成功 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/** 错误 */

+ (void)showError:(NSString *)error toView:(UIView *)view;

/** 警告 */
+ (void)showInfo:(NSString *)info toView:(UIView *)view;

+ (void)showHudTipStr:(NSString *)tipStr toView:(UIView *)view;

/** 文字提示 */
+ (void)showTips:(NSString *)msg toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showLoading:(NSString *)loading;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showInfo:(NSString *)info;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
