//
//  TestOnlineButtonVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/26.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TestOnlineButtonVC: UIViewController {
    
    lazy var onlinebtn = XPOnlineButton.init(frame: CGRect.init(x: 100, y: 300, width: self.view.width-200, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "test onlineBtn"
        
        self.view.backgroundColor = .white
        onlinebtn.backgroundColor = .yellow
        self.view.addSubview(onlinebtn)
    }
}
