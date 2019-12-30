//
//  TestViewController.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/23.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "TestViewController.h"
#import "MJRefresh.h"
#import "YCDefaultRefreshFooterView.h"
#import "TestRequest.h"

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate,YTKRequestDelegate,YTKRequestParamsDatasource>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TestRequest *test1;
@property (nonatomic, strong) TestRequest *test2;
@property (nonatomic, strong) TestRequest *test3;
@property (nonatomic, strong) TestRequest *test4;
@property (nonatomic, strong) YTKBatchRequest *batchRequest;
@property (nonatomic, strong) YTKChainRequest *chainRequest;

@property (nonatomic, strong) HUDManager *hudManager;
@property (nonatomic, strong) RefreshAndMorePageManager *refreshDataManager;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableView];
    [self refreshDataManager];
    
    [self.test1 start];
    
}

#pragma mark UITableViewDataSource and UITableViewDelegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",indexPath.section,indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.chainRequest start];
    }else if (indexPath.row == 1){
        [self.batchRequest start];
    }else{
        [self.test1 start];
        [self.test1 start];
        [self.test1 start];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)requestFailed:(__kindof YTKBaseRequest *)request{
    
}

-(void)requestFinished:(__kindof YTKBaseRequest *)request{
    
}

- (id)requestParams:(__kindof YTKBaseRequest *)request{
    NSDictionary *params = @{@"region" : @"440300",
                            @"lng" : @(-122.3999379395827),
                            @"lat" : @(37.79172390992213),
                            @"limit" : @(request.pageAbledelegate.pageSize),
                            @"page" : @(request.pageAbledelegate.currentPageNumber),
                             };
    return params;
}

#pragma mark - lazyLoad

- (TestRequest *)test1{
    if (!_test1) {
        _test1 = [[TestRequest alloc] init];
        _test1.showHUDdelegate = self.hudManager;
        _test1.delegate = self;
        _test1.paramsDatasource = self;
        _test1.startRequestTipString = @"123";
        _test1.requestSuccessTipString = @"1成功";
    }
    return _test1;
}

- (TestRequest *)test2{
    if (!_test2) {
        _test2 = [[TestRequest alloc] init];
        _test2.showHUDdelegate = self.hudManager;
    }
    return _test2;
}

- (TestRequest *)test3{
    if (!_test3) {
        _test3 = [[TestRequest alloc] init];
        _test3.showHUDdelegate = self.hudManager;
    }
    return _test3;
}

- (TestRequest *)test4{
    if (!_test4) {
        _test4 = [[TestRequest alloc] init];
    }
    return _test4;
}

- (HUDManager *)hudManager{
    if (!_hudManager) {
        _hudManager = [[HUDManager alloc] initWithContainerView:self.view];
    }
    return _hudManager;
}

- (YTKBatchRequest *)batchRequest{
    if (!_batchRequest) {
        _batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[self.test1,self.test2,self.test3]];
        _batchRequest.showHUDdelegate = self.hudManager;
        _batchRequest.startRequestTipString = @"b1233";
        _batchRequest.requestSuccessTipString = @"bsuccess";
    }
    return _batchRequest;
}

- (YTKChainRequest *)chainRequest{
    if (!_chainRequest) {
        _chainRequest = [[YTKChainRequest alloc] init];
        _chainRequest.showHUDdelegate = self.hudManager;
        _chainRequest.startRequestTipString = @"c123";
        _chainRequest.requestSuccessTipString = @"csuccess";
        @weakify(self);
        [_chainRequest addRequest:self.test1 callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            @strongify(self);
            [self.chainRequest addRequest:self.test2 callback:nil];
        }];
    }
    return _chainRequest;
}

- (RefreshAndMorePageManager *)refreshDataManager{
    if (!_refreshDataManager) {
        _refreshDataManager = [[RefreshAndMorePageManager alloc] initWithScrollView:self.tableView baseRequest:self.test1];
    }
    return _refreshDataManager;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.contentInset  = UIEdgeInsetsMake(0, 0, 64, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 100;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)dealloc
{
    
}

@end
