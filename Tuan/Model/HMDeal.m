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
- (NSNumber *)dealNumber:(NSNumber *)sourceNumber
{
    NSString *str = [sourceNumber description];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d+\\.\\d{2}" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *results = [regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
    
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@", [str substringWithRange:result.range]);
    }
    
    // 小数点的位置
    NSUInteger dotIndex = [str rangeOfString:@"."].location;
    if (dotIndex != NSNotFound && str.length - dotIndex > 2) { // 小数超过2位
        str = [str substringToIndex:dotIndex + 3];
    }
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    return [fmt numberFromString:str];
}

- (void)setList_price:(NSNumber *)list_price
{
    _list_price = [self dealNumber:list_price];
    
    
}

- (void)setCurrent_price:(NSNumber *)current_price
{
    _current_price = [self dealNumber:current_price];
}
MJCodingImplementation
@end
