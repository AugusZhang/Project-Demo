//
//  YTKBatchRequest.m
//
//  Copyright (c) 2012-2016 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "YTKBatchRequest.h"
#import "YTKNetworkPrivate.h"
#import "YTKBatchRequestAgent.h"
#import "YTKRequest.h"
#import "YTKNetworkAgent.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface YTKBatchRequest() <YTKForBatchRequestDelegate>

@property (nonatomic,assign) NSInteger finishedCount;

@end

@implementation YTKBatchRequest

- (instancetype)initWithRequestArray:(NSArray<YTKRequest *> *)requestArray {
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (YTKRequest * req in _requestArray) {
            if (![req isKindOfClass:[YTKRequest class]]) {
                YTKLog(@"Error, request item must be YTKRequest instance.");
                return nil;
            }
        }
    }
    return self;
}

- (void)start {
    
    //如果网络没连接，不做请求。
    if (![YTKNetworkAgent sharedAgent].manager.reachabilityManager.isReachable) {
        return;
    }
    
    if (_finishedCount > 0) {
        YTKLog(@"Error! Batch request has already started.");
        return;
    }
    _finishedCount = 0;
    if (self.showHUDdelegate != nil && [self.showHUDdelegate respondsToSelector:@selector(batchRequestHUDStart:)]) {
        [self.showHUDdelegate batchRequestHUDStart:self];
    }
    
    _failedRequest = nil;
    [[YTKBatchRequestAgent sharedAgent] addBatchRequest:self];
    [self toggleAccessoriesWillStartCallBack];
    for (YTKRequest * req in _requestArray) {
        req.forBatchRequestdelegate = self;
        [req clearCompletionBlock];
        [req start];
    }
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    
    //    _delegate = nil;
    //停止请求 关闭HUD
    if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(batchrequestHUDFinished:isSuccess:)]) {
        [self.showHUDdelegate batchrequestHUDFinished:self isSuccess:NO];
    }
    
    [self clearRequest];
    [self toggleAccessoriesDidStopCallBack];
    [[YTKBatchRequestAgent sharedAgent] removeBatchRequest:self];
    _finishedCount = 0;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(YTKBatchRequest *batchRequest))success
                                    failure:(void (^)(YTKBatchRequest *batchRequest))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(YTKBatchRequest *batchRequest))success
                              failure:(void (^)(YTKBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    /** 不主动打断，必须用weakSelf */
    //    self.successCompletionBlock = nil;
    //    self.failureCompletionBlock = nil;
}

- (BOOL)isDataFromCache {
    BOOL result = YES;
    for (YTKRequest *request in _requestArray) {
        if (!request.isDataFromCache) {
            result = NO;
        }
    }
    return result;
}


- (void)dealloc {
    [self clearRequest];
    [[YTKBatchRequestAgent sharedAgent] removeBatchRequest:self];
}

#pragma mark - Network for batch Request Delegate

- (void)requestForBatchFinished:(__kindof YTKBaseRequest *)request {
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        [self toggleAccessoriesWillStopCallBack];
        if ([_delegate respondsToSelector:@selector(batchRequestSuccess:)]) {
            [_delegate batchRequestSuccess:self];
        }
        
        if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(batchrequestHUDFinished:isSuccess:)]) {
            [self.showHUDdelegate batchrequestHUDFinished:self isSuccess:YES];
        }
        
        if (self.pageAbledelegate != nil && [self.pageAbledelegate respondsToSelector:@selector(batchRequestPageDataSuccess:)]) {
            [self.pageAbledelegate batchRequestPageDataSuccess:self];
        }
        
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
        [self toggleAccessoriesDidStopCallBack];
        [[YTKBatchRequestAgent sharedAgent] removeBatchRequest:self];
        _finishedCount = 0;
        [self clearForBatchRequestdelegate];
    }
}

- (void)requestForBatchFailed:(__kindof YTKBaseRequest *)request{
    _failedRequest = request;
    _requestFailedTipString = _failedRequest.requestFailedTipString;
    
    [self toggleAccessoriesWillStopCallBack];
    // Stop
    for (YTKRequest *req in _requestArray) {
        [req stop];
    }
    // Callback
    if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [self.delegate batchRequestFailed:self];
    }
    
    if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(batchrequestHUDFinished:isSuccess:)]) {
        [self.showHUDdelegate batchrequestHUDFinished:self isSuccess:NO];
    }
    
    if (self.pageAbledelegate != nil && [self.pageAbledelegate respondsToSelector:@selector(batchRequestPageDataFailed:)]) {
        [self.pageAbledelegate batchRequestPageDataFailed:self];
    }
    
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }
    // Clear
    [self clearCompletionBlock];
    
    [self toggleAccessoriesDidStopCallBack];
    [[YTKBatchRequestAgent sharedAgent] removeBatchRequest:self];
    _finishedCount = 0;
    [self clearForBatchRequestdelegate];
}

- (void)clearRequest {
    for (YTKRequest * req in _requestArray) {
        req.forBatchRequestdelegate = nil;
        
        [req stop];
        
    }
    [self clearCompletionBlock];
}

- (void)clearForBatchRequestdelegate{
    /** 开始请求时会添加，结束时清除，避免单调其中一个接口时走这边的代理 */
    for (YTKRequest * req in _requestArray) {
        req.forBatchRequestdelegate = nil;
    }
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<YTKRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

@end
