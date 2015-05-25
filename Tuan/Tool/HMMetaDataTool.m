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
@interface HMMetaDataTool()
{
    /** 所有的分类 */
    NSArray *_categories;
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的城市组 */
    NSArray *_cityGroups;
    /** 所有的排序 */
    NSArray *_sorts;
}
@end

@implementation HMMetaDataTool
HMSingletonM(MetaDataTool)

- (NSArray *)categories
{
    if (!_categories) {
        _categories = [HMCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

- (NSArray *)cityGroups
{
    if (!_cityGroups) {
        _cityGroups = [HMCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
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

@end
