//
//  HUDManager.h
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/22.
//  Copyright © 2019 zqy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUDManager : NSObject<YTKRequestHUDDelegate,YTKBatchRequestHUDDelegate,YTKChainRequestHUDDelegate>

- (instancetype)initWithContainerView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
