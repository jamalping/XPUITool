//
//  ContinuegifAnimate.swift
//  XPUIToolExample
//
//  Created by Apple on 2019/1/16.
//  Copyright © 2019年 worldunion. All rights reserved.
//

import UIKit

class ContinuegifAnimate: NSObject {
    
    static let shareInsetance: ContinuegifAnimate = ContinuegifAnimate()
    private override init(){}
    var gifNum = 0 {
        didSet {
            self.numlabel.text = "X\(gifNum)"
            UIView.animate(withDuration: 0.25, animations: {
                self.numlabel.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            }) { (_) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.numlabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (_) in
                }
            }
            
            self.backView.layer.removeAnimation(forKey: "opacity")
            opacityAnimate()
            
            if self.backView.left == 0 { return }

            UIView.animate(withDuration: 0.2, animations: {
                self.backView.left = 0
            }) { (_) in
                UIView.animate(withDuration: 3, animations: {
                    self.opacityAnimate()
                }, completion: { (_) in
                    
                })
            }
            
        }
    }
    
    func opacityAnimate() {
        let opacity = Animate.shareInstance.baseAnimationWithKeyPath("opacity", fromValue: 1, toValue: 0, duration: 3, repeatCount: nil, timingFunction: nil)
        self.backView.layer.add(opacity, forKey: "opacity")
        Animate.shareInstance.stopAnimation = { (_,success) in
            if success {
                
                self.backView.removeFromSuperview()
            }
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView.init(backGroundColor: .red)
        view.addSubview(self.numlabel)
        return view
    }()
    
    lazy var numlabel: UILabel = UILabel.init(text: "X\(self.gifNum)", textColor: .blue, font: UIFont.systemFont(ofSize: 50), textAlignment: .left, frame: .zero)
    
    var superV: UIView? {
        didSet {
            guard let superV = superV else { return }
            if !superV.subviews.contains(backView){
                superV.addSubview(backView)
                backView.frame = CGRect.init(x: -300, y: 300, width: 300, height: 60)
                numlabel.frame = CGRect.init(x: backView.width, y: -60, width: 100, height: 100)
            }
        }
    }
}
