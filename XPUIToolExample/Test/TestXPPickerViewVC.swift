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
        
        testITD()
    }
    
    func testITD() {
//        ImgTitleDesView
        guard let i = Bundle.main.loadNibNamed("ImgTitleDesView", owner: nil, options: nil)?.first as? ImgTitleDesView else {
            return
        }
        i.backgroundColor = .blue
        view.addSubview(i)
        i.snp.makeConstraints { (make) in
            make.left.top.equalTo(150)
            make.height.equalTo(154)
            make.width.equalTo(100)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickerView?.show()
    }
    
}
