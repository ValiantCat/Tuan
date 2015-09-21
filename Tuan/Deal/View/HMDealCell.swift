//
//  HMDealCell.swift
//  Tuan
//
//  Created by nero on 15/5/23.
//  Copyright (c) 2015年 nero. All rights reserved.
//


import UIKit
import Kingfisher
import SwiftDate
protocol HMDealCellDelegate:class {
    func dealCellDidClickCover(dealCell:HMDealCell?)
    
}
//@IBDesignable
class HMDealCell: UICollectionViewCell {
    override func drawRect(rect: CGRect) {
        UIImage(named: "bg_dealcell")?.drawInRect(rect)
    }
    weak   var delegate:HMDealCellDelegate?
    @IBOutlet weak var dealNewView: UIImageView!
    @IBOutlet weak var  imageView:UIImageView!
    @IBOutlet weak var  titleLabel:UILabel!
    @IBOutlet weak var  descLabel:UILabel!
    @IBOutlet weak var  currentPriceLabel:UILabel!
    @IBOutlet weak var  purchaseCountLabel:UILabel!
    @IBOutlet weak var  listPriceLabel:HMCenterLineLabel!
    @IBOutlet weak var listPriceWidth: NSLayoutConstraint!
    @IBOutlet weak var currentPriceWidth: NSLayoutConstraint!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var cover: UIButton!
    @IBAction func coverClick() {
        self.deal.checking = !self.deal.checking;
        self.check.hidden = !self.check.hidden;
        
        delegate?.dealCellDidClickCover(self)


        
    }
    var deal:HMDeal! {
        willSet{
            if newValue == nil {return }
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
            currentPriceLabel.text = String(format: "￥%@",newValue.current_price)
            // 1弥补小误差
            
            //            self.currentPriceWidth.constant = [self.currentPriceLabel.text sizeWithAttributes:@{NSFontAttributeName : self.currentPriceLabel.font}].width + 1;
            // 原价
            listPriceLabel.text = String(format: "￥%@", newValue.list_price)
            // 1弥补小误差
            //            self.listPriceWidth.constant = [self.listPriceLabel.text sizeWithAttributes:@{NSFontAttributeName : self.listPriceLabel.font}].width + 1;
            // 购买数
            purchaseCountLabel.text = String(format: "已售出%d", newValue.purchase_count)
            // 判断是否为最新的团购：发布日期 >= 今天的日期
            //            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            let  fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            if newValue.publish_date == nil {return }
            if let  publish_date = fmt.dateFromString(newValue.publish_date) {
                // 之前发布的：今天日期 > 发布日期
                self.dealNewView.hidden =  NSDate() >= publish_date ?? NSDate() //([today compare:deal.publish_date] == NSOrderedDescending);/
            }
            
            // 设置编辑状态
            if newValue.editing  {
                self.cover.hidden = false;
            } else {
                self.cover.hidden = true;
            }
            
            // 设置勾选状态
            self.check.hidden = !newValue.checking;
            
        }
    }
    
    
    
    
    
}
