//
//  AppDelegate+NetWorkConfiguration.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/16.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "AppDelegate+NetWorkConfiguration.h"
#import <AFNetworking.h>

@implementation AppDelegate (NetWorkConfiguration)

/** 配置 */
- (void)configNetWorkWithOptions:(NSDictionary *)launchOptions{
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"https://mobile.jinchehui.com";
    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//    }];
//    [manager startMonitoring];
    
}

@end
