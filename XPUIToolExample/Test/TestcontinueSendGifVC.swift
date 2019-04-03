//
//  TestcontinueSendGifVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2019/1/16.
//  Copyright © 2019年 worldunion. All rights reserved.
//

import UIKit

class TestcontinueSendGifVC: UIViewController {
    
    
    
    /// 礼物个数
    var GIFNum = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "连续送礼物动画"
        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        GIFNum += 1
        print("连续送礼物",GIFNum)
        let animate = ContinuegifAnimate.shareInsetance
        animate.superV = self.view
        animate.gifNum = GIFNum
    }
    
    
}
