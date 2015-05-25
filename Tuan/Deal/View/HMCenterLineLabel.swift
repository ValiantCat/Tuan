//
//  HMCenterLineLabel.swift
//  Tuan
//
//  Created by nero on 15/5/25.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMCenterLineLabel: UILabel {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // 设置绘图颜色

            textColor.set()
        // 矩形框的值
        var  x:CGFloat = 0;
        var  y:CGFloat = self.height * 0.5;
        var  w = self.width;
        var  h:CGFloat = 0.5;
        UIRectFill(CGRectMake(x, y, w, h));
    }
}
