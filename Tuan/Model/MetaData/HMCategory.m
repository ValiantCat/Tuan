//
//  HMCategory.m
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMCategory.h"
#import "MJExtension.h"
@implementation HMCategory
- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subcategories;
}

- (NSString *)image
{
    return self.small_icon;
}

- (NSString *)highlightedImage
{
    return self.small_highlighted_icon;
}
MJCodingImplementation
@end
