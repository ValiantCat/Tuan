//
//  HMRegionsViewController.swift
//  Tuan
//
//  Created by nero on 15/5/16.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMRegionsViewController: UIViewController {
    
    lazy var menu:HMDropdownMenu = {
        // 顶部的view
        
        var topView = self.view.subviews.first as! UIView
        // 创建菜单
        var menu = HMDropdownMenu()
        menu.delegate = self
        self.view.addSubview(menu)
        // menu的ALEdgeTop == topView的ALEdgeBottom
        menu.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: topView)
        
        // 除开顶部，其他方向距离父控件的间距都为0
        menu.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top)
        return menu
        }()
    @IBAction func changeCity() {
//             changeCityClosuer?()       
        var cityesVC = HMCitiesViewController()
        cityesVC.view = NSBundle.mainBundle().loadNibNamed("HMCitiesViewController", owner: cityesVC, options: nil).last as! UIView
        cityesVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        presentViewController(cityesVC, animated: true) { () -> Void in

        }
    }
    var  changeCityClosuer:(Void ->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = CGSizeMake(400, 480);
        
    }
    var regions:Array<HMRegion>! {
        willSet {
            menu.items = newValue
        }
    }
    
    /** 当前选中的区域 */
    var selectedRegion:HMRegion! {
        willSet {
                 if newValue == nil {return }
            var itsmNSArray = NSArray(array: menu.items)
            menu.selectMain(Int32(itsmNSArray.indexOfObject(newValue)))
        }
    }
    

    /** 当前选中的子区域名称 */
    var selectedSubRegionName:NSString! {
        willSet {
            if newValue == nil {return }
            var itsmNSArray = NSArray(array: menu.items)
            menu.selectSub(Int32(itsmNSArray.indexOfObject(newValue)))
        }
    }

}
extension HMRegionsViewController: HMDropdownMenuDelegate {
    func dropdownMenu(dropdownMenu: HMDropdownMenu!, didSelectSub subRow: Int32, ofMain mainRow: Int32) {
        // 发出通知，选中了某个分类
        var userinfo = [String:AnyObject]()
        var region = dropdownMenu.items[Int(mainRow)] as! HMRegion
        userinfo[HMRegionNotification.HMSelectedRegion] = region
        userinfo[HMRegionNotification.HMSelectedSubRegionName] = region.subregions[Int(subRow)]
        HMNotificationCenter.postNotificationName(HMRegionNotification.HMRegionDidSelectNotification, object: nil, userInfo: userinfo)
    }
    func dropdownMenu(dropdownMenu: HMDropdownMenu!, didSelectMain mainRow: Int32) {

        var region = dropdownMenu.items[Int(mainRow)] as! HMRegion
        if region.subregions != nil {
            if selectedRegion == regions {
                // 选中右边的子区域
                
                var temp = selectedSubRegionName
                if temp == nil {
                    return
                }
                 selectedSubRegionName = temp
            }
        }else{
                HMNotificationCenter.postNotificationName(HMRegionNotification.HMRegionDidSelectNotification, object: nil, userInfo: [HMRegionNotification.HMSelectedRegion:region])
        }

    }

}