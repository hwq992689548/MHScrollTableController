//
//  ViewController.swift
//  MHScrollTableController
//
//  Created by  on 2018/10/3.
//  Copyright © 2018年 com.xiantian. All rights reserved.
//

import UIKit
let kScreen_width = UIScreen.main.bounds.size.width
let kScreen_height = UIScreen.main.bounds.size.height
class ViewController: UIViewController {
    var tableView: MHBaseTableView!
    var contentCell:MHBottomTableViewCell!
    var canScroll = true
    var segmentView:SegmentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let vv = UIView.init(frame: CGRect.zero)
        self.view.addSubview(vv)
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        
        self.tableView = MHBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: UITableViewStyle.plain)
        self.tableView.estimatedRowHeight = 0.01
        self.tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell1")
        self.tableView.register(MHBottomTableViewCell.self , forCellReuseIdentifier: "cell2")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        self.tableView.tableHeaderView = headerView
        
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        self.tableView.tableFooterView = footer

        
        NotificationCenter.default.addObserver(self , selector: #selector(changeScrollStatus), name: NSNotification.Name.init("leaveTop"), object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true 
    }

    @objc func changeScrollStatus(){
        self.canScroll = true
        self.contentCell.setCannScroll(flag: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //顶部广告
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell.backgroundColor = UIColor.red
            cell.textLabel?.text = "bannerView"
            return cell

        }else if indexPath.section == 1{
            self.contentCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MHBottomTableViewCell
            self.contentCell.delegate = self
            return self.contentCell
        }
        return tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        return kScreen_height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 50))
            headerView.backgroundColor = UIColor.green
            
            self.segmentView = SegmentView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 50))
            self.segmentView.delegate = self 
            self.segmentView.itemArray = ["第一页","第二页","第三页","第四页","第五页"]
            headerView.addSubview(self.segmentView)
            
            return headerView

        }else{
            return UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        }
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomVC_offsetY = self.tableView.rect(forSection: 1).origin.y
        if scrollView.contentOffset.y >= bottomVC_offsetY {
            //滑到顶了
            //固定
            scrollView.contentOffset = CGPoint.init(x: 0, y: bottomVC_offsetY)
            if self.canScroll == true {
                self.canScroll = false
                self.contentCell.setCannScroll(flag: true)
            }
        }else{
            //未到顶
            if self.canScroll == false {
                scrollView.contentOffset = CGPoint.init(x: 0, y: bottomVC_offsetY)
            }
        }
        self.tableView.showsVerticalScrollIndicator = self.canScroll ? true:false
    }
}


// MARK: - 底部vc滑动代理
extension ViewController: MHBottomTableViewCellDelegate {
    func mhBottomTableViewControllerScrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let pageNo = NSInteger(offsetX/kScreen_width)
        self.segmentView.setCurentIndex(index: pageNo)
    }
}

extension ViewController: SegmentViewDelegate {
    func didSelectSegmentItem(index: NSInteger, item: Any) {
        self.contentCell.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
}






