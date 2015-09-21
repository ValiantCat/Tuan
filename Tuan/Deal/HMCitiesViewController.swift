//
//  HMCitiesViewController.swift
//  Tuan
//
//  Created by nero on 15/5/18.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit
private let cellId = "citygroup"

class HMCitiesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var navBarTopLc: NSLayoutConstraint!
    @IBOutlet weak var cover: UIButton!
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func coverClick(sender: UIButton) {
        view.endEditing(true)
    }
    lazy var cityGroups:Array<HMCityGroup> = {
        return HMMetaDataTool.sharedMetaDataTool().cityGroups as! Array<HMCityGroup>
        }()
    lazy var citySearchVc:HMCitySearchViewController = {
        return HMCitySearchViewController()
        }()
    
}
extension HMCitiesViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // 更换背景
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield")
        searchBar.setShowsCancelButton(false, animated: true)
        // 让整体向下挪动
        navBarTopLc.constant = 0
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.cover.alpha = 0.0
        })
        // 清空文字
        searchBar.text = nil;
        // 移除城市搜索结果界面
        citySearchVc.view.removeFromSuperview()
    }
    /** 搜索框开始编辑（弹出键盘） */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // 更换背景
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield_hl")
        searchBar.setShowsCancelButton(true, animated: true)
        // 让整体向下挪动
        navBarTopLc.constant = -62
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.cover.alpha = 0.6
        })
    }
    /** 搜索框的文字发生改变的时候调用 */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        citySearchVc.view.removeFromSuperview()
        if !searchText.isEmpty{
            view.addSubview(citySearchVc.view)
//            MARK:- 控制器父子关系
            addChildViewController(citySearchVc)
            citySearchVc.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top)
            citySearchVc.view.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: searchBar)
            citySearchVc.searchText  = searchText
        }
    }
    /** 点击了取消 */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    //    MARK:- 让控制器在formSheet情况下也能正常退出键盘
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false
    }
}



extension HMCitiesViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cityGroups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = cityGroups[section]
        return group.cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! =  tableView.dequeueReusableCellWithIdentifier(cellId) 
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        let group = cityGroups[indexPath.section]

        let title = group.cities[indexPath.row] as! String
        cell.textLabel?.text = title
        return cell
    }


    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = cityGroups[section]
        return group.title
    }
    //    // Shift + Control + 单击 == 查看在xib\storyboard中重叠的所有UI控件
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]! {
        //    // 将cityGroups数组中所有元素的title属性值取出来，放到一个新的数组
        //    return [self.cityGroups valueForKeyPath:@"title"];
        let citysNSArray = NSArray(array: cityGroups)
        return citysNSArray.valueForKeyPath("title") as! [String]
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
        // 2.发出通知

        let group = cityGroups[indexPath.section]
        let cityName = group.cities[indexPath.row] as! String
        let city = HMMetaDataTool.sharedMetaDataTool().cityWithName(cityName)


        HMNotificationCenter.postNotificationName(HMCityNotification.HMCityDidSelectNotification, object: nil, userInfo: [HMCityNotification.HMSelectedCity:city])
    }
}




