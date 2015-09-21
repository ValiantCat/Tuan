//
//  HMCitySearchViewController.swift
//  Tuan
//
//  Created by nero on 15/5/19.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit
private let cellId = "city"
class HMCitySearchViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    var resultCities = Array<HMCity>()

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return resultCities.count
    }
    var searchText:String! {
        willSet{
            // 根据搜索条件进行过滤
            let allCities = HMMetaDataTool.sharedMetaDataTool().cities as! Array<HMCity>
            // 将搜索条件转为小写
            let lowerSearchText = newValue.lowercaseString

            let pre = NSPredicate(format: "name.lowercaseString contains %@ or pinYin.lowercaseString contains %@ or pinYinHead.lowercaseString contains %@", lowerSearchText,lowerSearchText,lowerSearchText)
            let allnsarray = NSArray(array: allCities)
            let resultNSArray = allnsarray.filteredArrayUsingPredicate(pre)
            resultCities = resultNSArray as! Array<HMCity>
            self.tableView.reloadData()
            
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellId) 
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        let city = resultCities[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "共有\(resultCities.count)个搜索结果"
    }
//    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        只要父控制器加入childViewCOntroller 这句话会自动查找自己 -》父控制器-》父控制器  直到能dismiss
        dismissViewControllerAnimated(true, completion: nil)
        // 2.发出通知

        let city = resultCities[indexPath.row]
        HMNotificationCenter.postNotificationName(HMCityNotification.HMCityDidSelectNotification, object: nil, userInfo: [HMCityNotification.HMSelectedCity :city])

    }

}
