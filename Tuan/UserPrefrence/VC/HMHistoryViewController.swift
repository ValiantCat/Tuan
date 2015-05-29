//
//  HMHistoryViewController.swift
//  Tuan
//
//  Created by nero on 15/5/28.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMHistoryViewController:HMDealLocalListViewController {
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "浏览记录"
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 刷新数据（保持顺序）
        deals.removeAll(keepCapacity: true)
        var historyDeals = HMDealLocalTool.sharedDealLocalTool().historyDeals
        for deal in historyDeals {
            deals.append(deal as! HMDeal )
        }
        collectionView?.reloadData()

    }
    //    MARK: - 实现父类方法
    override func emptyIcon() -> String {
        return "icon_latestBrowse_empty"
    }


    
    /**
    *  删除
    */
    override func delete(){

        HMDealLocalTool.sharedDealLocalTool().unsaveHistoryDeals(willDeletedDeals())
    }
}
