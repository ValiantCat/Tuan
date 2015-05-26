//
//  HMMetaDataTool.m
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMMetaDataTool.h"
#import "HMCategory.h"
#import "HMCity.h"
#import "HMCityGroup.h"
#import "HMSort.h"
#import "MJExtension.h"
#define HMSelectedCityNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_city_names.plist"]
#define HMSelectedSortFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_sort.data"]

@interface HMMetaDataTool()
{
    /** 所有的分类 */
    NSArray *_categories;
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的排序 */
    NSArray *_sorts;
}
@property (nonatomic, strong) NSMutableArray *selectedCityNames;
@end

@implementation HMMetaDataTool
HMSingletonM(MetaDataTool)

- (NSMutableArray *)selectedCityNames
{
    if (!_selectedCityNames) {
        _selectedCityNames = [NSMutableArray arrayWithContentsOfFile:HMSelectedCityNamesFile];
        
        if (!_selectedCityNames) {
            _selectedCityNames = [NSMutableArray array];
        }
    }
    return _selectedCityNames;
}

- (NSArray *)categories
{
    if (!_categories) {
        _categories = [HMCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

- (NSArray *)cityGroups
{
    NSMutableArray *cityGroups = [NSMutableArray array];
    
    // 添加最近访问
    if (self.selectedCityNames.count) {
        HMCityGroup *recentCityGroup = [[HMCityGroup alloc] init];
        recentCityGroup.title = @"最近";
        recentCityGroup.cities = self.selectedCityNames;
        [cityGroups addObject:recentCityGroup];
    }
    
    // 添加plist里面的城市组数据
    NSArray *plistCityGroups = [HMCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    [cityGroups addObjectsFromArray:plistCityGroups];
    return cityGroups;
}

- (NSArray *)cities
{
    if (!_cities) {
        _cities = [HMCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [HMSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}


- (HMCity *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    for (HMCity *city in self.cities) {
        if ([city.name isEqualToString:name]) return city;
    }
    return nil;
}

#pragma mark - 存储方法
- (void)saveSelectedCityName:(NSString *)name
{
    if (name.length == 0) return;
    
    // 存储城市名字
    [self.selectedCityNames removeObject:name];
    [self.selectedCityNames insertObject:name atIndex:0];
    
    // 写入plist
    [self.selectedCityNames writeToFile:HMSelectedCityNamesFile atomically:YES];
}

- (void)saveSelectedSort:(HMSort *)sort
{
    if (sort == nil) return;
    
    [NSKeyedArchiver archiveRootObject:sort toFile:HMSelectedSortFile];
}

- (HMCity *)selectedCity
{
    NSString *cityName = [self.selectedCityNames firstObject];
    HMCity *city = [self cityWithName:cityName];
    if (city == nil) {
        city = [self cityWithName:@"北京"];
    }
    return city;
}

- (HMSort *)selectedSort
{
    HMSort *sort = [NSKeyedUnarchiver unarchiveObjectWithFile:HMSelectedSortFile];
    if (sort == nil) {
        sort = [self.sorts firstObject];
    }
    return sort;
}

@end
