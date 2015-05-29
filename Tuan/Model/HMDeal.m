//
//  HMDeal.m
//  黑团HD
//
//  Created by apple on 14-8-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDeal.h"
#import "HMBusiness.h"

@implementation HMDeal
- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [HMBusiness class]};
}

- (NSDictionary *)replacedKeyFromPropertyName
{
    // 模型的desc属性对应着字典中的description
    return @{@"desc" : @"description"};
}
#warning  重写isequal方法 保证在缓存时不会缓存内容重复 但是内存地址不同的model
- (BOOL)isEqual:(HMDeal *)other
{
    return [self.deal_id isEqualToString:other.deal_id];
}
MJCodingImplementation
@end
