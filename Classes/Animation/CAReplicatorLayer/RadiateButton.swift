//
//  RadiateButton.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/28.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

/// 具有向四周扩展的动画的按钮
class RadiateButton: UIView {
    
    lazy var button: UIButton = {
        let button = UIButton.init(title: "搞起", titleColor: .white, backGroundColor: UIColor.init(valueHex: 0xe352f9))
        
        return button
    }()
    
    lazy var radiateLayer: RadiateLayer = {
        let layer = RadiateLayer()
        layer.backgroundColor = UIColor.init(valueHex: 0xe24bf9).cgColor
        layer.radius = self.height/2
        layer.repeatCount = Float.infinity
        layer.instanceCount = 3
        layer.instanceDelay = 0.3
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configPage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configPage()
    }
    
    func configPage() {
        self.addSubview(button)
        
        layout()
    }
    
    func layout() {
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(self).multipliedBy(0.5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.circleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        self.layer.insertSublayer(self.radiateLayer, at: 0)
        self.radiateLayer.position = CGPoint.init(x: self.width/2, y: self.height/2)
        self.radiateLayer.start()
    }
    
}
