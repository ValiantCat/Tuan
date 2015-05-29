//
//  HMDealLocalTool.h
//  黑团HD
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 heima. All rights reserved.
//  处理团购的本地数据（浏览记录和收藏记录）

#import <Foundation/Foundation.h>
#import "HMSingleton.h"

@class HMDeal;

@interface HMDealLocalTool : NSObject
HMSingletonH(DealLocalTool)

/**
 *  返回最近浏览的团购
 */
@property (nonatomic, strong, readonly) NSMutableArray *historyDeals;

/**
 *  保存最近浏览的团购
 */
- (void)saveHistoryDeal:(HMDeal *)deal;
- (void)unsaveHistoryDeal:(HMDeal *)deal;
- (void)unsaveHistoryDeals:(NSArray *)deals;

/**
 *  返回收藏的团购
 */
@property (nonatomic, strong, readonly) NSMutableArray *collectDeals;

/**
 *  保存收藏的团购
 */
- (void)saveCollectDeal:(HMDeal *)deal;
/**
 *  取消收藏的团购
 */
- (void)unsaveCollectDeal:(HMDeal *)deal;
- (void)unsaveCollectDeals:(NSArray *)deals;
@end
