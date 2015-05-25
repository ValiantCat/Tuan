//
//  HMFindDealsParam.h
//  黑团HD
//
//  Created by apple on 14-8-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//  团购请求参数

#import <Foundation/Foundation.h>

@interface HMFindDealsParam : NSObject
/** string	包含团购信息的城市名称 */
@property (copy, nonatomic) NSString *city;

/** 指定目的地城市名称，适用于“酒店”、“旅游”等分类 */
@property (copy, nonatomic) NSString *destination_city;

/** 纬度坐标，须与经度坐标同时传入 */
@property (strong, nonatomic) NSNumber *latitude;

/** 经度坐标，须与纬度坐标同时传入 */
@property (strong, nonatomic) NSNumber *longitude;

/** 搜索半径，单位为米，最小值1，最大值5000，如不传入默认为1000 */
@property (strong, nonatomic) NSNumber *radius;

/** 包含团购信息的城市区域名（不含返回结果中包括的城市名称信息） */
@property (copy, nonatomic) NSString *region;

/** 包含团购信息的分类名，支持多个category合并查询，多个category用逗号分割 */
@property (copy, nonatomic) NSString *category;

/** 关键词，搜索范围包括商户名、商品名、地址等 */
@property (copy, nonatomic) NSString *keyword;

/** 结果排序，1:默认，2:价格低优先，3:价格高优先，4:购买人数多优先，5:最新发布优先，6:即将结束优先，7:离经纬度坐标距离近优先 */
@property (strong, nonatomic) NSNumber *sort;

/** 每页返回的团单结果条目数上限，最小值1，最大值40，如不传入默认为20 */
@property (strong, nonatomic) NSNumber *limit;

/** 页码，如不传入默认为1，即第一页 */
@property (strong, nonatomic) NSNumber *page;
@end
