//
//  HUDManager.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/22.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "HUDManager.h"

@interface HUDManager ()
{
    BOOL _isIgnoreShowHUD;
    BOOL _isBatchRequestIgnoreShowHUD;
    BOOL _isBatchRequesting;
    BOOL _ischainRequesting;
}
@property (nonatomic, weak) UIView *containerView;

@end

@implementation HUDManager

- (instancetype)initWithContainerView:(UIView *)view
{
    self = [super init];
    if (self) {
        _containerView = view;
        _isIgnoreShowHUD = NO;
        _isBatchRequestIgnoreShowHUD = NO;
        _isBatchRequesting = NO;
        _ischainRequesting = NO;
    }
    return self;
}

#pragma mark- YTKRequestHUDDelegate
- (void)requestHUDStart:(__kindof YTKBaseRequest *)request{
    if (!request.showHUDdelegate.isIgnoreShowHUD && !_isBatchRequesting && !_ischainRequesting) {
        [self showHUD:request.startRequestTipString];
    }
}

- (void)requestHUDFinished:(__kindof YTKBaseRequest *)request isSuccess:(BOOL)isSuccess{
    
    if (!request.showHUDdelegate.isIgnoreShowHUD && !_isBatchRequesting && !_ischainRequesting) {
        [self hiddenHUD];
        [self showTips:isSuccess?request.requestSuccessTipString:request.requestFailedTipString];
    }
}

/** 必须重写set Get方法 ，代理找属性的方法*/
- (BOOL)isIgnoreShowHUD{
    return _isIgnoreShowHUD;
}

- (void)setIsIgnoreShowHUD:(BOOL)isIgnoreShowHUD{
    _isIgnoreShowHUD = isIgnoreShowHUD;
}

#pragma mark- YTKBatchRequestHUDDelegate
- (void)batchRequestHUDStart:(__kindof YTKBatchRequest *)request{
    _isBatchRequesting = YES;
    if (!request.showHUDdelegate.isBatchRequestIgnoreShowHUD) {
        [self showHUD:request.startRequestTipString];
    }
}

- (void)batchrequestHUDFinished:(__kindof YTKBatchRequest *)request isSuccess:(BOOL)isSuccess{
    if (!request.showHUDdelegate.isBatchRequestIgnoreShowHUD) {
        [self hiddenHUD];
        [self showTips:isSuccess?request.requestSuccessTipString:request.requestFailedTipString];
    }
    _isBatchRequesting = NO;
}


- (BOOL)isBatchRequestIgnoreShowHUD{
    return _isBatchRequestIgnoreShowHUD;
}

- (void)setIsBatchRequestIgnoreShowHUD:(BOOL)isBatchRequestIgnoreShowHUD{
    _isBatchRequestIgnoreShowHUD = isBatchRequestIgnoreShowHUD;
}

#pragma mark- YTKChainRequestHUDDelegate
- (void)chainRequestHUDStart:(__kindof YTKBatchRequest *)request{
    _ischainRequesting = YES;
    if (self.containerView) {
        [MBProgressHUD showLoading:@"chainHUDShow" toView:self.containerView];
    }else{
        [MBProgressHUD showLoading:nil];
    }
}

- (void)chainRequestHUDFinished:(__kindof YTKBatchRequest *)request isSuccess:(BOOL)isSuccess{
    _ischainRequesting = NO;
    [self hiddenHUD];
    [self showTips:isSuccess?request.requestSuccessTipString:request.requestFailedTipString];
}

- (void)showHUD:(NSString *)startRequestTipString{
    if (startRequestTipString && startRequestTipString.length) {
        if (self.containerView) {
            [MBProgressHUD showLoading:startRequestTipString toView:self.containerView];
        }else{
            [MBProgressHUD showLoading:startRequestTipString];
        }
    }else{
        if (self.containerView) {
            [MBProgressHUD showLoading:nil toView:self.containerView];
        }else{
            [MBProgressHUD showLoading:nil];
        }
    }
}

- (void)hiddenHUD{
    if (self.containerView) {
        [MBProgressHUD hideHUDForView:self.containerView];
    }else{
        [MBProgressHUD hideHUD];
    }
}

- (void)showTips:(NSString *)tips{
    if (tips && tips.length) {
        if (self.containerView) {
            [MBProgressHUD showTips:tips toView:self.containerView];
        }else{
            [MBProgressHUD showSuccess:tips];
        }
    }
}


- (void)dealloc
{
    
}

@end
