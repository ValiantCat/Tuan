//
//  NotificationCenter.swift
//  Tuan
//
//  Created by nero on 15/5/21.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import Foundation
let HMNotificationCenter = NSNotificationCenter.defaultCenter()
/** 通知 */

struct HMSortNotification {
    static    let  HMSortDidSelectNotification = "HMSortDidSelectNotification"
    static    let  HMSelectedSort  = "HMSelectedSort"
}
struct HMCityNotification {
    static    let HMCityDidSelectNotification = "HMCityDidSelectNotification"
    static    let  HMSelectedCity =  "HMSelectedCity"
}

struct HMCategoryNotification {
    static    let HMCategoryDidSelectNotification = "HMCategoryDidSelectNotification"
    static    let HMSelectedCategory = "HMSelectedCategory"
    static    let HMSelectedSubCategoryName = "HMSelectedSubCategoryName"
    
}
struct HMRegionNotification {
    
    static    let HMRegionDidSelectNotification = "HMRegionDidSelectNotification"
    static    let HMSelectedRegion = "HMSelectedRegion"
    static    let HMSelectedSubRegionName = "HMSelectedSubRegionName"
}
