//
//  TitleContentView.swift
//  XPUIToolExample
//
//  Created by xp on 2018/5/21.
//  Copyright © 2018年 worldunion. All rights reserved.
//


import UIKit
import XPUtil
import SnapKit

/// 对齐方式
///
/// - left_left: 都左对齐
/// - left_right: 一个左对齐，一个右对齐
enum AligmentType {
    case left_left
    case left_right
}

/// 标题 + 内容
class TitleContentView: UIView {
    
    /// 对齐方式
    var aligmentType: AligmentType = .left_right {
        didSet {
            layout()
        }
    }
    
    
    /// 标题
    var title: String? {
        didSet {
            titleLabal.text = title
            layout()
        }
    }
    
    /// 内容
    var content: String? {
        didSet {
            contentLabel.text = content
            layout()
        }
    }
    /// 标题
    let titleLabal = UILabel.init(
        text: "title", textColor: UIColor.init(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1),
        font: UIFont.systemFont(ofSize: 14))
    
    /// 内容
    let contentLabel = UILabel.init(text: "content", textColor: UIColor.init(red: 158/255.0, green: 163/255.0, blue: 166/255.0, alpha: 1), font: UIFont.systemFont(ofSize: 14), textAlignment: .right)
    
    convenience init(title: String, content: String?, aligmentType: AligmentType = .left_right) {
        self.init(frame: .zero)
        self.aligmentType = aligmentType
        
        titleLabal.text = title
        contentLabel.text = content
        
        configPage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configPage()
    }
    
    
    // MARK: ---- 布局
    func configPage() {
        addSubview(titleLabal)
        addSubview(contentLabel)
        
        layout()
    }
    
    func layout() {
        titleLabal.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self)
        }
        
        contentLabel.snp.removeConstraints()
        contentLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            if self.aligmentType == .left_left {
                make.left.equalTo(titleLabal.snp.right).offset(5)
            }else {
                make.right.equalTo(self)
            }
        }
        
    }
}

