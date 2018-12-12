//
//  TVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/12.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.randomColor()
    }
    
    func randomColor() -> UIColor {
        let r: CGFloat = CGFloat(arc4random() % UInt32(255.0))
        let g: CGFloat = CGFloat(arc4random() % UInt32(255.0))
        let b: CGFloat = CGFloat(arc4random() % UInt32(255.0))
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
}
