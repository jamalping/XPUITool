//
//  XPSlideViewController.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/12.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class XPSlideViewController: UIViewController {
    
    var titleView: XPSegmentTitleView?
    
    var contentView: XPPageContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView = XPSegmentTitleView.init(frame: CGRect.init(x: 0, y: 50, width: self.view.width, height: 50), titles: nil)
        titleView?.titles = ["我的钱包","我的VIP"]
        titleView?.xpSegmentTitleClick = {(index) in
            self.contentView?.currentIndex = index
        }
        self.view.addSubview(titleView!)
        
        var childVC = [UIViewController]()
        titleView?.titles.forEach { (_) in
            
            childVC.append(TVC())
        }
        
        contentView = XPPageContentView.init(frame: CGRect.init(x: 0, y: titleView?.bottom ?? 0, width: self.view.width, height: 200), childVCs: childVC, parentVC: self)
        contentView?.contentViewDidScroll = {(contentView, startIndex, endIndex) in
            print(contentView,startIndex,endIndex)
            self.titleView?.btnArray[Int(endIndex)].sendActions(for: .touchUpInside)
        }
        self.view.addSubview(contentView!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
