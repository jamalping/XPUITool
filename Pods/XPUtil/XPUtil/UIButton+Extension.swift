//
//  UIButton+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/4.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import UIKit


extension UIButton {
    
    // MARK: --- 表单提交按钮
    convenience init(formBtnTitle: String) {
        self.init(type: .custom)
        setTitle(formBtnTitle, for: .normal)
        
        setBackgroundImage(UIImage.init(color: UIColor.red), for: .normal)
        setBackgroundImage(UIImage.init(color: UIColor.gray), for: .disabled)
        setBackgroundImage(UIImage.init(color: UIColor.blue), for: .highlighted)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        titleLabel?.textAlignment = .center
        isEnabled = false
    }
    
    // MARK: --- 分段选择器按钮的创建
    convenience init(title: String, bNormalImg: UIImage?, bSelectedImg: UIImage?){
        self.init(type: .custom)
        self.setBackgroundImage(bNormalImg, for: .normal)
        self.setBackgroundImage(bSelectedImg, for: .selected)
        self.setTitleColor(.white, for: .selected)
//        self.setTitleColor(UIColor.titleTextColor, for: .normal)
        self.adjustsImageWhenHighlighted = false
        self.setTitle(title, for: .normal)
    }
    
    // 只有默认北
    convenience init(normalbackgroundImage: String) {
        self.init()
        self.setBackgroundImage(UIImage(named: normalbackgroundImage), for: .normal)
    }
    
    // 创建一般按钮
    convenience init(title: String, titleColor: UIColor, backGroundColor: UIColor, font: UIFont = .systemFont(ofSize: 13)) {
        self.init()
        self.backgroundColor = backGroundColor
        
        self.setTitle(title, for: UIControlState())
        
        self.titleLabel?.font = font
        
        self.setTitleColor(titleColor, for: UIControlState())
        
        self.layer.cornerRadius = 5
        
        self.layer.masksToBounds = true
    }
    
    convenience init(title: String, titleColor: UIColor, normalImg: UIImage, selectedimg: UIImage) {
        self.init()
        
        self.setTitle(title, for: .normal)
        
        self.setTitleColor(titleColor, for: .normal)
        
        self.setImage(normalImg, for: .normal)
        
        self.setImage(selectedimg, for: .selected)
        
    }
}

