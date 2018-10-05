//
//  MHBottomTableViewCell.swift
//  MHScrollTableController
//
//  Created by  on 2018/10/3.
//  Copyright © 2018年 com.xiantian. All rights reserved.
//

import UIKit
protocol MHBottomTableViewCellDelegate: NSObjectProtocol {
    func mhBottomTableViewControllerScrollViewDidScroll(scrollView: UIScrollView);
}

class MHBottomTableViewCell: UITableViewCell {
    var delegate:MHBottomTableViewCellDelegate!
    var cellCanScroll = false
    var vcArray = NSMutableArray()
    var collectionView: UICollectionView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //模拟数据
        for _ in 0 ..< 5 {
            let vc = MHBottomViewController()
            vc.view.frame = CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
            vc.tableView.backgroundColor = self.randomColor()
            self.vcArray.add(vc)
        }
        
        //collectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: kScreen_width, height: kScreen_height)
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), collectionViewLayout: layout)
        self.collectionView.register(UICollectionViewCell.self , forCellWithReuseIdentifier: "collectionCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.bounces = false
        self.collectionView.isPagingEnabled = true
        self.contentView.addSubview(self.collectionView)
        
    }
    
    
    /// 随机色
    ///
    /// - Returns:
    func randomColor() -> UIColor {
        let r = arc4random() % 255
        let g = arc4random() % 255
        let b = arc4random() % 255
        return UIColor.init(red: CGFloat(r), green: CGFloat(g) , blue: CGFloat(b) , alpha: 1)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// 设置cell中的滑动标识
    ///
    /// - Parameter flag:
    func setCannScroll(flag: Bool)  {
        self.cellCanScroll = flag
        for vc  in self.vcArray {
            let itemObj = vc as! MHBottomViewController
            itemObj.vcCanScroll = flag
            if self.cellCanScroll == false {
                //到顶
                itemObj.tableView.contentOffset = CGPoint.zero
            }
        }
    }
}


// MARK: - collectionView代理
extension MHBottomTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        if self.vcArray.count > indexPath.row {
            //添加vc到collectionCell中
            let vc = self.vcArray[indexPath.row] as! UIViewController
            cell.contentView.addSubview(vc.view)
        }
        
        return cell
    }
}
// MARK: - collectionView代理
extension MHBottomTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vcArray.count
    }
}


// MARK: - 横向滑动切换segment
extension MHBottomTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate.mhBottomTableViewControllerScrollViewDidScroll(scrollView: scrollView)

    }
}
