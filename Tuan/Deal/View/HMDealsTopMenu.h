//
//  HMDealsTopMenu.h
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//  团购列表顶部菜单

#import <UIKit/UIKit.h>

@interface HMDealsTopMenu : UIView
+ (instancetype)menu;

- (void)addTarget:(id)target action:(SEL)action;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end
