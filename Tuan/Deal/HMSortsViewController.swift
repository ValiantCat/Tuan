//
//  HMSortsViewController.swift
//  Tuan
//
//  Created by nero on 15/5/15.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit


class HMSortButton:UIButton {
    var sort:HMSort = HMSort() {
        willSet  {
            self.title = newValue.label
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bgImage = "btn_filter_normal"
        self.selectedBgImage = "btn_filter_selected"
        self.titleColor = UIColor.blackColor()
        self.selectedTitleColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

class HMSortsViewController: UIViewController {
    var seletedButton:HMSortButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置在popover中的尺寸
        self.preferredContentSize = self.view.size;
        
        // 根据排序模型的个数，创建对应的按钮
        let buttonX:CGFloat = 20.0
        let buttonW = view.width - 2 * buttonX
        let buttonP:CGFloat = 15
        var sorts =  HMMetaDataTool.sharedMetaDataTool().sorts as! Array<HMSort>

        var contentH:CGFloat = 0
        for i in 0 ..< sorts.count {
            // 创建按钮
            let button = HMSortButton(frame: CGRectZero)
            // 取出模型
            button.sort = sorts[i]

            // 设置尺寸
            button.x = buttonX
            button.width = buttonW
            button.height = 30
            button.y = buttonP + CGFloat(i) * ( button.height + buttonP)
            button.addTarget(self, action: Selector("sortButtonClick:"), forControlEvents: UIControlEvents.TouchDown)
            view.addSubview(button)
            
            contentH = button.maxX + buttonP
        }
        //        // 设置contentSize
        let scrollview = self.view as! UIScrollView
        scrollview.contentSize = CGSize(width: 0, height: contentH)
    }
    func sortButtonClick(button:HMSortButton) {
        self.seletedButton?.selected = false
        button.selected = true
        self.seletedButton = button
        // 2.发出通知
        HMNotificationCenter.postNotificationName(HMSortNotification.HMSortDidSelectNotification, object: nil, userInfo: [HMSortNotification.HMSelectedSort:button.sort])
        
    }
    /** 当前选中的排序 */
    //    @property (strong, nonatomic) HMSort *selectedSort;
    var selectedSort:HMSort! {
        willSet {
//
            if newValue == nil {return }
            let subview = self.view.subviews 
            for button in subview{
                if let sortButton = button as? HMSortButton {
                    if sortButton.sort == newValue {
                        seletedButton?.selected = false
                        sortButton.selected = true
                        seletedButton = sortButton
                    }
                }
            }
        }
    }
    
    
}



