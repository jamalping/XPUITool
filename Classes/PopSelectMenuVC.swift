//
//  PopSelectMenuVC.swift
//  XPUIToolExample
//
//  Created by midland on 2019/11/30.
//  Copyright © 2019 worldunion. All rights reserved.
//

import UIKit

class PopSelectMenu: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let view = touch?.view
        let point = touch?.location(in: view)
        
        let pop = PopMenu.init(width: 100, rowHeight: 44, touchPoint: point!)
        pop.popData = [("","编辑"),("","删除"),("","取消")]
        pop.didSelectMenuBlock = { index in
            print(index)
        }
        pop.show()
    }
    
}
