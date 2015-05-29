//
//  HMDealDetailViewController.swift
//  Tuan
//
//  Created by nero on 15/5/26.
//  Copyright (c) 2015年 nero. All rights reserved.
//  团购详情页

import UIKit

class HMDealDetailViewController: UIViewController {


    @IBOutlet weak var webView: UIWebView!
    var loadingView:UIActivityIndicatorView?


    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var refundableAnyTimeButton: UIButton!
    @IBOutlet weak var refundableExpiresButton: UIButton!
    @IBOutlet weak var leftTimeButton: UIButton!
    @IBOutlet weak var purchaseCountButton: UIButton!
    
    var deal:HMDeal?
//    // label
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var listPriceLabel: HMCenterLineLabel!
    //    // 按钮
    @IBAction func share() {
        var alert = UIAlertController(title: "💗", message: "我没有搞分享  主要友盟更新太频繁了 分享经常不能用", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "寒哥, 我知道错了 ", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func collec() {
        if (self.collectButton.selected) {
            HMDealLocalTool.sharedDealLocalTool().unsaveCollectDeal(deal!)
            MBProgressHUD.showSuccess("取消收藏成功！")

            self.collectButton.selected = false
        } else {
            HMDealLocalTool.sharedDealLocalTool().saveCollectDeal(deal!)
            MBProgressHUD.showSuccess("收藏成功！")
            self.collectButton.selected = true
            
        }
    }
    @IBAction func buy() {
    }
    @IBAction func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        保存最近浏览记录
        HMDealLocalTool.sharedDealLocalTool().saveHistoryDeal(deal)

        // 判断是否收藏
        var collectDeals = HMDealLocalTool.sharedDealLocalTool().collectDeals
        collectButton.selected = collectDeals.containsObject(deal!)

        setupLeft()
        updateLeftContent()
        setupRight()
    }
    func setupLeft(){
        // 更新左边内容
        updateLeftContent()
        // 加载更详细的团购数据
        var param = HMGetSingleDealParam()
        param.deal_id = deal?.deal_id
        HMDealTool.getSingleDeal(param, success: { (result) -> Void in
            if let deals = result.deals where result.deals.count >= 0 {
                self.deal = deals.first as? HMDeal
                // 更新左边的内容
                self.updateLeftContent()
            }else{
              MBProgressHUD.showError("没有找到指定的团购信息")
            }
        }) { (error) -> Void in
            MBProgressHUD.showError("加载团购数据失败")
        }
    }
    /**
    加载右侧webview
    */
    func setupRight(){
        self.view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 230/255.0)
        self.webView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 230/255.0)
        //    // 加载网页
        webView.loadRequest(NSURLRequest(URL: NSURL(string: deal!.deal_h5_url)!))
        webView.scrollView.hidden = true
        println(deal!.deal_h5_url)
        
        //    // 圈圈
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        webView.addSubview(loadingView!)
        loadingView?.startAnimating()
        loadingView?.autoCenterInSuperview()
    }
    /**
    更新左侧详情
    */
    func updateLeftContent(){
        // 简单信息
        self.titleLabel.text = self.deal?.title;
        self.descLabel.text = self.deal?.desc;
        self.currentPriceLabel.text = "￥\(self.deal!.current_price)"
        self.listPriceLabel.text =  "门店价￥\( self.deal!.list_price)"
         self.purchaseCountButton.title = "已售出\(self.deal!.purchase_count)"
        if self.deal?.restrictions == nil {
            self.refundableAnyTimeButton.selected =   false
            self.refundableExpiresButton.selected = false
        }else{
        self.refundableAnyTimeButton.selected = self.deal?.restrictions.is_refundable ?? false
        self.refundableExpiresButton.selected = self.deal?.restrictions.is_refundable ?? false
        }
        
        
        /*
        // 剩余时间处理
        // 当前时间 2014-08-27 09:06
        NSDate *now = [NSDate date];
        // 过期时间 2014-08-28 00:00
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSDate *deadTime = [[fmt dateFromString:self.deal.purchase_deadline] dateByAddingTimeInterval:24 * 3600];
        // 比较2个时间的差距
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *cmps = [calendar components:unit fromDate:now toDate:deadTime options:0];
        if (cmps.day > 365) {
        self.leftTimeButton.title = @"一年内不过期";
        } else {
        self.leftTimeButton.title = [NSString stringWithFormat:@"%d天%d小时%d分", cmps.day, cmps.hour, cmps.minute];
        }
        */
        
        
    }

}

extension HMDealDetailViewController:UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        
        
        //    // 拼接详情的URL路径
        //    NSString *ID = self.deal.deal_id;
        var id = deal!.deal_id as NSString
        id = id.substringFromIndex(id.rangeOfString("-").location+1)
        var urlStr = "http://lite.m.dianping.com/group/deal/moreinfo/\(id)"
        urlStr = "http://m.dianping.com/tuan/deal/\(id)"

        //
        var webViewURL = webView.request?.URL?.absoluteString!
        if webViewURL == urlStr {
            var js = ""
            js = ("\(js) var bodyHTML = ';'")
            // 拼接link的内容
            js = ("\(js) var link = document.body.getElementsByTagName('link')[0];")
            js = ("\(js) bodyHTML += link.outerHTML;")
            //            / 拼接多个div的内容
            js = ("\(js) var divs = document.getElementsByClassName('detail-info');")
            js = ("\(js)  for (var i = 0; i<=divs.length; i++) {")
            js = ("\(js)  var div = divs[i];")
            js = ("\(js)  if (div) { bodyHTML += div.outerHTML; }")
            js = ("\(js) }")
            //    // 设置body的内容
            js.stringByAppendingString("document.body.innerHTML = bodyHTML;")
            //    // 执行JS代码
            webView.stringByEvaluatingJavaScriptFromString(js)
            //    // 显示网页内容
            webView.scrollView.hidden = false
            //    // 移除圈圈
            loadingView?.removeFromSuperview()

        }else{
            //    } else { // 加载初始网页完毕
            var js = "window.location.href = '\(urlStr)';"
            //    // 执行JS代码
            webView.stringByEvaluatingJavaScriptFromString(js)
        }
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Unknown.rawValue
    }
}


