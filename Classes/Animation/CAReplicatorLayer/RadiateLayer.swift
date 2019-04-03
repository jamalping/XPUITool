//
//  RadiateLayer.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/28.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class RadiateLayer: CAReplicatorLayer {
    
    var animationGroup: CAAnimationGroup?
    
    lazy var effect: CALayer = {
        let effect = CALayer()
        effect.contentsScale = UIScreen.main.scale
        effect.opacity = 0
        return effect
    }()
    
    var startRadius = 0.5
    var startAlpha = 0.5
    var animationDurantion = 2
    var useTimingFunction = true
    var keyTimeForHalfOpacity = 0.3
    
    var radius: CGFloat? {
        didSet {
            guard oldValue == nil else { return }
            let diameter = self.radius! * 2;
            self.effect.bounds = CGRect.init(x: 0, y: 0, width: diameter, height: diameter)
            self.effect.cornerRadius = self.radius!;
        }
    }
    
    override var backgroundColor: CGColor?{
        didSet {
            super.backgroundColor = backgroundColor
            self.effect.backgroundColor = backgroundColor
        }
    }
    
    override init() {
        super.init()
        self.addSublayer(effect)
        // 设置偏移
//        self.instanceTransform = CATransform3DMakeScale(5, 5, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        if let animation = animationWithGroup()  {
            self.effect.add(animation, forKey: "pluse")
        }
        
    }
    
    func animationWithGroup() -> CAAnimationGroup?  {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = CFTimeInterval(self.animationDurantion)
        animationGroup.repeatCount = self.repeatCount
        if self.useTimingFunction {
            let defaultCurve = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
            animationGroup.timingFunction = defaultCurve
        }
        
        let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale.xy")
        scaleAnimation.duration = CFTimeInterval(self.animationDurantion)
        scaleAnimation.fromValue = self.startRadius
        scaleAnimation.toValue = 1.0
        
        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnimation.duration = CFTimeInterval(self.animationDurantion)
        opacityAnimation.values = [self.startAlpha, 0.5, 0.0]
        opacityAnimation.keyTimes = [0.0, self.keyTimeForHalfOpacity, 1.0] as [NSNumber]
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        self.animationGroup = animationGroup
        self.animationGroup?.delegate = self
        return animationGroup
    }
}

extension RadiateLayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.effect.removeAllAnimations()
    }
}
