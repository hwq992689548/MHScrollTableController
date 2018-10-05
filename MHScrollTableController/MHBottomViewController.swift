//
//  MHBottomViewController.swift
//  MHScrollTableController
//
//  Created by  on 2018/10/3.
//  Copyright © 2018年 com.xiantian. All rights reserved.
//

import UIKit

class MHBottomViewController: UIViewController {
    var tableView: MHBaseTableView!
    var fingerIsTouch = false
    var vcCanScroll = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = MHBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: UITableViewStyle.grouped)
        self.tableView.register(UITableViewCell.self , forCellReuseIdentifier: "myCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        self.tableView.tableHeaderView = headerView

        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        self.tableView.tableFooterView = footer

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension MHBottomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) 
        cell.textLabel?.text = "myCell"
        return cell
    }
}

extension MHBottomViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension MHBottomViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("接触屏幕")
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("松开屏幕")
    }
    
    //滑动时调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.vcCanScroll == false  {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            self.vcCanScroll = false
            scrollView.contentOffset = CGPoint.zero
            //往下滑动 bannerView即将出现时发送通知 
            NotificationCenter.default.post(name: NSNotification.Name.init("leaveTop"), object: nil)
        }
    }
}
