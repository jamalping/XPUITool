//
//  TestXPPickerView.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/17.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TestXPPickerViewVC: UIViewController {
    var pickerView: XPPickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pickerView = XPPickerView.init(.recentYear)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickerView?.show()
    }
    
}
