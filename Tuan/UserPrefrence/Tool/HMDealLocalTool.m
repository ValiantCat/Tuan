//
//  HMDealLocalTool.m
//  黑团HD
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDealLocalTool.h"
#import "HMDeal.h"
#define HMHistoryDealsFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history_deals.data"]

#define HMCollectDealsFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deals.data"]

@interface HMDealLocalTool()
{
    NSMutableArray *_historyDeals;
    NSMutableArray *_collectDeals;
}
@end

@implementation HMDealLocalTool
HMSingletonM(DealLocalTool)

- (NSMutableArray *)historyDeals
{
    if (!_historyDeals) {
        _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMHistoryDealsFile];
        
        if (!_historyDeals) {
            _historyDeals = [NSMutableArray array];
        }
    }
    return _historyDeals;
}

- (NSMutableArray *)collectDeals
{
    if (!_collectDeals) {
        _collectDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMCollectDealsFile];
        
        if (!_collectDeals) {
            _collectDeals = [NSMutableArray array];
        }
    }
    return _collectDeals;
}

- (void)saveHistoryDeal:(HMDeal *)deal
{
    [self.historyDeals removeObject:deal];
    [self.historyDeals insertObject:deal atIndex:0];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:HMHistoryDealsFile];
}

- (void)unsaveHistoryDeal:(HMDeal *)deal
{
    [self.historyDeals removeObject:deal];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:HMHistoryDealsFile];
}

- (void)unsaveHistoryDeals:(NSArray *)deals
{
    [self.historyDeals removeObjectsInArray:deals];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:HMHistoryDealsFile];
}

- (void)saveCollectDeal:(HMDeal *)deal
{
    [self.collectDeals removeObject:deal];
    [self.collectDeals insertObject:deal atIndex:0];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:HMCollectDealsFile];
}

- (void)unsaveCollectDeal:(HMDeal *)deal
{
    [self.collectDeals removeObject:deal];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:HMCollectDealsFile];
}


- (void)unsaveCollectDeals:(NSArray *)deals
{
    [self.collectDeals removeObjectsInArray:deals];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:HMCollectDealsFile];
}
@end
