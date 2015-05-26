//
//  HMRegion.m
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMRegion.h"
#import "MJExtension.h"
@implementation HMRegion
- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subregions;
}
MJCodingImplementation
@end
