# MHScrollTableController

###
 主要的设置 scrollview（tableView）同时识别多个手势
// MARK: -  同时识别多个手势
    extension MHBaseTableView: UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
             return true
        }
    }


###
用通知的形势来区分什么时候哪个tableview滑动，哪个不能滑动
直接上代码

 一、ViewController.swfit中，用一个大的tableView，分两组，第2组cell2是装载可以左右滑动的vc (用collectionView来装载vc的view实现左右滑动)
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
        }

###
 二 、 MHBottomViewController是底部控制器, 里面有 可以上下滑动的tableView
extension MHBottomViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("接触屏幕")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      print("松开屏幕")
    }
    
     //往下滑动 bannerView即将出现时发送通知 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.vcCanScroll == false  {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            self.vcCanScroll = false
            scrollView.contentOffset = CGPoint.zero
            NotificationCenter.default.post(name: NSNotification.Name.init("leaveTop"), object: nil)
        }
    }
}


