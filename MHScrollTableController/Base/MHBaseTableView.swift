//
//  MHBaseTableView.swift
//  MHScrollTableController
//
//  Created by  on 2018/10/3.
//  Copyright © 2018年 com.xiantian. All rights reserved.
//

import UIKit

class MHBaseTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


// MARK: -  同时识别多个手势
extension MHBaseTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true
    }
}
