//
//  HMDealTool.h
//  黑团HD
//
//  Created by apple on 14-8-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//  业务类（负责团购的所有业务）

#import <Foundation/Foundation.h>
#import "HMFindDealsParam.h"
#import "HMFindDealsResult.h"
#import "HMGetSingleDealParam.h"
#import "HMGetSingleDealResult.h"
#import "HMCity.h"
#import "HMCategory.h"
#import "HMRegion.h"
#import "HMSort.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
@interface HMDealTool : NSObject

/**
 *  搜索团购
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)findDeals:(HMFindDealsParam *)param success:(void (^)(HMFindDealsResult *result))success failure:(void (^)(NSError *error))failure;


/**
 *  获得指定团购（获得单个团购信息）
 */
+ (void)getSingleDeal:(HMGetSingleDealParam *)param success:(void (^)(HMGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure;
+ (void)loadNewDeals:(HMCity *)selectedCity
          selectSort:(HMSort*)selectedSort
    selectedCategory:(HMCategory *)selectedCategory
      selectedRegion:(HMRegion*)selectedRegion
selectedSubCategoryName:(NSString *)selectedSubCategoryName
selectedSubRegionName:(NSString *)selectedSubRegionName andResult:(void (^)(NSArray *result))complete;


@end
