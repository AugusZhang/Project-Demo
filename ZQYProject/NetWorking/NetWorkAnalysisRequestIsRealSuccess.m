//
//  NetWorkAnalysisResponsCodeTool.m
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/24.
//  Copyright © 2019 zqy. All rights reserved.
//

#import "NetWorkAnalysisRequestIsRealSuccess.h"

NSString *const ZQYRequestSystemErrorDomain = @"com.zhangqingyu.request.SystemError";

@implementation NetWorkAnalysisRequestIsRealSuccess

+ (nullable NSError *)analysisResponsCodeWithBaseRequest:(YTKBaseRequest *)request requestError:(nullable NSError *)requestError serializationError:(nullable NSError *)serializationError validationError:(nullable NSError *)validationError{
    
    NSError * __autoreleasing systemCodeError = nil;
    if (requestError) {
        request.requestFailedTipString = @"网络请求出错！";
    }else if (serializationError){
        request.requestFailedTipString = @"数据格式异常！";
    }else if (validationError){
        request.requestFailedTipString = @"后台数据异常！";
    }
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        switch (request.responseSerializerType) {
            case YTKResponseSerializerTypeHTTP:
                
                break;
            case YTKResponseSerializerTypeJSON:
                systemCodeError = [self analysisJsonDataWithBaseRequest:request];
                break;
            case YTKResponseSerializerTypeXMLParser:
                
                break;
        }
    }
    
    return systemCodeError;
}

+ (NSError *)analysisJsonDataWithBaseRequest:(YTKBaseRequest *)request{
    NSError * __autoreleasing systemCodeError = nil;
    NSString *code = request.responseJSONObject[@"code"];
    if (code.integerValue != 200) {
        systemCodeError = [NSError errorWithDomain:ZQYRequestSystemErrorDomain code:code.integerValue userInfo:
         @{
           NSLocalizedDescriptionKey:@"请求失败",
           NSLocalizedFailureReasonErrorKey:request.responseJSONObject[@"msg"],
           @"message":request.responseJSONObject[@"msg"],
           }];
        request.requestFailedTipString = request.responseJSONObject[@"msg"];
    }
    return systemCodeError;
}

@end

