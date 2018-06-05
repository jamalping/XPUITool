//
//  UIlabel+Extension.swift
//  XPUtil
//
//  Created by xp on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit

public extension UILabel {
    
    public convenience init(text: String = "text", textColor: UIColor = .black, font: UIFont = .boldSystemFont(ofSize: 13), textAlignment: NSTextAlignment = .left, frame: CGRect = .zero) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = 0
        self.textAlignment = textAlignment
        self.frame = frame
    }
    
    /// 获取内容高度
    public func getcontenHeight(width: CGFloat) -> CGFloat {
        guard let statusLabelText: NSString = self.text as NSString? else { return 0 }
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))

        let dic: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: self.font]
//        let dic: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: self.font]
        
        return statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size.height+0.5
    }
    
    /// 设置label的行距, 要在label有值得情况下设置
    ///
    /// - Parameter space: 行距
    public func setLineSpace(space: CGFloat) {
        guard let labelText = self.text else { return }
        let attributeString = NSMutableAttributedString.init(string: labelText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
//        attributeString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSMakeRange(0, labelText.length))
        self.attributedText = attributeString
    }
    
    /// 设置字间距, 要在label有值得情况下设置
    ///
    /// - Parameter space: 字间距
    public func setWordSpace(space: CGFloat) {
        guard let labelText = self.text else { return }
        let attributeString = NSMutableAttributedString.init(string: labelText, attributes: [NSAttributedStringKey.kern: space])
//        let attributeString = NSMutableAttributedString.init(string: labelText, attributes: [NSAttributedStringKey.kern: space])
        self.attributedText = attributeString
    }
    
    /// 设置行间距，字间距, 要在label有值得情况下设置
    ///
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字间距
    public func setSpace(lineSpace: CGFloat, wordSpace: CGFloat) {
        self.setLineSpace(space: lineSpace)
        self.setWordSpace(space: wordSpace)
    }
    
}

