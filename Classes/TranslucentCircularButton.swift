//
//  TranslucentCircularButton.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/5.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

// MARK: - 圆形半透明按钮
class TranslucentCircularButton: UIButton {
    /// use: 必须用frame初始化
    init(frame: CGRect,_ imageName: String) {
        super.init(frame: frame)
        self.setImage(UIImage.init(named: imageName), for: .normal)
        self.circleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
