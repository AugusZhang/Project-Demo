//
//  YTKChainRequest.m
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

#import "YTKChainRequest.h"
#import "YTKChainRequestAgent.h"
#import "YTKNetworkPrivate.h"
#import "YTKBaseRequest.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface YTKChainRequest()<YTKForChainRequestDelegate>

@property (strong, nonatomic) NSMutableArray<YTKBaseRequest *> *requestArray;
@property (strong, nonatomic) NSMutableArray<YTKChainCallback> *requestCallbackArray;
@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) YTKChainCallback emptyCallback;

@end

@implementation YTKChainRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest) {
            // do nothing
        };
    }
    return self;
}

- (void)start {
    //如果网络没连接，不做请求。
    if (![YTKNetworkAgent sharedAgent].manager.reachabilityManager.isReachable) {
        return;
    }
    
    
    if (_nextRequestIndex > 0) {
        YTKLog(@"Error! Chain request has already started.");
        return;
    }
    
    if ([_requestArray count] > 0) {
        if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(chainRequestHUDStart:)]) {
            [self.showHUDdelegate chainRequestHUDStart:self];
        }
        [self toggleAccessoriesWillStartCallBack];
        [self startNextRequest];
        [[YTKChainRequestAgent sharedAgent] addChainRequest:self];
    } else {
        YTKLog(@"Error! Chain request array is empty.");
    }
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    //停止请求 关闭HUD
    if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(chainRequestHUDFinished:isSuccess:)]) {
        [self.showHUDdelegate chainRequestHUDFinished:self isSuccess:NO];
    }
    [self clearRequest];
    [[YTKChainRequestAgent sharedAgent] removeChainRequest:self];
    [self toggleAccessoriesDidStopCallBack];
    
    _nextRequestIndex = 0;
    [self clearForChainRequestdelegate];
}

- (void)addRequest:(YTKBaseRequest *)request callback:(YTKChainCallback)callback {
    
    //多次调用时 block里会多次添加，所以加个条件限制
    if (![_requestArray containsObject:request]) {
        [_requestArray addObject:request];
    }
    
    if (callback != nil) {
        [_requestCallbackArray addObject:callback];
    } else {
        [_requestCallbackArray addObject:_emptyCallback];
    }
}

- (NSArray<YTKBaseRequest *> *)requestArray {
    return _requestArray;
}

- (BOOL)startNextRequest {
    if (_nextRequestIndex < [_requestArray count]) {
        YTKBaseRequest *request = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        request.forChainRequestdelegate = self;
        [request clearCompletionBlock];
        [request start];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Network Request Delegate

- (void)requestForChainFinished:(__kindof YTKBaseRequest *)request{
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    YTKChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, request);
    if (![self startNextRequest]) {
        [self toggleAccessoriesWillStopCallBack];
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            [_delegate chainRequestFinished:self];
        }
        if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(chainRequestHUDFinished:isSuccess:)]) {
            [self.showHUDdelegate chainRequestHUDFinished:self isSuccess:YES];
        }
        [self toggleAccessoriesDidStopCallBack];
        [[YTKChainRequestAgent sharedAgent] removeChainRequest:self];
        _nextRequestIndex = 0;
        [self clearForChainRequestdelegate];
    }
}

- (void)requestForChainFailed:(YTKBaseRequest *)request {
    _requestFailedTipString = request.requestFailedTipString;
    [self toggleAccessoriesWillStopCallBack];
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        [_delegate chainRequestFailed:self failedBaseRequest:request];
    }
    if (self.showHUDdelegate !=nil && [self.showHUDdelegate respondsToSelector:@selector(chainRequestHUDFinished:isSuccess:)]) {
        [self.showHUDdelegate chainRequestHUDFinished:self isSuccess:NO];
    }
    [self toggleAccessoriesDidStopCallBack];
    [[YTKChainRequestAgent sharedAgent] removeChainRequest:self];
    _nextRequestIndex = 0;
    [self clearForChainRequestdelegate];
}

- (void)clearRequest {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        YTKBaseRequest *request = _requestArray[currentRequestIndex];
        [request stop];
    }
    //    [_requestArray removeAllObjects];
    //    [_requestCallbackArray removeAllObjects];
}

- (void)clearForChainRequestdelegate{
    /** 开始请求时会添加，结束时清除，避免单调其中一个接口时走这边的代理 */
    for (YTKRequest * req in _requestArray) {
        req.forChainRequestdelegate = nil;
    }
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<YTKRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

- (void)dealloc
{
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
    _emptyCallback = nil;
}

@end
