//
//  HMMetaDataTool.h
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//  管理所有的元数据

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
#import "HMCity.h"
@interface HMMetaDataTool : NSObject
HMSingletonH(MetaDataTool)
/**
 *  所有的分类
 */
@property (strong, nonatomic, readonly) NSArray *categories;
/**
 *  所有的城市
 */
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组
 */
@property (strong, nonatomic, readonly) NSArray *cityGroups;
/**
 *  所有的排序
 */
@property (strong, nonatomic, readonly) NSArray *sorts;
- (HMCity *)cityWithName:(NSString *)name;
@end
