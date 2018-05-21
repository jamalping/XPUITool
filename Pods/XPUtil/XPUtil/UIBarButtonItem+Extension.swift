//
//  UIBarButtonItem+Extension.swift
//  Ecredit
//
//  Created by 刘军 on 2017/7/12.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import UIKit

private var key: Void?
extension UIBarButtonItem {
     var hasTextChange: Bool? {
        get {
            return objc_getAssociatedObject(self, &key) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 创建返回按钮
    ///
    /// - Parameters:
    ///   - normalImg: 图String
    ///   - target: <#target description#>
    ///   - action: <#action description#>
    convenience init(normalImg: String, target: Any?, action: Selector?) {
        
        let btn = UIButton(type: .custom)
        let norImg = UIImage(named: normalImg)?.withRenderingMode(.alwaysOriginal)
        if let norImg = norImg {
            btn.setImage(norImg, for: .normal)
            btn.setImage(norImg, for: .highlighted)
        }
        if let action = action {
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
        
        btn.frame = CGRect(x: -10, y: 2.5, width: 20, height: 25)
//        btn.backgroundColor = UIColor.red
        
        let view = UIView.init()
        view.addSubview(btn)
//        view.backgroundColor = UIColor.green
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 30)

        self.init(customView: view)
    }
    
    
    /// 创建关闭按钮
    ///
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - titleColor: <#titleColor description#>
    ///   - font: <#font description#>
    ///   - target: <#target description#>
    ///   - action: <#action description#>
    convenience init(title: String,titleColor: UIColor, font: UIFont = UIFont.systemFont(ofSize: 17), target: Any?, action: Selector?) {
    
    let btn = UIButton(type: .custom)
    
    btn.setTitle(title, for: .normal)
    
    btn.setTitleColor(titleColor, for: .normal)
    
    btn.titleLabel?.font = font
    
    if let action = action {
    btn.addTarget(target, action: action, for: .touchUpInside)
    }
    btn.sizeToFit()
    
    
    let view = UIView.init()
    view.addSubview(btn)
//    view.backgroundColor = UIColor.green
    view.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
    
    self.init(customView: view)

    }
 
}



//extension Reactive where Base: UIBarButtonItem {
//
//    func tapEvent() -> UIBindingObserver<UIBarButtonItem,Bool> {
//        return UIBindingObserver.init(UIElement: base, binding: { (btn, flag) in
//            btn.hasTextChange = flag
//        })
//    }
//}

extension UIBarButtonItem {
    public func acceptBtn() -> UIButton {
        for view in (self.customView?.subviews)! {
            if let btnView = view as? UIButton {
                return btnView
            }else{
                continue
            }
        }
        return UIButton()
    }
    
    public func acceptBtn(title: String) -> UIButton? {
        let btn = self.customView as! UIButton
        if btn.title(for: .normal) == title {
            return btn
        }
        return nil
    }
}
