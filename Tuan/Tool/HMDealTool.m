//
//  HMDealTool.m
//  黑团HD
//
//  Created by apple on 14-8-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDealTool.h"
#import "HMAPITool.h"
#import "MJExtension.h"

@implementation HMDealTool
+ (void)findDeals:(HMFindDealsParam *)param success:(void (^)(HMFindDealsResult *))success failure:(void (^)(NSError *))failure
{
    [[HMAPITool sharedAPITool] request:@"v1/deal/find_deals" params:param.keyValues success:^(id json) {
        if (success) {
            HMFindDealsResult *obj = [HMFindDealsResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}


+ (void)getSingleDeal:(HMGetSingleDealParam *)param success:(void (^)(HMGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure
{
    [[HMAPITool sharedAPITool] request:@"v1/deal/get_single_deal" params:param.keyValues success:^(id json) {
        if (success) {
            HMGetSingleDealResult *obj = [HMGetSingleDealResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}
+ (void)loadNewDeals:(HMCity *)selectedCity
          selectSort:(HMSort*)selectedSort
    selectedCategory:(HMCategory *)selectedCategory
      selectedRegion:(HMRegion*)selectedRegion
selectedSubCategoryName:(NSString *)selectedSubCategoryName
selectedSubRegionName:(NSString *)selectedSubRegionName andResult:(void (^)(NSArray *result))complete
{
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    // 城市名称
    param.city = selectedCity.name;
    // 排序
    if (selectedSort) {
        param.sort = @(selectedSort.value);
    }
    // 除开“全部分类”和“全部”以外的所有词语都可以发
    // 分类
    if (selectedCategory && ![selectedCategory.name isEqualToString:@"全部分类"]) {
        if (selectedSubCategoryName && ![selectedSubCategoryName isEqualToString:@"全部"]) {
            param.category = selectedSubCategoryName;
        } else {
            param.category = selectedCategory.name;
        }
    }
    // 区域
    if (selectedRegion && ![selectedRegion.name isEqualToString:@"全部"]) {
        if (selectedSubRegionName && ![selectedSubRegionName isEqualToString:@"全部"]) {
            param.region = selectedSubRegionName;
        } else {
            param.region = selectedRegion.name;
        }
    }
    // 设置单次返回的数量
    param.limit = @(20);
    
    [HMDealTool findDeals:param success:^(HMFindDealsResult *result) {
        if (complete){
        complete(result.deals);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];
    
}
@end
