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
#import "HMSort.h"
#import "HMCategory.h"
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




/**
 *  通过分类名称（子分类名称）获得对应的分类模型
 */
- (HMCategory * )categoryWithName:(NSString *)name;



/**
 *  存储选中的城市名称
 */
- (void)saveSelectedCityName:(NSString *)name;
///**
// *  存储选中的区域
// */
//- (void)saveSelectedRegion:(hm *)name;
///**
// *  存储选中的子区域名字
// */
//- (void)saveSelectedCityName:(NSString *)name;
///**
// *  存储选中的分类
// */
//- (void)saveSelectedCityName:(NSString *)name;
///**
// *  存储选中的子分类名字
// */
//- (void)saveSelectedCityName:(NSString *)name;
/**
 *  存储选中的排序
 */
- (void)saveSelectedSort:(HMSort *)sort;

- (HMCity *)selectedCity;
- (HMSort *)selectedSort;

@end
