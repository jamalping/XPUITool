//
//  TestRingProgrssVC.swift
//  XPUIToolExample
//
//  Created by midland on 2019/11/4.
//  Copyright © 2019 worldunion. All rights reserved.
//

import UIKit


/// 弧度转角度
public func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
    return ((radians) * (180.0 / CGFloat.pi))
}

/// 角度转弧度
public func degreesToRadians(_ angle: CGFloat) -> CGFloat {
    return ((angle) / 180.0 * CGFloat.pi)
}

/// 环形进度测试vc
class TestRingProgrssVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "环形进度"
        view.backgroundColor = .white
        
    
        self.view.addSubview(myView)
        
        circleProgressView()
    }
    
    lazy var myView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 300, height: 300))
        view.backgroundColor = .clear
        return view
    }()
    
    /*
    步骤
    1、新建UIBezierPath对象bezierPath
    2、新建CAShapeLayer对象caShapeLayer
    3、将bezierPath的CGPath赋值给caShapeLayer的path，即caShapeLayer.path = bezierPath.CGPath
    4、把caShapeLayer添加到某个显示该图形的layer中
    5、设置渐变(可选)
    6、设置CABasicAnimation 动画属性为strokeEnd
    */
    func circleProgressView() {
        
        let backPath = UIBezierPath.init(arcCenter: CGPoint.init(x: 300/2, y: 300/2), radius: 140, startAngle: degreesToRadians(-240), endAngle: degreesToRadians(-300)+degreesToRadians(360), clockwise: true)
        
        let progressPath = UIBezierPath.init(arcCenter: CGPoint.init(x: 300/2, y: 300/2), radius: 140, startAngle: degreesToRadians(-240), endAngle: degreesToRadians(-300)+degreesToRadians(360), clockwise: true)
        
        let backShapeLayer = CAShapeLayer()
        backShapeLayer.path = backPath.cgPath
        backShapeLayer.lineWidth = 10
        backShapeLayer.strokeColor = UIColor.gray.cgColor
        backShapeLayer.fillColor = UIColor.clear.cgColor
        self.myView.layer.addSublayer(backShapeLayer)
        
        let proShapeLayer = CAShapeLayer()
        proShapeLayer.path = progressPath.cgPath
        proShapeLayer.lineWidth = 10
//        proShapeLayer.cornerRadius
        proShapeLayer.strokeColor = UIColor.init(hexString: "#CA9459").cgColor
        proShapeLayer.fillColor = UIColor.clear.cgColor
        self.myView.layer.addSublayer(proShapeLayer)
        
        // 设置渐变色
        let graLayer = CAGradientLayer()
        graLayer.frame = self.myView.bounds
//        graLayer.colors = [UIColor.init(hexString: "#CA9459").cgColor, UIColor.init(hexString: "#ECC586").cgColor]
        graLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        graLayer.locations = [0.1, 1]
        graLayer.startPoint = CGPoint.init(x: 0, y: 1)
        graLayer.endPoint = CGPoint.init(x: 1, y: 0)
        self.myView.layer.addSublayer(graLayer)
        graLayer.mask = proShapeLayer
//
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        proShapeLayer.add(animation, forKey: nil)
        
        let alpheAnimation = CABasicAnimation.init(keyPath: "opacity")
        alpheAnimation.fromValue = 1
        alpheAnimation.toValue = 0
        alpheAnimation.duration = 3
        proShapeLayer.add(animation, forKey: nil)

        
    }
}

