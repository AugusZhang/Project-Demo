//
//  testRequest.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/22.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ignoreCache = YES;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/app/enterprise/nearby";
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

//在这里解析装载自己的数据
- (void)requestCompleteFilter{
    
}
//入参(建议用代理管理页面接口入参)
- (id)requestArgument {
    if (self.paramsDatasource && [self.paramsDatasource respondsToSelector:@selector(requestParams:)]) {
        return [self.paramsDatasource requestParams:self];
    }
    return @{};
}

- (void)dealloc
{
    
}

@end
