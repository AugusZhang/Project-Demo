//
//  RefreshAndMorePageManager.h
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/16.
//  Copyright © 2019 zqy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshAndMorePageManager : NSObject <YTKRequestPageAbleDelegate,YTKBatchRequestPageAbleDelegate>

- (instancetype)initWithScrollView:(UIScrollView *)scrollView baseRequest:(YTKRequest *)baseRequest;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView batchRequest:(YTKBatchRequest *)batchRequest baseRequest:(YTKRequest *)baseRequest;

@end

NS_ASSUME_NONNULL_END
