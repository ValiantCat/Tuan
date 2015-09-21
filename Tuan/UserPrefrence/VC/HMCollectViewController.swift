//
//  HMCollectViewController.swift
//  Tuan
//
//  Created by nero on 15/5/29.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMCollectViewController: HMDealLocalListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            self.title = "我的收藏"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 刷新数据（保持顺序）
        deals.removeAll(keepCapacity: true)
        let collectDeals = HMDealLocalTool.sharedDealLocalTool().collectDeals
        for deal in collectDeals {
            deals.append(deal as! HMDeal )
        }
        collectionView?.reloadData()

    }
    override func delete() {
        HMDealLocalTool.sharedDealLocalTool().unsaveCollectDeals(willDeletedDeals())
    }
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func emptyIcon() -> String {
            return "icon_collects_empty"
    }


}
