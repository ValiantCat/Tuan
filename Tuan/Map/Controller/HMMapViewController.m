//
//  HMMapViewController.m
//  黑团HD
//
//  Created by apple on 14-8-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIBarButtonItem+Extension.h"
#import "HMDealTool.h"
#import "HMDeal.h"
#import "HMBusiness.h"
#import "HMDealAnnotation.h"
#import "HMDealAnnoRightButton.h"
#import "HMDealsTopMenu.h"
#import "HMMetaDataTool.h"
#import "HMCategory.h"
#import "Tuan-Swift.h"
@interface HMMapViewController () <MKMapViewDelegate>
- (IBAction)backToUserLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *locationCity;
@property(nonatomic,strong) CLLocationManager *manager;
/**
 *  是否正在处理团购信息（是否在请求中）
 */
@property (nonatomic, assign, getter = isDealingDeals) BOOL dealingDeals;
/** 分类菜单 */
@property (weak, nonatomic) HMDealsTopMenu *categoryMenu;
/** 分类Popover */
@property (strong, nonatomic) UIPopoverController *categoryPopover;

/** 当前选中的分类 */
@property (strong, nonatomic) HMCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;
@end

@implementation HMMapViewController

#pragma mark - 懒加载
- (UIPopoverController *)categoryPopover
{
    if (_categoryPopover == nil) {
        HMCategoriesViewController *cv = [[HMCategoriesViewController alloc] init];
        self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:cv];
    }
    return _categoryPopover;
}

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager= [[CLLocationManager alloc] init];
        [self.manager requestWhenInUseAuthorization];
    // 设置地图
    [self setupMap];
    
    // 设置导航栏的内容
    [self setupNav];
}

/**
 *  设置地图
 */
- (void)setupMap
{
    // 显示用户的位置（一颗发光的蓝色大头针）
    if([self.mapView showsUserLocation]){
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
}

/**
 *  设置导航栏的内容
 */
- (void)setupNav
{
    self.title = @"地图";
    
    self.selectedCategory = [[HMMetaDataTool sharedMetaDataTool].categories firstObject];
    
    // 左边的返回
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 分类菜单
    HMDealsTopMenu *categoryMenu = [HMDealsTopMenu menu];
    categoryMenu.titleLabel.text = self.selectedCategory.name;
    categoryMenu.imageButton.image = self.selectedCategory.icon;
    categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    [categoryMenu addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    self.categoryMenu = categoryMenu;
    
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidSelect:) name:@"HMCategoryDidSelectNotification" object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)categoryDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCategory = note.userInfo[_selectedCategory];
    self.selectedSubCategoryName = note.userInfo[_selectedSubCategoryName];
    
    // 设置菜单数据
    self.categoryMenu.imageButton.image = self.selectedCategory.icon;
    self.categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    self.categoryMenu.titleLabel.text = self.selectedCategory.name;
    self.categoryMenu.subtitleLabel.text = self.selectedSubCategoryName;
    
    // 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 清空所有的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 加载最新的数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

#pragma mark - 导航栏左边处理
/** 分类菜单 */
- (void)categoryMenuClick
{
    HMCategoriesViewController *cs = (HMCategoriesViewController *)self.categoryPopover.contentViewController;
    cs.selectedCategory = self.selectedCategory;
    cs.selectedSubCategoryName = self.selectedSubCategoryName;
    [self.categoryPopover presentPopoverFromRect:self.categoryMenu.bounds inView:self.categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/**
 *  返回
 */
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  回到用户位置
 */
- (IBAction)backToUserLocation {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(HMDealAnnotation *)annotation
{
    if (![annotation isKindOfClass:[HMDealAnnotation class]]) return nil;
    
    static NSString *ID = @"deal";
    HMDealAnnoRightButton *rightBtn = nil;
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        // 显示标题和标题
        annoView.canShowCallout = YES;
        rightBtn = [HMDealAnnoRightButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightBtn addTarget:self action:@selector(dealClick:)];
        annoView.rightCalloutAccessoryView = rightBtn;
    } else { // annoView是从缓存池取出来
        rightBtn = (HMDealAnnoRightButton *)annoView.rightCalloutAccessoryView;
    }
    
    // 覆盖模型数据
    annoView.annotation = annotation;
    // 设置图标
    if ([self.selectedCategory.name isEqualToString:@"全部分类"]) {
        NSString *category = [annotation.deal.categories firstObject];
        NSString *mapIcon = [[HMMetaDataTool sharedMetaDataTool] categoryWithName:category].map_icon;
        annoView.image = [UIImage imageNamed:mapIcon];
    } else { // 特定的类别
        annoView.image = [UIImage imageNamed:self.selectedCategory.map_icon];
    }
    rightBtn.deal = annotation.deal;
    
    return annoView;
}

- (void)dealClick:(HMDealAnnoRightButton *)btn
{
    // 弹出详情控制器
    HMDealDetailViewController *detailVc = [[HMDealDetailViewController alloc] init];
    detailVc.deal = btn.deal;
    [self presentViewController:detailVc animated:YES completion:nil];
}

/**
 *  获取到用户的位置就调用
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 创建区域
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置地图的显示区域
    [mapView setRegion:region animated:YES];
    
    // 获得城市名称
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) return;
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *city = placemark.addressDictionary[@"State"];
        self.locationCity = [city substringToIndex:city.length - 1];
        
        // 定位到城市，就发送请求
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

/**
 *  地图显示的区域发生改变了
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.locationCity == nil || self.isDealingDeals) return;
    
    self.dealingDeals = YES;
    
    // 1.请求参数
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    // 设置位置信息
    CLLocationCoordinate2D center = mapView.region.center;
    param.latitude = @(center.latitude);
    param.longitude = @(center.longitude);
    param.radius = @5000;
    // 设置城市
    param.city = self.locationCity;
    // 除开“全部分类”和“全部”以外的所有词语都可以发
    // 分类
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"]) {
        if (self.selectedSubCategoryName && ![self.selectedSubCategoryName isEqualToString:@"全部"]) {
            param.category = self.selectedSubCategoryName;
        } else {
            param.category = self.selectedCategory.name;
        }
    }
    
    // 2.发送请求给服务器
    [HMDealTool findDeals:param success:^(HMFindDealsResult *result) {
        [self setupDeals:result.deals];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        
        self.dealingDeals = NO;
    }];
}

/**
 *  处理团购数据
 */
- (void)setupDeals:(NSArray *)deals
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (HMDeal *deal in deals) {
            for (HMBusiness *business in deal.businesses) {
                HMDealAnnotation *anno = [[HMDealAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
                anno.title = deal.title;
                anno.subtitle = business.name;
                // 设置大头针对应的团购模型
                anno.deal = deal;
                
                // 说明这个大头针已经存在这个数组中（已经显示过了）
                if ([self.mapView.annotations containsObject:anno]) continue;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:anno];
                });
            }
        }
        
        self.dealingDeals = NO;
    });
}
@end
