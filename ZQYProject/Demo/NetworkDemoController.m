//
//  NetworkDemoController.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/22.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "NetworkDemoController.h"
#import "TestViewController.h"

@interface NetworkDemoController ()

@end

@implementation NetworkDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)batchret:(id)sender {
//    [self.batchRequest start];
    TestViewController *vc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)siRe:(id)sender {
    
}


- (void)dealloc
{
    
}

@end
