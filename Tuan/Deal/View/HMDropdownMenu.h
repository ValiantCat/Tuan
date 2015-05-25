//
//  HMDropdownMenu.h
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//  下拉菜单

#import <UIKit/UIKit.h>
@class HMDropdownMenu;
@protocol HMDropdownMenuItem <NSObject>
@required
/** 标题 */
- (NSString *)title;
/** 子标题数据 */
- (NSArray *)subtitles;
@optional
/** 图标 */
- (NSString *)image;
/** 选中的图标 */
- (NSString *)highlightedImage;
@end

/** HMDropdownMenuDelegate  */
@protocol HMDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenu:(HMDropdownMenu *)dropdownMenu didSelectMain:(int)mainRow;
- (void)dropdownMenu:(HMDropdownMenu *)dropdownMenu didSelectSub:(int)subRow ofMain:(int)mainRow;
@end








@interface HMDropdownMenu : UIView



+ (instancetype)menu;

/**
 *  显示的数据模型(里面的模型必须遵守HMDropdownMenuItem协议)
 */
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<HMDropdownMenuDelegate> delegate;

- (void)selectMain:(int)mainRow;
- (void)selectSub:(int)subRow;
@end
