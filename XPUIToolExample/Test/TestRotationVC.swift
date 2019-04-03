//
//  TestRotationVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2019/1/12.
//  Copyright © 2019年 worldunion. All rights reserved.
//

import UIKit

class TestRotationVC: UIViewController {
    
    lazy var onlinebtn = XPOnlineButton.init(frame: CGRect.init(x: 100, y: 300, width: self.view.width-200, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "test onlineBtn"
        
        self.view.backgroundColor = .white
        onlinebtn.backgroundColor = .yellow
        self.view.addSubview(onlinebtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        startAnimate()
        
    }
    
    func startAnimate() {
        let scaleAnimate = Animate.shareInstance.baseAnimationWithKeyPath("transform.scale", fromValue: 0.5, toValue: 1.0, duration: 0.5, repeatCount: 2, timingFunction: nil)
        Animate.shareInstance.stopAnimation = { (animate, isFinish) -> () in
            let animate = Animate.shareInstance.baseAnimationWithKeyPath("transform.rotation.z", fromValue: nil , toValue: 2 * CGFloat.pi, duration: 1.0, repeatCount: nil, timingFunction: kCAMediaTimingFunctionLinear)
            
            Animate.shareInstance.stopAnimation = { (animate, isFinish) -> () in
                self.animation1()
            }
            
            self.onlinebtn.layer.add(animate, forKey: nil)
        }
        onlinebtn.layer.add(scaleAnimate, forKey: nil)
        
    }
    
    func animation1() {
       
        let opacityAnimate = Animate.shareInstance.baseAnimationWithKeyPath("opacity", fromValue: 1, toValue:0, duration: 1.0, repeatCount: nil, timingFunction: nil)
        
        let scaleAnimate = Animate.shareInstance.baseAnimationWithKeyPath("transform.scale", fromValue: nil, toValue: 2.0, duration: 1.0, repeatCount: Float.infinity, timingFunction: nil)
        
        //全部组合起来
        let groupAni = CAAnimationGroup()
        
        groupAni.animations = [opacityAnimate, scaleAnimate]
        groupAni.duration = 1.8
        //翻转huil
//        groupAni.autoreverses = true
        
        onlinebtn.layer.add(groupAni, forKey: "groupAnimation")
//        onlinebtn.layer.add(groupAni, forKey: nil)
    }
}
