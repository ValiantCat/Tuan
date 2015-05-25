//
//  HMDropdownMainCell.h
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDropdownMenu.h"

@interface HMDropdownMainCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) id<HMDropdownMenuItem> item;
@end
