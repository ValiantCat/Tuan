//
//  HMDeal.h
//  黑团HD
//
//  Created by apple on 14-8-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//  团购

#import <Foundation/Foundation.h>

@interface HMDeal : NSObject
/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;
/** 团购标题 */
@property (copy, nonatomic) NSString *title;
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;

/** 城市名称，city为＂全国＂表示全国单，其他为本地单 */
@property (copy, nonatomic) NSString *city;

/** 团购包含商品原价值 */
@property (assign, nonatomic) float list_price;
/** 团购价格 */
@property (assign, nonatomic) float current_price;

/**  团购适用商户所在行政区 NSString */
@property (strong, nonatomic) NSArray *regions;
/**  团购所属分类 NSString */
@property (strong, nonatomic) NSArray *categories;

/** 团购当前已购买数 */
@property (assign, nonatomic) int purchase_count;

/** 团购发布上线日期 */
@property (copy, nonatomic) NSString *publish_date;
/** 团购单的截止购买日期 */
@property (copy, nonatomic) NSString *purchase_deadline;

/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSArray *more_image_urls;

/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;
@property (strong, nonatomic) NSArray *more_s_image_urls;

/** 团购Web页面链接，适用于网页应用 */
@property (copy, nonatomic) NSString *deal_url;
/** 团购HTML5页面链接，适用于移动应用和联网车载应用 */
@property (copy, nonatomic) NSString *deal_h5_url;

/** 团购所适用的商户列表 */
@property (strong, nonatomic) NSArray *businesses;

/** 团购详情 */
@property (copy, nonatomic) NSString *details;
/** 重要通知(一般为团购信息的临时变更) */
@property (copy, nonatomic) NSString *notice;
@end
