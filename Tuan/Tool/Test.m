//
//  Test.m
//  Tuan
//
//  Created by nero on 15/5/13.
//  Copyright (c) 2015年 nero. All rights reserved.
//

#import "Test.h"
#import "HMDealTool.h"

@implementation Test
+(void)test {

    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    param.city = @"北京";
    param.limit = @5;
    [HMDealTool findDeals:param success:^(HMFindDealsResult *result) {
        NSLog(@"搜索团购成功---%@", result.deals);
    } failure:^(NSError *error) {
        NSLog(@"搜索团购失败---%@", error);
    }];
    
    
        HMGetSingleDealParam *singleParam = [[HMGetSingleDealParam alloc] init];
    
    
        singleParam.deal_id = @"2-6390770";
        [HMDealTool getSingleDeal:singleParam success:^(HMGetSingleDealResult *result) {
            NSLog(@"获得指定团购成功---%@", result.deals);
        } failure:^(NSError *error) {
            NSLog(@"获得指定团购失败---%@", error);
        }];


}
@end
