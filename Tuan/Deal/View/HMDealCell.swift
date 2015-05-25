//
//  HMDealCell.swift
//  Tuan
//
//  Created by nero on 15/5/23.
//  Copyright (c) 2015年 nero. All rights reserved.
//

import UIKit
//@IBDesignable
class HMDealCell: UICollectionViewCell {
    override func drawRect(rect: CGRect) {
        UIImage(named: "bg_dealcell")?.drawInRect(rect)
    }
    
    @IBOutlet weak var dealNewView: UIImageView!
    @IBOutlet weak var  imageView:UIImageView!
    @IBOutlet weak var  titleLabel:UILabel!
    @IBOutlet weak var  descLabel:UILabel!
    @IBOutlet weak var  currentPriceLabel:UILabel!
    @IBOutlet weak var  purchaseCountLabel:UILabel!
    @IBOutlet weak var  listPriceLabel:HMCenterLineLabel!
    @IBOutlet weak var listPriceWidth: NSLayoutConstraint!
    @IBOutlet weak var currentPriceWidth: NSLayoutConstraint!
    var deal:HMDeal {
        set{
//             图片
//            在使用kingfas设置图片是 由于是swiftapi  所以ios8 以下版本无法使用
            if let imageurl = NSURL(string: newValue.image_url) {
                imageView.kf_setImageWithURL(imageurl)
            }

            // 标题
            titleLabel.text = newValue.title

            // 描述
            descLabel.text = newValue.desc

            // 现价
            currentPriceLabel.text = String(format: "￥%.0f",newValue.current_price)
            // 1弥补小误差

//            self.currentPriceWidth.constant = [self.currentPriceLabel.text sizeWithAttributes:@{NSFontAttributeName : self.currentPriceLabel.font}].width + 1;
            // 原价
            listPriceLabel.text = String(format: "￥%.0f", newValue.list_price)
            // 1弥补小误差
//            self.listPriceWidth.constant = [self.listPriceLabel.text sizeWithAttributes:@{NSFontAttributeName : self.listPriceLabel.font}].width + 1;
            // 购买数
            purchaseCountLabel.text = String(format: "已售出%d", newValue.purchase_count)
            
            
            
            // 判断是否为最新的团购：发布日期 >= 今天的日期
//            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            var  fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            if deal.publish_date == nil {return }
            if let  publish_date = fmt.dateFromString(deal.publish_date) {
            // 之前发布的：今天日期 > 发布日期
            self.dealNewView.hidden =  NSDate() >= publish_date ?? NSDate() //([today compare:deal.publish_date] == NSOrderedDescending);/
            }
        }
        get {
        return    HMDeal()
        }
    }
}
