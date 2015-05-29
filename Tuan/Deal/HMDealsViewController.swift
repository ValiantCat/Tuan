//
//  HMDealsViewController.swift
//  Tuan
//
//  Created by nero on 15/5/13.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit


class HMDealsViewController: HMDealListViewController {
    //MARK: -  顶部菜单
    /** 分类菜单 */
    var categoryMenu:HMDealsTopMenu!
    /** 区域菜单 */
    var regionMenu:HMDealsTopMenu!
    /** 排序菜单 */
    var sortMenu:HMDealsTopMenu!
    /** 选中的状态 */
    var selectedCity:HMCity!
    /** 当前选中的区域 */
    var selectedRegion:HMRegion!
    /** 当前选中的排序 */
    var selectedSort:HMSort!
    /** 当前选中的分类 */
    var selectedCategory:HMCategory!
    /** 当前选中的子分类名称 */
    var selectedSubCategoryName:String!
    /** 当前选中的子区域名称 */
    var selectedSubRegionName:String!
    //MARK: -  点击顶部菜单后弹出的Popover
    /** 分类Popover */
    lazy var categoryPopover:UIPopoverController = {
        let cv = HMCategoriesViewController()
        return UIPopoverController(contentViewController: cv)
        }()
    /** 区域Popover */
    lazy var regionPopover:UIPopoverController = {
        let rv = HMRegionsViewController()
        rv.view  = NSBundle.mainBundle().loadNibNamed("HMRegionsViewController", owner: rv, options: nil).last as! UIView
        
        var region =  UIPopoverController(contentViewController: rv)
        rv.changeCityClosuer = {
            region.dismissPopoverAnimated(false)
        }
        return region
        }()
    /** 排序Popover */
    lazy var sortPopover:UIPopoverController = {
        let sv = HMSortsViewController()
        return UIPopoverController(contentViewController:         HMSortsViewController(nibName: "HMSortsViewController", bundle: NSBundle.mainBundle()))
        }()
    
    /** 请求参数 */
    var   lastParam:HMFindDealsParam?
    var  header:MJRefreshHeaderView!
    var footer:MJRefreshFooterView!
    /// 团购数据

    /** 存储请求结果的总数*/

    var totalNumber:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSort = HMMetaDataTool.sharedMetaDataTool().selectedSort()
        selectedCity = HMMetaDataTool.sharedMetaDataTool().selectedCity()
        var rs = regionPopover.contentViewController as! HMRegionsViewController
        if selectedCity != nil {
        rs.regions = (selectedCity.regions as? [HMRegion] ) ?? nil  ;

        }

        setupMenu()
        setupNavLeft()
        setupNavRight()
        setupRefresh()
        //        监听通知
        HMNotificationCenter.addObserver(self, selector: Selector("citySelecte:"), name: HMCityNotification.HMCityDidSelectNotification, object: nil)
        HMNotificationCenter.addObserver(self, selector: Selector("sortSelect:"), name: HMSortNotification.HMSortDidSelectNotification, object: nil)
        HMNotificationCenter.addObserver(self, selector: Selector("categoryDidSelect:"), name: HMCategoryNotification.HMCategoryDidSelectNotification, object: nil)
        HMNotificationCenter.addObserver(self, selector: Selector("regionDidSelect:"), name: HMRegionNotification.HMRegionDidSelectNotification, object: nil)
        
    }
    func setupRefresh(){
        //        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
        self.header = MJRefreshHeaderView.header()
        self.footer = MJRefreshFooterView.footer()
        self.header.scrollView = self.collectionView
        self.footer.scrollView = self.collectionView
        self.header.delegate = self
        self.footer.delegate = self
        header.beginRefreshing()
        
    }
    func citySelecte(noti:NSNotification){
        var dict = noti.userInfo as! [String:HMCity]
        selectedCity = dict[HMCityNotification.HMSelectedCity]
        selectedRegion = selectedCity.regions.first as! HMRegion
        regionMenu.titleLabel.text = selectedCity?.name.stringByAppendingString(" - 全部")
        regionMenu.subtitleLabel.text = ""
        //
        var regionVc = regionPopover.contentViewController as! HMRegionsViewController
        regionVc.regions = selectedCity?.regions as! [HMRegion]
        header.beginRefreshing()
        
        // 存储用户的选择到沙盒
        HMMetaDataTool.sharedMetaDataTool().saveSelectedCityName(selectedCity.name)

    }
    func sortSelect(noti:NSNotification){
        var dict = noti.userInfo as! [String:HMSort]
        selectedSort = dict[HMSortNotification.HMSelectedSort]
        sortMenu.subtitleLabel.text = selectedSort?.label
        sortPopover.dismissPopoverAnimated(true)
        header.beginRefreshing()
        // 存储用户的选择到沙盒
        HMMetaDataTool.sharedMetaDataTool().saveSelectedSort(selectedSort)

    }
    func regionDidSelect(noti:NSNotification) {
        
        // 取出通知中的数据
        selectedRegion = noti.userInfo?[HMRegionNotification.HMSelectedRegion] as? HMRegion
        selectedSubRegionName = noti.userInfo?[HMRegionNotification.HMSelectedSubRegionName] as? String
        regionMenu.titleLabel.text = "\(selectedCity.name) - \(selectedRegion.name)"
        regionMenu.subtitleLabel.text = selectedSubRegionName
        // 设置菜单数据
        
        // 关闭popover
        regionPopover.dismissPopoverAnimated(true)
        header.beginRefreshing()
    }
    func categoryDidSelect(noti:NSNotification){
        
        // 取出通知中的数据
        selectedCategory = noti.userInfo?[HMCategoryNotification.HMSelectedCategory] as? HMCategory
        selectedSubCategoryName = noti.userInfo?[HMCategoryNotification.HMSelectedSubCategoryName] as? String
        
        
        // 设置菜单数据
        categoryMenu.imageButton.image = selectedCategory.icon
        categoryMenu.imageButton.highlightedImage = selectedCategory.highlighted_icon
        categoryMenu.titleLabel.text = selectedCategory.name
        categoryMenu.subtitleLabel.text = selectedSubCategoryName
        
        // 关闭popover
        categoryPopover.dismissPopoverAnimated(true)
        header.beginRefreshing()
    }
    
    deinit{
        HMNotificationCenter.removeObserver(self)
    }
    /**
    *  设置导航栏左边的内容
    */
    private func setupNavLeft() {
        
        // 1.LOGO
        var logoItem = UIBarButtonItem(imageName: "icon_meituan_logo", highImageName: "icon_meituan_logo", target: nil, action: nil)
        logoItem.customView?.userInteractionEnabled = false
        // 2.分类
        categoryMenu = HMDealsTopMenu()
        var categoryItem = UIBarButtonItem(customView: categoryMenu)
        categoryMenu.addTarget(self, action: Selector("categoryMenuClick"))
        // 3.区域
        regionMenu = HMDealsTopMenu()
        regionMenu.imageButton.image = "icon_district";
        regionMenu.imageButton.highlightedImage = "icon_district_highlighted";
        var selectName = selectedCity?.name ?? "   "
        regionMenu.titleLabel.text = "\(selectName) - 全部"
        var regionItem = UIBarButtonItem(customView: regionMenu)
        regionMenu.addTarget(self, action: Selector("regionMenuClick"))
        
        // 4.排序
        sortMenu = HMDealsTopMenu()
        var sortItem = UIBarButtonItem(customView: sortMenu)
        sortMenu.addTarget(self, action: Selector("sortMenuClick"))
        sortMenu.imageButton.image = "icon_sort";
        sortMenu.imageButton.highlightedImage = "icon_sort_highlighted"
        sortMenu.titleLabel.text = "排序"
           sortMenu.subtitleLabel.text = self.selectedSort?.label;
        self.navigationItem.leftBarButtonItems = [logoItem, categoryItem, regionItem, sortItem];
    }
    //    MARK: -leftItem Event
    /** 分类菜单 */
    func categoryMenuClick(){
        var cs = categoryPopover.contentViewController as! HMCategoriesViewController
        cs.selectedCategory = selectedCategory
        cs.selectedSubCategoryName = selectedSubCategoryName;
        categoryPopover.presentPopoverFromRect(categoryMenu.bounds, inView: categoryMenu, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    /** 区域菜单 */
    func regionMenuClick(){
        var rs = regionPopover.contentViewController as! HMRegionsViewController
        
        rs.selectedRegion = selectedRegion;
        rs.selectedSubRegionName = selectedSubRegionName;
        regionPopover.presentPopoverFromRect(regionMenu.bounds, inView: regionMenu, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    /** 排序菜单 */
    func sortMenuClick(){
        
        var os = sortPopover.contentViewController as! HMSortsViewController
        os.selectedSort = self.selectedSort;
        sortPopover.presentPopoverFromRect(sortMenu.bounds, inView: sortMenu, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    /**
    *MARK:-  设置导航栏右边的内容
    */
    private func setupNavRight() {
        //    // 1.地图
        var mapItem = UIBarButtonItem(imageName: "icon_map", highImageName: "icon_map_highlighted", target: self    , action: Selector("mapClick"))
        mapItem.customView?.width = 50
        mapItem.customView?.height = 27
        
        
        //    // 2.搜索
        
        var  searchItem = UIBarButtonItem(imageName: "icon_search", highImageName: "icon_search_highlighted", target: self, action: Selector("searchClick"))
        searchItem.customView?.width = mapItem.customView!.width
        searchItem.customView?.width = mapItem.customView!.height
        self.navigationItem.rightBarButtonItems = [mapItem,searchItem]
        
    }
    
    /**
    *  搜索
    */
    func searchClick() {
        
    }
    
    /**
    *  地图
    */
    func mapClick(){
        
    }
    /**
    封装请求参数
    
    :returns: param
    */
    func buildParam() -> HMFindDealsParam {
        var param = HMFindDealsParam()
        // 城市名称
        param.city = selectedCity?.name
        if selectedSort != nil {
            param.sort = NSNumber(int: selectedSort.value)
        }
        // 除开“全部分类”和“全部”以外的所有词语都可以发
        if selectedCategory != nil && !(selectedCategory?.name == "全部分类") {
            if selectedSubCategoryName != nil && !(self.selectedSubCategoryName == "全部"){
                param.category = selectedSubCategoryName
            }else{
                param.category = selectedCategory?.name
            }
            
        }
        
        
        if selectedRegion != nil && !(selectedRegion?.name == "全部" ){
            if selectedSubRegionName != nil && !(selectedSubRegionName == "全部"){
                
                param.region = selectedSubRegionName
            }else{
                param.region = selectedRegion?.name
            }
        }
        param.page = NSNumber(int: 1)
        return param
        
        
    }
    
    
    func loadNewDeals(){
        //    // 1.创建请求参数
        var param = buildParam()
        //    // 2.加载数据
        HMDealTool.findDeals(param, success: { (result) -> Void in
            if param != self.lastParam {return }
            // 记录总数
            self.totalNumber = Int(result.total_count)
            //    // 清空之前的所有数据
                self.deals.removeAll(keepCapacity: false)
            for deal in result.deals {
                self.deals.append(deal as! HMDeal)
            }
            self.collectionView?.reloadData()
            self.header.endRefreshing()
            }) { (error) -> Void in
                if param != self.lastParam {return }
                MBProgressHUD.showError("加载团购失败，请稍后再试")
                self.header.endRefreshing()
        }
        
        //    // 3.保存请求参数
        self.lastParam = param;
    }
    
    /**
    加载新数据
    */
    #if false
    func loadXXXNewDeals(){
        HMDealTool.loadNewDeals(selectedCity, selectSort: selectedSort, selectedCategory: selectedCategory, selectedRegion: selectedRegion, selectedSubCategoryName: selectedSubCategoryName, selectedSubRegionName: selectedSubRegionName) { (result) -> Void in
            // 清空之前的所有数据
            
            self.deals = [HMDeal]()
            // 添加新的数据
            for deal in result {
                self.deals.append(deal as! HMDeal)
            }
            // 刷新表格
            self.collectionView?.reloadData()
        }
    }
    #endif
    /**
    加载更多
    */
    func loadMoreDeals(){
        //    // 1.创建请求参数
        var param = buildParam()
        //    // 页码
        if let  lastParam = self.lastParam {
            var currentPage = lastParam.page.intValue + 1
            param.page = NSNumber(int: currentPage)
        }
        HMDealTool.findDeals(param, success: { (result) -> Void in
            if param != self.lastParam {return }
            for deal in result.deals {
                self.deals.append(deal as! HMDeal)
            }
            self.collectionView?.reloadData()
            self.footer.endRefreshing()
            }) { (error) -> Void in
                if param != self.lastParam {return }
                MBProgressHUD.showError("加载团购失败，请稍后再试")
                //    // 结束刷新
                self.footer.endRefreshing()
                //    // 回滚页码
                if let  lastParam = self.lastParam {
                    var currentPage = lastParam.page.intValue - 1
                    param.page = NSNumber(int: currentPage)
                }
        }
        self.lastParam = param
    }
    
    
    // MARK: - 初始化菜单
    private   func setupMenu(){
        
        //            // 1.周边的item
        var mineItem = itemWithContent("icon_pathMenu_mine_normal", highlightedContent: "icon_pathMenu_mine_highlighted")
        var  collectItem = itemWithContent("icon_pathMenu_collect_normal" , highlightedContent: "icon_pathMenu_collect_highlighted")
        var scanItem = itemWithContent("icon_pathMenu_scan_normal", highlightedContent: "icon_pathMenu_more_normal")
        var moreItem =  itemWithContent("icon_pathMenu_more_normal", highlightedContent: "icon_pathMenu_more_highlighted")
        var items = [mineItem,collectItem,scanItem,moreItem]
        //            // 2.中间的开始tiem
        var startItem = AwesomeMenuItem(image: UIImage(named: "icon_pathMenu_background_normal"), highlightedImage:  UIImage(named:"icon_pathMenu_background_highlighted"), contentImage:  UIImage(named:"icon_pathMenu_mainMine_normal"), highlightedContentImage:  UIImage(named:"icon_pathMenu_mainMine_highlighted"))
        var menu = AwesomeMenu(frame: CGRectZero, startItem: startItem, optionMenus: items)
        view.addSubview(menu)
        
        //            // 真个菜单的活动范围
        menu.menuWholeAngle = CGFloat( M_PI_2);
        //            // 约束
        var  menuH:CGFloat = 200
        menu.autoSetDimensionsToSize(CGSize(width: 200, height: menuH))
        menu.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        menu.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 0)
        //            // 3.添加一个背景
        let menubg = UIImageView()
        menubg.image = UIImage(named: "icon_pathMenu_background")
        menu.insertSubview(menubg, atIndex: 0)
        
        // 约束
        menubg.autoSetDimensionsToSize(menubg.image!.size)
        menubg.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        
        menubg.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 0)
        //            // 起点
        menu.startPoint = CGPoint(x: menubg.image!.size.width * 0.5, y: menuH - menubg.image!.size.height * 0.5)
        //            // 禁止中间按钮旋转
        menu.rotateAddButton = false
        //
        //            // 设置代理
        menu.delegate = self;
        //
        menu.alpha = CGFloat(0.2)
    }
    private  func itemWithContent(content:String ,  highlightedContent:String) ->AwesomeMenuItem {
        let bg = UIImage(named: "bg_pathMenu_black_normal");
        return AwesomeMenuItem(image: bg, highlightedImage: nil, contentImage: UIImage(named: content), highlightedContentImage: UIImage(named: highlightedContent))
    }
    
}

extension HMDealsViewController:AwesomeMenuDelegate {
    func awesomeMenuWillAnimateClose(menu: AwesomeMenu!) {
        // 恢复图片
        menu.contentImage = UIImage(named: "icon_pathMenu_mainMine_normal")
        menu.highlightedContentImage = UIImage(named: "icon_pathMenu_mainMine_highlighted")
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            menu.alpha = CGFloat(0.2)
        })
    }
    
    func awesomeMenuWillAnimateOpen(menu: AwesomeMenu!) {
        // 显示xx图片
        menu.contentImage = UIImage(named: "icon_pathMenu_cross_normal");
        menu.highlightedContentImage = UIImage(named: "icon_pathMenu_cross_highlighted")
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            menu.alpha = CGFloat(1)
        })
    }
    func awesomeMenu(menu: AwesomeMenu!, didSelectIndex idx: Int) {
        awesomeMenuWillAnimateClose(menu)
        if (idx == 1) { // 收藏
            let collec = HMCollectViewController(collectionViewLayout: UICollectionViewFlowLayout())
            var nav = HMNavigationController(rootViewController: collec)
            presentViewController(nav, animated: true, completion: nil)
        } else if (idx == 2) { // 浏览记录
            let history = HMHistoryViewController(collectionViewLayout: UICollectionViewFlowLayout())
            var nav = HMNavigationController(rootViewController: history)
            presentViewController(nav, animated: true, completion: nil)
        }
    }
    
}
//  MARK: - cell And Layout
extension HMDealsViewController {
//    #warning 如果要在数据个数发生的改变时做出响应，那么响应操作可以考虑在数据源方法中实现
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 尾部控件的可见性
        self.footer.hidden = (self.deals.count == self.totalNumber);
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }

}
extension HMDealsViewController: MJRefreshBaseViewDelegate {
    func refreshViewBeginRefreshing(refreshView: MJRefreshBaseView!) {
        if refreshView === self.header {
            self.loadNewDeals()
        }else if refreshView === self.footer {
            self.loadMoreDeals()
        }
    }
    
}
//MARK: - emptyView ICON
extension HMDealsViewController {
    override func emptyIcon() -> String {
        return "icon_deals_empty"
    }
}


