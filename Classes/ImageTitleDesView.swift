//
//  ImageTitleDesView.swift
//  demo
//
//  Created by Apple on 2018/12/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

// MARK: - Icon + Title + describe + arrow
class ImageTitleDesView: UIView {
    
    let iconImgView: UIImageView = UIImageView()
    
    let titleLabel = UILabel.init(text: "title", textColor: .black, font: UIFont.systemFont(ofSize: 15))
    
    let aSwitch = UISwitch()
    
    let desLabel = UILabel.init(text: "describe", textColor: .lightGray, font: UIFont.systemFont(ofSize: 15))
    
    lazy var arrowView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "ic_arrow_smallgrey")
        return imgView
    }()
    
    /// 下划线
    lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        return view
    }()
    
    var isNeedUnderLine: Bool = false
    
    var isNeedArrow: Bool = true
    
    convenience init(frame: CGRect = .zero, icon: String, title: String, describ: String? = nil, isNeedUnderLine: Bool = false, isNeedArrow: Bool = true) {
        self.init(frame: frame)
        self.iconImgView.image = UIImage.init(named: icon)
        self.titleLabel.text = title
        self.desLabel.text = describ
        
        self.isNeedUnderLine = isNeedUnderLine
        self.isNeedArrow = isNeedArrow
        
        configPage()
    }
    
    func configPage() {
        addSubview(iconImgView)
        addSubview(titleLabel)
        addSubview(aSwitch)
        addSubview(desLabel)
        if self.isNeedArrow {
            addSubview(arrowView)
        }
        if self.isNeedUnderLine {
            addSubview(underLineView)
        }
        
        layout()
    }
    
    func layout() {
        iconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(12)
            make.centerY.equalTo(iconImgView)
        }
        
        aSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.centerY.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-15)
        }
        
        desLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(arrowView.snp.left).offset(-10)
        }
    }
    
}
