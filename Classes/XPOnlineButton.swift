//
//  XPOnlineButton.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/26.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class XPOnlineButton: UIButton {
    
    /// 在线状态
    ///
    /// - videoOnline: 视频在线
    /// - audioOnline: 语音在线
    /// - offline: 离线
    enum OnlineType {
        case videoOnline
        case audioOnline
        case offline
    }
    
    var animationIma: UIView = UIView.init(backGroundColor: .cyan)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
        
        
        
//        huaxian()
        
        videoanimation()
    }
    
    
    func config() {
        
        self.addSubview(animationIma)
        
        animationIma.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(40)
        }
    }
    
    func videoanimation() {
        let replicationLayer = CAReplicatorLayer()
        replicationLayer.instanceCount = 3
        replicationLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        replicationLayer.instanceDelay = 0.1
        replicationLayer.instanceColor = UIColor.red.cgColor
        
        let layer = CALayer()
        layer.position = CGPoint.init(x: 8, y: self.height)
        layer.anchorPoint = CGPoint.init(x: 0, y: 1)
        layer.bounds = CGRect.init(x: 0, y: 0, width: 5, height: self.height/2)
        layer.backgroundColor = UIColor.white.cgColor
        
        let baseAnimation = CABasicAnimation()
        baseAnimation.keyPath = "transform.scale.y"
        baseAnimation.toValue = 0.1
        baseAnimation.repeatCount = MAXFLOAT
        baseAnimation.duration = 0.5
        baseAnimation.autoreverses = true
        
        layer.add(baseAnimation, forKey: "baseAnimation")
        replicationLayer.addSublayer(layer)
        self.layer.addSublayer(replicationLayer)
    }
    
    func huaxian() {
        let bezier = UIBezierPath.init(arcCenter: CGPoint.init(x: 0, y: 20), radius: 4, startAngle: CGFloat.pi/4.0, endAngle: -CGFloat.pi/4.0, clockwise: false)
        bezier.append(UIBezierPath.init(arcCenter: CGPoint.init(x: 0, y: 20), radius: 8, startAngle: CGFloat.pi/4.0, endAngle: -CGFloat.pi/4.0, clockwise: false))
        bezier.append(UIBezierPath.init(arcCenter: CGPoint.init(x: 0, y: 20), radius: 12, startAngle: CGFloat.pi/4.0, endAngle: -CGFloat.pi/4.0, clockwise: false))
        
        let shap = CAShapeLayer()
        shap.path = bezier.cgPath
        shap.lineWidth = 1
        shap.fillColor = UIColor.clear.cgColor
        shap.strokeColor = UIColor.gray.cgColor //路径颜色
        animationIma.layer.addSublayer(shap)
        
        let animation = CABasicAnimation.init(keyPath: "size.width")
        animation.fromValue = 4
        animation.toValue = 12
        animation.duration = 2
        animation.repeatCount = Float.infinity
//        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        animation.isRemovedOnCompletion = false
        shap.add(animation, forKey: "animation")
    }

    
    func care() {
        let replicat = CAReplicatorLayer()
        replicat.instanceCount = 3
        replicat.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        replicat.instanceDelay = 1
        
        let layer = CALayer()
        layer.position = CGPoint.init(x: 15, y: 400)
        layer.anchorPoint = CGPoint.init(x: 0, y: 1)
        layer.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 100)
        layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
