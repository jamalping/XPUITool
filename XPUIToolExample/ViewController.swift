//
//  ViewController.swift
//  XPUIToolExample
//
//  Created by xp on 2018/6/1.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

extension UIView {
    public func circleView(frame: CGRect? = nil) {
        print("yuan")
        let aFrame = frame ?? self.bounds
        let maskPath = UIBezierPath.init(roundedRect: aFrame, byRoundingCorners: .allCorners, cornerRadii: aFrame.size)
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

class ViewController: UIViewController {

    lazy var TCButton = TranslucentCircularButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), "videoClose")
    
    var contentView: XPPageContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(TCButton)
        TCButton.backgroundColor = .red
        
        layout()
        

        
    }
    func layout() {
        TCButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(200)
            make.width.height.equalTo(50)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = XPSlideViewController()
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

