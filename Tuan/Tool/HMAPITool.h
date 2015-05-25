//
//  HMAPITool.h
//  Tuan
//
//  Created by nero on 15/5/13.
//  Copyright (c) 2015年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
@interface HMAPITool : NSObject
- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

HMSingletonH(APITool)
@end
