//
//  HMDealAnnotation.m
//  黑团HD
//
//  Created by apple on 14-8-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDealAnnotation.h"

@implementation HMDealAnnotation
- (BOOL)isEqual:(HMDealAnnotation *)other
{
    return self.coordinate.latitude == other.coordinate.latitude && self.coordinate.longitude == other.coordinate.longitude;
}
@end
