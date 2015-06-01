//
//  HMCategoriesViewController.swift
//  Tuan
//
//  Created by nero on 15/5/15.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMCategoriesViewController: UIViewController {
    var menu:HMDropdownMenu!
    override func loadView() {
        menu = HMDropdownMenu()
        menu.delegate = self
        menu.items = HMMetaDataTool.sharedMetaDataTool().categories
        self.view =  menu
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 400, height: 480)
    }
    
    /** 当前选中的分类 */
    var selectedCategory:HMCategory! {
        willSet {
                 if newValue == nil  || menu == nil {return }
            var itemsNSArray = NSArray(array: menu.items)
            let index = itemsNSArray.indexOfObject(newValue)
            menu.selectMain(Int32(index))
        }
        
    }
    /** 当前选中的子分类名称 */
    var selectedSubCategoryName:String! {
        willSet {
                 if newValue == nil {return }
            if let subCategories = selectedCategory.subcategories {
            var itemsNSArray = NSArray(array: selectedCategory.subcategories)
            let index = itemsNSArray.indexOfObject(newValue)
                if !(index >= Int.max){
                    menu.selectSub(Int32(index))
                }
            }
        }
        
    }
    
}
extension HMCategoriesViewController:HMDropdownMenuDelegate {
    func dropdownMenu(dropdownMenu: HMDropdownMenu!, didSelectMain mainRow: Int32) {
        
        //             发出通知，选中了某个分类
        var category = dropdownMenu.items[Int(mainRow)] as! HMCategory
        if category.subcategories != nil  {//有子类别
            if (self.selectedCategory != nil && selectedCategory == category) {
                // 选中右边的子类别
                var temp = selectedSubCategoryName
                if temp == nil {
                    return
                }
                selectedSubCategoryName = temp
            }
        }else{
            HMNotificationCenter.postNotificationName(HMCategoryNotification.HMCategoryDidSelectNotification, object: nil, userInfo: [HMCategoryNotification.HMSelectedCategory:category])
        }
    }
    func dropdownMenu(dropdownMenu: HMDropdownMenu!, didSelectSub subRow: Int32, ofMain mainRow: Int32) {
        
        // 发出通知，选中了某个分类
        var userinfo = [String:AnyObject]()
        var category = dropdownMenu.items[Int(mainRow)] as! HMCategory
        userinfo[HMCategoryNotification.HMSelectedCategory] = category
        userinfo[HMCategoryNotification.HMSelectedSubCategoryName] = category.subcategories[Int(subRow)]
        HMNotificationCenter.postNotificationName(HMCategoryNotification.HMCategoryDidSelectNotification, object: nil, userInfo: userinfo)
    }
    
}