//
//  HMGetSingleDealResult.m
//  黑团HD
//
//  Created by apple on 14-8-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMGetSingleDealResult.h"
#import "HMDeal.h"

@implementation HMGetSingleDealResult

- (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [HMDeal class]};
}
@end
