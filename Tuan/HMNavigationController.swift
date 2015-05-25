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
    
    }

}
