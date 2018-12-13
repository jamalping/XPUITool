//
//  TestVC1.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TestVC1: UIViewController {
    
    
    lazy var TCButton = TranslucentCircularButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), "videoClose")
    
    var titleTextFeild1 = TitleTextFeild.init(title: "title1", placeholder: "请填写内容", rightBtnType: .arrow, feildLeftMargin: 70, feildRightMargin: 70, feildtextAlignment: .left, feildResponseType: .write)
    
    var titleTextFeild2 = TitleTextFeild.init(title: "title2", placeholder: "弹出选择，进行选择。选择视图要自己实现", rightBtnType: .arrow, feildLeftMargin: 70, feildRightMargin: 70, feildtextAlignment: .left, feildResponseType: .click)
    
    var titleTextFeild3 = TitleTextFeild.init(title: "title3", placeholder: "这个不能点击", rightBtnType: .none, feildLeftMargin: 70, feildRightMargin: 70, feildtextAlignment: .left, feildResponseType: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        testTranslucentCircularButton()
        testTitleTextFeild()
    }
    
    func testTranslucentCircularButton() {
        self.view.addSubview(TCButton)
        TCButton.backgroundColor = .red
        TCButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(200)
            make.width.height.equalTo(50)
        }
    }
    
    func testTitleTextFeild() {
        self.view.addSubview(titleTextFeild1)
        self.view.addSubview(titleTextFeild2)
        self.view.addSubview(titleTextFeild3)
        
        titleTextFeild1.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.top.equalTo(300)
        }
        
        titleTextFeild2.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.top.equalTo(titleTextFeild1.snp.bottom)
        }
        
        titleTextFeild3.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.top.equalTo(titleTextFeild2.snp.bottom)
        }
    }
}
