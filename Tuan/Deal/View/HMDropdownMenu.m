//
//  HMDropdownMenu.m
//  黑团HD
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDropdownMenu.h"
#import "HMDropdownMainCell.h"
#import "HMDropdownSubCell.h"

@interface HMDropdownMenu() <UITableViewDataSource, UITableViewDelegate>
/** 主表 */
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/** 从表 */
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@end

@implementation HMDropdownMenu

+ (instancetype)menu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMDropdownMenu" owner:nil options:nil] lastObject];
}

// initWithCoder:(NSCoder *)aDecoder --> awakeFromNib(xib中的所有属性、方法已经连线成功)

/**
 *  一个UI控件即将被添加到窗口中就调用
 */
//- (void)willMoveToWindow:(UIWindow *)newWindow
//{
//    self.mainTableView.backgroundColor = [UIColor redColor];
//    self.subTableView.backgroundColor = [UIColor blueColor];
//}

#pragma mark - 公共方法
- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // 刷新表格
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}

- (instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMDropdownMenu" owner:nil options:nil] lastObject];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return self.items.count;
    } else {
        // 得到mainTableView选中的行
        int mainRow = [self.mainTableView indexPathForSelectedRow].row;
        id<HMDropdownMenuItem> item = self.items[mainRow];
        return [item subtitles].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) { // 左边主表的cell
        HMDropdownMainCell *mainCell = [HMDropdownMainCell cellWithTableView:tableView];
        mainCell.item = self.items[indexPath.row];
        return mainCell;
    } else { // 右边从表的cell
        HMDropdownSubCell *subCell = [HMDropdownSubCell cellWithTableView:tableView];
        
        // 得到mainTableView选中的行
        int mainRow = [self.mainTableView indexPathForSelectedRow].row;
        id<HMDropdownMenuItem> item = self.items[mainRow];
        subCell.textLabel.text = [item subtitles][indexPath.row];
        return subCell;
    }
}

#pragma mark - 公共方法
- (void)selectMain:(int)mainRow
{

    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.subTableView reloadData];
}

- (void)selectSub:(int)subRow
{
    [self.subTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:subRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) { // 左边的主表
        // 刷新右边
        [self.subTableView reloadData];
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectMain:)]) {
            [self.delegate dropdownMenu:self didSelectMain:(int)indexPath.row];
        }
    } else { // 右边的从表
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectSub:ofMain:)]) {
            int mainRow =(int) [self.mainTableView indexPathForSelectedRow].row;
            [self.delegate dropdownMenu:self didSelectSub:(int)indexPath.row ofMain:mainRow];
        }
    }
}
@end
