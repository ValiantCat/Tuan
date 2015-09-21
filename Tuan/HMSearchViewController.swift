//
//  HMSearchViewController.swift
//  Tuan
//
//  Created by nero on 15/6/1.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMSearchViewController: HMDealListViewController {
    
    var selectedCity:HMCity?
    var lastParam:HMFindDealsParam?
    var totalCount = 0
    var footer:MJRefreshFooterView!
    var searchBar:UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
        *  设置导航栏的内容
        */
        func setupNav(){
            // 左边的返回
            navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "icon_back", highImageName: "icon_back_highlighted", target: self, action: Selector("back"))
            // 中间的搜索框
            let titleView = UIView(frame: CGRectZero)
            titleView.height = 30
            titleView.width = 400
            navigationItem.titleView = titleView
            searchBar  = UISearchBar()
            searchBar.backgroundImage = UIImage(named: "bg_login_textfield")
            titleView.addSubview(searchBar)
            searchBar.delegate = self
            searchBar.placeholder = "请输入关键词"
            searchBar.autoPinEdgesToSuperviewEdgesWithInsets( UIEdgeInsetsZero)
            
        }
        func setupRefresh(){
            
            footer = MJRefreshFooterView.footer()
            self.footer.scrollView = self.collectionView
            self.footer.delegate = self
            
        }
        setupNav()
        setupRefresh()
    }
    func back(){
        self.footer = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    func loadMoreDeals(){
        self.searchBar.userInteractionEnabled = false
        
        //        //        // 1.请求参数
        let param = HMFindDealsParam()
        //        // 关键词
        param.keyword = searchBar.text
        var x  = 0
        let operantion:String?
//        = operantion.lastPathComponent
        //        // 城市
        param.city = self.selectedCity?.name
        
        //        // 页码
        param.page = NSNumber(int:  self.lastParam!.page.intValue + 1)
        HMDealTool.findDeals(param, success: { (result) -> Void in
            self.totalCount = result.deals.count
            for deal in result.deals {
                self.deals.append(deal as! HMDeal)
            }
            self.collectionView?.reloadData()
            self.footer.endRefreshing()
            self.searchBar.userInteractionEnabled = true
            }) { (error) -> Void in
                MBProgressHUD.showError("加载团购失败，请稍后再试")
                self.footer.endRefreshing()
                param.page = NSNumber(int:  self.lastParam!.page.intValue - 1)
                self.searchBar.userInteractionEnabled = true
        }
        //        // 3.设置请求参数
        
        lastParam = param
        
    }
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func emptyIcon() -> String {
        return "icon_deals_empty"
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.footer.hidden = self.deals.count == totalCount
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.footer = nil
        
        
    }
}
extension HMSearchViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        MBProgressHUD.showMessage("正在搜索团购", toView: navigationController?.view)
        
        
        //        // 1.请求参数
        let param = HMFindDealsParam()
        //        // 关键词
        param.keyword = searchBar.text
        
        //        // 城市
        param.city = self.selectedCity?.name
        
        //        // 页码
        param.page = NSNumber(integer: 1)
        //
        //        // 2.搜索
        HMDealTool.findDeals(param, success: { (result) -> Void in
            
            self.deals.removeAll(keepCapacity: false)
            for deal in result.deals {
                self.deals.append(deal as! HMDeal)
            }
            self.collectionView?.reloadData()
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
            }) { (error) -> Void in
                MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
                MBProgressHUD.showError("加载团购失败，请稍后再试")
        }
        lastParam = param
        
    }
}
extension HMSearchViewController:MJRefreshBaseViewDelegate {
    func refreshViewBeginRefreshing(refreshView: MJRefreshBaseView!) {
        self.loadMoreDeals()
    }
}
