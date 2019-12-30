//
//  MBProgressHUD+Customer.m
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 gupeng. All rights reserved.
//

#import "MBProgressHUD+Customer.h"
static NSInteger const HiddleTime = 2.333;//隐藏时间

@implementation MBProgressHUD (Customer)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
    //先隐藏显示的HUD
    MBProgressHUD *oldHud = [self HUDForView:view];
    if (oldHud) {
        oldHud.removeFromSuperViewOnHide = YES;
        [oldHud hideAnimated:NO];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.contentColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    hud.animationType = MBProgressHUDAnimationFade;
    if (icon && icon.length) {
        // 设置自定义模式
        hud.mode = MBProgressHUDModeCustomView;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD_CJW.bundle/%@", icon]]];
        // 等待多长时间之后再消失
        [hud hideAnimated:YES afterDelay:HiddleTime];
    }
    else{
        // 设置加载菊花的模式
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
}

+ (void)showHudTipStr:(NSString *)tipStr toView:(UIView *)view{
    [self show:tipStr icon:@"sfsf" view:view];
}


/** 文字提示 */
+ (void)showTips:(NSString *)msg toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
    //先隐藏显示的HUD
    MBProgressHUD *oldHud = [self HUDForView:view];
    if (oldHud) {
        oldHud.removeFromSuperViewOnHide = YES;
        [oldHud hideAnimated:NO];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = msg;
    hud.label.numberOfLines = 0;
    hud.contentColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    hud.animationType = MBProgressHUDAnimationFade;
    
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark 显示加载菊花
+ (void)showLoading:(NSString *)loading toView:(UIView *)view{
    [self show:loading icon:nil view:view];
}
+ (void)showLoading:(NSString *)loading
{
     [self show:loading icon:nil view:nil];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"MBHUD_Error" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"MBHUD_Success" view:view];
}
+ (void)showInfo:(NSString *)info toView:(UIView *)view
{
     [self show:info icon:@"MBHUD_Warn" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showInfo:(NSString *)info
{
    [self showInfo:info toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    MBProgressHUD *hud = [self showMessage:message toView:nil];
    
//    [hud hideAnimated:YES afterDelay:1.5];
//    hud.mode = MBProgressHUDModeText;
    
    return hud;
    
 
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

@end
