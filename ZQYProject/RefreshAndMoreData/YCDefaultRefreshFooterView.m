//
//  YCDefaultRefreshFooterView.m
//  YCSuperCar
//
//  Created by ycxc on 2018/12/28.
//  Copyright © 2018年 ycxc. All rights reserved.
//

#import "YCDefaultRefreshFooterView.h"

@implementation YCDefaultRefreshFooterView

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）

- (void)prepare {
    
    [super prepare];
    //loadingImg
//    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"app_loading_refresh" withExtension:@"gif"];
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);
//    size_t frameCount = CGImageSourceGetCount(gifSource);
//    NSMutableArray *imgs = [[NSMutableArray alloc] init];
//    for (size_t i = 0; i < frameCount; i++) {
//        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
//        UIImage *imageName = [UIImage imageWithCGImage:imageRef];
//        [imgs addObject:imageName];
//        CGImageRelease(imageRef);
//    }
//    CFRelease(gifSource);
//    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.equalTo(self);
//        make.height.width.equalTo(@(30));
//    }];
//    [self setImages:imgs duration:1.3 forState:MJRefreshStateRefreshing];
    //设置控件的高度
    self.mj_h = 60.0f;
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    self.stateLabel.textColor = [UIColor redColor];
    self.stateLabel.hidden = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.gifView stopAnimating];
            self.gifView.hidden = YES;
            self.stateLabel.text = @"上拉可以加载更多";
            self.stateLabel.hidden = NO;
            break;
        case MJRefreshStatePulling:
            [self.gifView stopAnimating];
            self.gifView.hidden = YES;
            self.stateLabel.text = @"释放加载更多";
            self.stateLabel.hidden = NO;
            break;
        case MJRefreshStateRefreshing:
            [self.gifView startAnimating];
             self.gifView.hidden = NO;
            self.stateLabel.hidden = YES;
            break;
        case MJRefreshStateNoMoreData:
            [self.gifView stopAnimating];
            self.gifView.hidden = YES;
            self.stateLabel.text = @"没有更多数据了";
            self.stateLabel.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    
    [super setPullingPercent:pullingPercent];
}

- (void)dealloc
{
    
}

@end
