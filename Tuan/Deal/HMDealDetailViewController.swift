//
//  HMDealDetailViewController.swift
//  Tuan
//
//  Created by nero on 15/5/26.
//  Copyright (c) 2015年 nero. All rights reserved.
//  团购详情页

import UIKit

class HMDealDetailViewController: UIViewController {

//    @property (nonatomic, weak) UIActivityIndicatorView *loadingView;
    @IBOutlet weak var webView: UIWebView!
    var loadingView:UIActivityIndicatorView?
    var deal:HMDeal?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 230/255.0)
        self.webView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 230/255.0)
        //    // 加载网页
        webView.loadRequest(NSURLRequest(URL: NSURL(string: deal!.deal_h5_url)!))
        webView.scrollView.hidden = true
        println(deal!.deal_h5_url)
        
        //
        //    // 圈圈
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        webView.addSubview(loadingView!)
        loadingView?.startAnimating()
        loadingView?.autoCenterInSuperview()
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
    
}


