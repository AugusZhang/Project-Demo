//
//  RefreshAndMorePageManager.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/16.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "RefreshAndMorePageManager.h"
#import "MJRefresh.h"
#import "YCDefaultRefreshFooterView.h"

@interface RefreshAndMorePageManager (){
    NSInteger _pageSize;
    BOOL _isLastPage;
}

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) YTKRequest *baseRequest;
@property (nonatomic, weak) YTKBatchRequest *batchRequest;

@property (nonatomic, assign) BOOL kIsHeaderRefresh;
@property (nonatomic, assign) NSUInteger currentPageNumber;

@end

@implementation RefreshAndMorePageManager


- (instancetype)initWithScrollView:(UIScrollView *)scrollView baseRequest:(YTKRequest *)baseRequest{
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        baseRequest.pageAbledelegate = self;
        _baseRequest = baseRequest;
        [self baseConfig];
        @weakify(self);
        _scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.kIsHeaderRefresh = YES;
            if (self.baseRequest.showHUDdelegate) {
                self.baseRequest.showHUDdelegate.isIgnoreShowHUD = YES;
            }
            self.currentPageNumber = 1;
            [self.baseRequest start];
        }];
        _scrollView.mj_header.backgroundColor = [UIColor redColor];
        _scrollView.mj_footer = [YCDefaultRefreshFooterView footerWithRefreshingBlock:^{
            @strongify(self);
            self.kIsHeaderRefresh = NO;
            if (self.baseRequest.showHUDdelegate) {
                self.baseRequest.showHUDdelegate.isIgnoreShowHUD = YES;
            }
            [self.baseRequest start];
        }];
        
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView batchRequest:(YTKBatchRequest *)batchRequest baseRequest:(YTKRequest *)baseRequest{
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _baseRequest = baseRequest;
        _baseRequest.pageAbledelegate = self;
        _batchRequest = batchRequest;
        _batchRequest.pageAbledelegate = self;
        [self baseConfig];
        @weakify(self);
        
        _scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            if (self.batchRequest.showHUDdelegate) {
                self.batchRequest.showHUDdelegate.isBatchRequestIgnoreShowHUD = YES;
            }
            self.currentPageNumber = 1;
            self.kIsHeaderRefresh = YES;
            [self.batchRequest start];
        }];
        _scrollView.mj_footer = [YCDefaultRefreshFooterView footerWithRefreshingBlock:^{
            @strongify(self);
            self.kIsHeaderRefresh = NO;
            if (self.baseRequest.showHUDdelegate) {
                self.baseRequest.showHUDdelegate.isIgnoreShowHUD = YES;
            }
            [self.baseRequest start];
        }];
    }
    return self;
}

- (void)baseConfig{
    _pageSize = 10;
    _currentPageNumber = 1;
    _kIsHeaderRefresh = YES;
    _isLastPage = NO;
}

#pragma mark - YTKRequestPageAbleDelegate
- (void)requestPageDataFailed:(__kindof YTKBaseRequest *)request{
    if (request.showHUDdelegate) {
        request.showHUDdelegate.isIgnoreShowHUD = NO;
    }
    if (self.kIsHeaderRefresh){
        [self.scrollView.mj_header endRefreshing];
    }else{
        [self.scrollView.mj_footer endRefreshing];
    }
}

- (void)requestPageDataSuccess:(__kindof YTKBaseRequest *)request{
    if (request.showHUDdelegate) {
        request.showHUDdelegate.isIgnoreShowHUD = NO;
    }
    NSArray *dataArray = request.responseJSONObject[@"data"];
    if (dataArray.count < _pageSize || dataArray.count==0) {
        _isLastPage = YES;
    }else{
        _isLastPage = NO;
        _currentPageNumber ++;
    }
    if (self.batchRequest && self.kIsHeaderRefresh) {
        return;
    }
    if (self.kIsHeaderRefresh) {
        [self.scrollView.mj_header endRefreshing];
    }else{
        if (_isLastPage) {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.scrollView.mj_footer endRefreshing];
        }
    }
}

- (NSInteger)pageSize{
    return _pageSize;
}

- (NSUInteger)currentPageNumber{
    return _currentPageNumber;
}

- (BOOL)isLastPage{
    return _isLastPage;
}

- (BOOL)isHeaderRefresh{
    return _kIsHeaderRefresh;
}

#pragma mark - YTKBatchRequestPageAbleDelegate 只有头部刷新才有

-(void)batchRequestPageDataFailed:(__kindof YTKBatchRequest *)request{
    if (request.showHUDdelegate) {
        request.showHUDdelegate.isBatchRequestIgnoreShowHUD = NO;
    }
    [self.scrollView.mj_header endRefreshing];
}

- (void)batchRequestPageDataSuccess:(__kindof YTKBatchRequest *)request{
    if (request.showHUDdelegate) {
        request.showHUDdelegate.isBatchRequestIgnoreShowHUD = NO;
    }
    [self.scrollView.mj_header endRefreshing];
}

- (void)dealloc
{
    
}

@end
