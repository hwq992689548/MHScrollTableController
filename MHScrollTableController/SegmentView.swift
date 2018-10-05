//
//  SegmentView.swift
//  MHScrollTableController
//
//  Created by  on 2018/10/4.
//  Copyright © 2018年 com.xiantian. All rights reserved.
//

import UIKit
protocol SegmentViewDelegate: NSObjectProtocol {
    func didSelectSegmentItem(index: NSInteger, item: Any);
}
class SegmentView: UIView {
    var delegate: SegmentViewDelegate!
    var collectionView: UICollectionView!
    var currentIndex: NSInteger = 0
    
    var itemArray: NSMutableArray  = [] {
        didSet {
            if self.itemArray.count > 0 {
                self.collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 100, height: frame.size.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout: layout)
        self.collectionView.register(SegmentViewCollectionCell.self , forCellWithReuseIdentifier:"segementCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = true
        self.collectionView.bounces = false
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
    }
    
    func setCurentIndex(index: NSInteger)  {
        self.currentIndex = index
        self.collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension SegmentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segementCell", for: indexPath) as! SegmentViewCollectionCell
        if self.itemArray.count > 0 {
            if self.currentIndex == indexPath.row {
                cell.backgroundColor = UIColor.orange
            }else{
                cell.backgroundColor = UIColor.gray
            }
            let titleStr = self.itemArray[indexPath.row] as! String
            cell.titleLab.text = titleStr
            
        }
        return cell
    }
    
    //点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil  {
            self.currentIndex = indexPath.row

            let titleStr = self.itemArray[indexPath.row] as! String
            self.delegate.didSelectSegmentItem(index: indexPath.row, item: titleStr)
        }
    }
}
extension SegmentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
}



class SegmentViewCollectionCell: UICollectionViewCell {
    var titleLab = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.titleLab.backgroundColor = UIColor.clear
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        self.titleLab.textColor = UIColor.black
        self.titleLab.textAlignment = .center
        self.contentView.addSubview(self.titleLab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
