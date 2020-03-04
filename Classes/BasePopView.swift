//
//  BasePopView.swift
//  FastContact
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019年 jamalping. All rights reserved.
//

import UIKit

enum ShowType {
    case bottomToTop
    case center
}

class BasePopView: UIView {
    
    var showType: ShowType = .center
    var duration: TimeInterval = 0.23
    
    private let kWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first!
    
    lazy var markView: UIView = {
        let view = UIView.init(frame: self.kWindow.bounds)
        view.backgroundColor =  UIColor.black.withAlphaComponent(0.3)
        view.frame.origin.y = UIScreen.main.bounds.maxY
        return view
    }()
    
    /// 动画显示
    func show() {
        markView.addSubview(self)
        kWindow.addSubview(markView)
        switch showType {
        case .center:
            self.markView.frame.origin.y = 0
            markView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: duration) {
                self.markView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        case .bottomToTop:
            self.markView.frame.origin.y = kWindow.height
            UIView.animate(withDuration: duration) {
                self.markView.frame.origin.y = 0
            }
        default:
            break
        }
        
    }
    
    /// 隐藏
    func hidden() {
        switch showType {
        case .center:
            UIView.animate(withDuration: duration, animations: {
                self.markView.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (_) in
                self.markView.subviews.forEach{ $0.removeFromSuperview() }
                self.markView.removeFromSuperview()
            }
        case .bottomToTop:
            UIView.animate(withDuration: duration, animations: {
                self.markView.frame.origin.y = self.kWindow.height
            }) { (_) in
                self.markView.subviews.forEach{ $0.removeFromSuperview() }
                self.markView.removeFromSuperview()
            }
        default:
            break
        }
        
    }
    
    
    deinit {
        print(self, "\n deinit")
    }

}

