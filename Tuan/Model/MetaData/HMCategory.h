//
//  HMCategory.h
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//  分类\类别

#import <Foundation/Foundation.h>
#import "HMDropdownMenu.h"
@interface HMCategory : NSObject <HMDropdownMenuItem>
/** 类别名称 */
@property (copy, nonatomic) NSString *name;
/** 大图标 */
@property (copy, nonatomic) NSString *icon;
/** 大图标(高亮) */
@property (copy, nonatomic) NSString *highlighted_icon;
/** 小图标 */
@property (copy, nonatomic) NSString *small_icon;
/** 小图标(高亮) */
@property (copy, nonatomic) NSString *small_highlighted_icon;
/** 子类别 */
@property (strong, nonatomic) NSArray *subcategories;
@end
