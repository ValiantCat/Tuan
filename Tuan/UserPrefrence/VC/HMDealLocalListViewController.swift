//
//  HMDealLocalListViewController.swift
//  Tuan
//
//  Created by nero on 15/5/29.
//  Copyright (c) 2015年 nero. All rights reserved.
//   本地记录父类

import UIKit
private struct HMTextStatus {
 static let  HMEditText = "编辑"
 static  let HMDoneText = "完成"
}
class HMDealLocalListViewController:HMDealListViewController {
//    MARK: - init
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

// MARK:    items
    lazy var backItem:UIBarButtonItem = {
        var item = UIBarButtonItem(imageName: "icon_back", highImageName: "icon_back_highlighted", target: self, action: Selector("back"))
        return item
        }()
    lazy var selectAllItem:UIBarButtonItem  = {
        var item = UIBarButtonItem(title: "   全选   ", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("selectAll"))
            return item
        }()
    lazy var unselectAllItem:UIBarButtonItem = {
        var item = UIBarButtonItem(title: "   全不选   ", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("unselectAll"))
        return item
        }() 
    lazy var deleteItem:UIBarButtonItem = {
        var item = UIBarButtonItem(title: "   删除   ", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("delete"))
        item.enabled = false
        return item
        }()
    func back(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //    /**
    //    *  全选
    //    */
    func selectAll(){
        for deal in deals {
            deal.checking = true
        }
        self.collectionView?.reloadData()
        //    // 控制删除item的状态和文字
        dealCellDidClickCover(HMDealCell())
    }
    //    /**
    //    *  全不选
    //    */
    func unselectAll(){
        for deal in deals {
            deal.checking = false
        }
        self.collectionView?.reloadData()
        //    // 控制删除item的状态和文字
        dealCellDidClickCover(HMDealCell())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//    // 设置左上角的返回按钮
        navigationItem.leftBarButtonItems = [self.backItem ]
        //    // 设置右上角的编辑按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: HMTextStatus.HMEditText, style: UIBarButtonItemStyle.Done, target: self, action: Selector("edit"))


    }

    /**
    *  编辑 或者完成
    */
    func edit(){
        let title = navigationItem.rightBarButtonItem?.title
        if title == HMTextStatus.HMEditText {
            navigationItem.rightBarButtonItem?.title = HMTextStatus.HMDoneText
            for deal in deals {
                deal.editing = true
            }
            self.collectionView?.reloadData()
            //    // 左边显示4个item
            self.navigationItem.leftBarButtonItems = [self.backItem, self.selectAllItem, self.unselectAllItem, self.deleteItem]
        }else{
            navigationItem.rightBarButtonItem?.title = HMTextStatus.HMEditText
            for deal in deals {
                deal.editing = false
                deal.checking = false
            }
            self.collectionView?.reloadData()
            dealCellDidClickCover(HMDealCell())
            //    // 左边显示1个item
                self.navigationItem.leftBarButtonItems = [self.backItem];
        }
        
    }


    /**
    *  返回即将删除的团购
    */
    func willDeletedDeals() ->[HMDeal] {
        var checkingDeals = [HMDeal]()
        // 取出被打钩的团购
        for deal in deals {
            if deal.checking {
                checkingDeals.append(deal)
//                      由于history 和collec 用的是相同的model  所以删除之后状态要清空
                deal.checking = false
                deal.editing = false
            }
        }
        let dealsNS = NSMutableArray(array: deals)
        dealsNS.removeObjectsInArray(checkingDeals)
        //waning 这里有错
        self.deals = NSArray(array: dealsNS) as! [(HMDeal)]
        collectionView?.reloadData()

    // 控制删除item的状态和文字
        dealCellDidClickCover(nil )
    
    return checkingDeals;
    }
    /**
    *  删除
    */
    func delete(){

    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        for deal in deals {
            deal.editing = false
            deal.checking = false
        }
    }
    override func dealCellDidClickCover(dealCell: HMDealCell?) {
        var deleteEnable = false
        var checkingCount = 0
        //    // 1.删除item的状态
        for deal in deals {
            if deal.checking {
                deleteEnable = true
                checkingCount++
            }
        }
        deleteItem.enabled = deleteEnable
        //    // 2.删除item的文字
        if checkingCount > 0 {
            deleteItem.title = "  删除\(checkingCount)  "
        }else{
            deleteItem.title = "    删除    "
        }
    }
}
//extension HMDealLocalListViewController : HMDealCellDelegate {

//}