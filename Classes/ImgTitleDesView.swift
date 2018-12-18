//
//  ImgTitleDesView.swift
//  ThinkSNSPlus
//
//  Created by Apple on 2018/12/17.
//  Copyright © 2018年 ZhiYiCX. All rights reserved.
//

import UIKit

struct ImgTitleDesModel {
    var imageName: String?
    var title: String?
    var describe: String?
}
// MARK: - ImageView + title +describe(垂直方向排版)
class ImgTitleDesView: UIView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    var data: ImgTitleDesModel = ImgTitleDesModel() {
        didSet {
            print(data)
        }
    }
    
}
