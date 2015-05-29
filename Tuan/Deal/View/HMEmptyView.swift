//
//  UIImageView.swift
//  Tuan
//
//  Created by nero on 15/5/25.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit

class HMEmptyView: UIImageView {

    
    override func didMoveToWindow() {
        // 填充整个父控件
        if superview != nil {
        autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = UIViewContentMode.Center
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
