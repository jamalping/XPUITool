//
//  TestVC2.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TestVC2: UIViewController {
    
    var giftList: GiftListView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        testGiftButton()
        
        testGiftListView()
    }
    
    func testGiftListView() {
        giftList = GiftListView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 300))
        
        giftList?.didSelected = {[weak self] (giftModel) in
            print("选中",giftModel)
        }
        
        var arr: [GiftModel] = [GiftModel]()
        for i in 0...20 {
            let model = GiftModel.init(title: "title" + "\(i)", describe: "describe", imageName: "testImg")
            arr.append(model)
        }
        giftList?.dataSource = arr
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        giftList?.show()
    }
    
    func testGiftButton() {
        let btn1 = GiftButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100), imageName: "testImg", titleType: .title("title"))
        btn1.imageWidthHeight = 50
    
        view.addSubview(btn1)
        
        let btn2 = GiftButton.init(frame: .zero, imageName: "testImg", titleType: .titleAndDescribe("title", "describe"))
    
        view.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.left.equalTo(0)
            make.top.equalTo(100)
        }
        
        let btn3 = GiftButton.init(frame: .zero, imageName: "testImg", titleType: .none)
        btn3.backgroundColor = .yellow
        view.addSubview(btn3)
        btn3.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.left.equalTo(200)
            make.top.equalTo(100)
        }
    }
}
