# 基于本项目YTKNetWork 

使用需要实例化：


- (RefreshAndMorePageManager *)refreshDataManager{
if (!_refreshDataManager) {
_ refreshDataManager = [[RefreshAndMorePageManager alloc] initWithScrollView:self.tableView baseRequest:self.test1];
}
return _refreshDataManager;
}

- (void)viewDidLoad {
[super viewDidLoad];
// Do any additional setup after loading the view from its nib.
[self.view addSubview:self.tableView];
[self refreshDataManager];

[self.test1 start];

}
