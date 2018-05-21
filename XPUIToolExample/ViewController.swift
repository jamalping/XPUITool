//
//  ViewController.swift
//  XPUIToolExample
//
//  Created by xp on 2018/5/21.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contentLabel.title = "标题"
        contentLabel.content = "内容"
        contentLabel.aligmentType = .left_left
        
    }
    @IBOutlet weak var contentLabel: TitleContentView!
    
    @IBOutlet weak var tapAction: CountdownButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tapAction(_ sender: Any) {
        tapAction.tap()
    }
}

