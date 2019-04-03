//
//  AnimationVC1.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/28.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit
import XPUtil

class AnimationVC1: UIViewController {
    
    lazy var button: RadiateButton = {
        let view = RadiateButton.init(frame: CGRect.init(x: 100, y: 100, width: 65, height: 65))
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        button.size = CGSize.init(width: 300, height: 300)
//        button.center = view.center
        
        button.backgroundColor = .cyan
        view.addSubview(button)
        button.startAnimation()
    }
}
