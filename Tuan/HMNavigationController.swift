//
//  HMNavigationController.swift
//  Tuan
//
//  Created by nero on 15/5/13.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override class func initialize(){
    UINavigationBar.appearance().setBackgroundImage(UIImage(named: "bg_navigationBar_normal")!, forBarMetrics: UIBarMetrics.Default)

        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 29/255.0, green: 177/157.0, blue: 157/255.0, alpha: 1.0)], forState: UIControlState.Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 210/255.0, green: 210/157.0, blue: 210/255.0, alpha: 1.0)], forState: UIControlState.Disabled)
        
    
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
