//
//  HMDealListViewController.swift
//  Tuan
//
//  Created by nero on 15/5/28.
//  Copyright (c) 2015年 nero. All rights reserved.
//  所有要显示cell 的父控制器


import UIKit

let reuseIdentifier = "Cell"

class HMDealListViewController: UICollectionViewController {

    /** 存放所有的团购数据 */
//    @property (nonatomic, strong) NSMutableArray *deals;
    var deals = [HMDeal]()

    override init(collectionViewLayout layout: UICollectionViewLayout) {

        // cell的尺寸
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(305, 305);

        super.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

    func emptyIcon() -> String {
        return "icon_deals_empty"
    }
    //    /** 没有数据时显示的view */
    
    lazy var emptyView:HMEmptyView = {
        var emp =  HMEmptyView(frame: CGRectZero)
        emp.image = UIImage(named: self.emptyIcon())
        self.view.insertSubview(emp, belowSubview: self.collectionView!)
        return emp
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置颜色
        self.collectionView?.backgroundColor = UIColor.clearColor()
        // 垂直方向上永远有弹簧效果
        self.collectionView?.alwaysBounceVertical = true
        
        self.view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)


        self.collectionView?.registerNib(UINib(nibName: "HMDealCell", bundle: nil), forCellWithReuseIdentifier: "deal")

    }

    // MARK: UICollectionViewDataSource

 

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        #warning 控制emptyView的可见性
        self.emptyView.hidden = (self.deals.count > 0);

        return deals.count

    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("deal", forIndexPath: indexPath) as! HMDealCell
        cell.delegate = self
        cell.deal = deals[indexPath.row]
        return cell;
        
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 弹出详情控制器
        
        var detailVc = HMDealDetailViewController(nibName: "HMDealDetailViewController", bundle: NSBundle.mainBundle())
        
        detailVc.deal = self.deals[indexPath.item]
        
        self.presentViewController(detailVc, animated: true, completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layout(view.width, orientation: interfaceOrientation)
    }
    //        MARK:  - 处理屏幕的旋转
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //        #warning 这里要注意：由于是即将旋转，最后的宽度就是现在的高度
        // 总宽度
        
        var  totalWidth = self.view.height;
        
        layout(totalWidth, orientation: toInterfaceOrientation)
    }
    //    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    //        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
    //    }
    /**
    调整布局
    
    :param: titalWidth  总宽度
    :param: orientation 方向
    */
    func layout(totalWidth:CGFloat , orientation:UIInterfaceOrientation) {
        // 总列数
        var  columns = CGFloat( UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3)
        var layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 每一行的最小间距
        var lineSpacing:CGFloat = 25
        // 每一列的最小间距
        
        var  interitemSpacing = ( totalWidth - columns * layout.itemSize.width) / (columns + 1);
        
        layout.minimumInteritemSpacing = interitemSpacing;
        layout.minimumLineSpacing = lineSpacing;
        // 设置cell与CollectionView边缘的间距
        layout.sectionInset = UIEdgeInsetsMake(lineSpacing, interitemSpacing, lineSpacing, interitemSpacing);
    }

 
}
extension HMDealListViewController:HMDealCellDelegate{
    func dealCellDidClickCover(dealCell: HMDealCell?) {
        println("super Class do Noting ")
    }
}
