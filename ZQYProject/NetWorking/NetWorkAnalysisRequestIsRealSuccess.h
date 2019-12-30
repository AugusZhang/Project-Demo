//
//  NetWorkAnalysisResponsCodeTool.h
//  ZQYProject
//
//  Created by  张清玉 on 2019/10/24.
//  Copyright © 2019 zqy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkAnalysisRequestIsRealSuccess : NSObject

+ (nullable NSError *)analysisResponsCodeWithBaseRequest:(YTKBaseRequest *)request requestError:(nullable NSError *)requestError serializationError:(nullable NSError *)serializationError validationError:(nullable NSError *)validationError;

@end

NS_ASSUME_NONNULL_END
