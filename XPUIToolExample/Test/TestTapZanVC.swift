//
//  TestTapZanVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2019/1/28.
//  Copyright © 2019年 worldunion. All rights reserved.
//

import UIKit
class TestTapZanVC: UIViewController {
    
    lazy var likeView: LikeView = {
        let likeView = LikeView.init(frame: CGRect.init(x: 100, y: 100, width: 60, height: 60))
        likeView.addSubview(likeView.normalButto)
        likeView.addTarget(self, action: #selector(tapLike(button:)), for: .touchUpInside)
        return likeView
    }()
    
    @objc func tapLike(button: UIButton) {
        button.isSelected = !button.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "仿抖音点赞动画"
        view.backgroundColor = .white
        
        let spath = UIBezierPath.init(ovalIn: CGRect.init(x: 150, y: 350, width: 0, height: 0))
        let epath = UIBezierPath.init(ovalIn: CGRect.init(x: 100, y: 300, width: 100, height: 100))
        
        
        let layer = CAShapeLayer()
        layer.path = spath.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(layer)
        
        let dd = Animate().baseAnimationWithKeyPath("path", fromValue: spath.cgPath, toValue: epath.cgPath, duration: 1, repeatCount: nil, timingFunction: nil)
        
        let ciclegroup = XPAnimationGroup()
        let ff = ciclegroup.animationGroup(duration: 1, animations: [dd])
        layer.add(ff, forKey: nil)
        
        self.view.addSubview(likeView)
    }
}


/// 点赞的View
class LikeView: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedAnimation(durantion: 0.8)
            }else {
                normalAnimation(duration:0.25)
            }
        }
    }
    
    /// 是否在动画
    var isAnimating: Bool = false {
        didSet {
            self.isUserInteractionEnabled = !isAnimating
        }
    }
    
    lazy var normalButto: UIButton = {
        let button = UIButton.init(frame: self.bounds)
        button.setImage(UIImage.init(named: "Following"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var selectedButto: UIButton = {
        let button = UIButton.init(frame: self.bounds)
        button.setImage(UIImage.init(named: "Following_ig"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    /// 取消选中动画
    func normalAnimation(duration: CFTimeInterval) {
        isAnimating = true
        let scalaAnimation = Animate().baseAnimationWithKeyPath("transform.scale", fromValue: 1.0, toValue: 0.0, duration: duration, repeatCount: nil, timingFunction: nil)
        
        let xpGroup = XPAnimationGroup()
        let group = xpGroup.animationGroup(duration: scalaAnimation.duration, animations: [scalaAnimation])
        xpGroup.stopAnimation = { [weak self](anime,flag)in
            self?.selectedButto.removeFromSuperview()
            self?.isAnimating = false
        }
        self.selectedButto.layer.add(group, forKey: nil)
        
    }
    /// 选中动画
    func selectedAnimation(durantion: CFTimeInterval) {
        print("选中动画")
        isAnimating = true
        let scalaAnimation = Animate().baseAnimationWithKeyPath("transform.scale", fromValue: 1.0, toValue: 0.0, duration: durantion*0.33, repeatCount: nil, timingFunction: nil)

        let xpGroup = XPAnimationGroup()
        let group = xpGroup.animationGroup(duration: scalaAnimation.duration, animations: [scalaAnimation])
        xpGroup.stopAnimation = { [weak self](anime,flag)in
            self?.normalButto.removeFromSuperview()

            let scalaAnimation1 = Animate().baseAnimationWithKeyPath("transform.scale", fromValue: 0.0, toValue: 1.2, duration: durantion*0.33, repeatCount: nil, timingFunction: nil)
            self?.selectedButto.layer.add(scalaAnimation1, forKey: nil)
            self?.addSubview(self!.selectedButto)
            
            
            self?.cicleAnimation(duration: durantion*0.66)
        }
        self.normalButto.layer.add(group, forKey: "normalButto")


        let length = 30
        for i  in 0..<6 {

            let shapLayer = CAShapeLayer()
            shapLayer.position = CGPoint.init(x: self.width/2, y: self.height/2)
            shapLayer.fillColor = UIColor.red.cgColor

            let startPath = UIBezierPath()
            startPath.move(to: CGPoint.init(x: -2, y: -length))
            startPath.addLine(to: CGPoint.init(x: 2, y: -length))
            startPath.addLine(to: CGPoint.init(x: 0, y: 0))
            shapLayer.path = startPath.cgPath

            shapLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/3.0 * Double(i)), 0.0, 0.0, 1.0)
            self.layer.addSublayer(shapLayer)

            //缩放动画
            let scalaAni = Animate().baseAnimationWithKeyPath("transform.scale", fromValue: 0.0, toValue: 1.0, duration: durantion*0.33, repeatCount: nil, timingFunction: nil)
            scalaAni.beginTime = durantion*0.33

            //结束点
            let endPath = UIBezierPath()
            endPath.move(to: CGPoint.init(x: -2, y: -length))
            endPath.addLine(to: CGPoint.init(x: 2, y: -length))
            endPath.addLine(to: CGPoint.init(x: 0, y: -length))

            let pathAnima = Animate().baseAnimationWithKeyPath("path", fromValue: shapLayer.path, toValue: endPath.cgPath, duration: 0.33, repeatCount: 0, timingFunction: nil)
            pathAnima.beginTime = durantion*0.66

            let group1 = XPAnimationGroup()
            let sdfdg = group1.animationGroup(duration: durantion, animations: [scalaAni,pathAnima])
            shapLayer.add(sdfdg, forKey: nil)
            group1.stopAnimation = {[weak self](anima, flag) in
                self?.insertSubview(self!.normalButto, at: 0)
                shapLayer.removeFromSuperlayer()
            }
        }
        
    }
    
    func cicleAnimation(duration: CFTimeInterval) {
        let spath = UIBezierPath.init(ovalIn: CGRect.init(x: self.width/2, y: self.height/2, width: 0, height: 0))
        let epath = UIBezierPath.init(ovalIn: CGRect.init(x: -5, y: -5, width: self.width+10, height: self.height+10))
        
        
        let clayer = CAShapeLayer()
        clayer.path = spath.cgPath
        clayer.strokeColor = UIColor.red.cgColor
        clayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(clayer)
        
        let dd = Animate().baseAnimationWithKeyPath("path", fromValue: spath.cgPath, toValue: epath.cgPath, duration: duration*0.5, repeatCount: nil, timingFunction: nil)
        dd.beginTime = duration*0.5
        let ciclegroup = XPAnimationGroup()

        let ff = ciclegroup.animationGroup(duration: duration, animations: [dd])

        ciclegroup.stopAnimation = {[weak self](anim, flag) in
            clayer.removeFromSuperlayer()
            self?.isAnimating = false
        }
        clayer.add(ff, forKey: nil)
    }
}

