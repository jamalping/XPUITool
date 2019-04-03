//
//  GiftButton.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class GiftButton: UIView {
    
    /// 标题类型
    ///
    /// - title: 只有title
    /// - titleAndDescribe: title + describe
    /// - none: 没有标题
    enum TitiType {
        case title(title: String)
        case titleAndDescribe(title: String, describe: String)
        case none
    }
    
    lazy var titleLabel: UILabel = UILabel.init(text: "title", textColor: .white, font: UIFont.systemFont(ofSize: 16), textAlignment: .center, frame: .zero)
    
    lazy var desLabel: UILabel = UILabel.init(text: "destitle", textColor: .lightGray, font: UIFont.systemFont(ofSize: 15), textAlignment: .center, frame: .zero)
    
    lazy var imageView: UIImageView = UIImageView()
    
    var titleType: TitiType = .none {
        didSet {
            configTitleLabel(titleType: titleType)
        }
    }
    var imageName: String = ""

    
    /// 布局方式
    var isFrameLayout: Bool = true
    
    /// 图片的宽度、高度，可设置。不设置，则默认为GiftBtn的一半
    var imageWidthHeight: CGFloat? {
        didSet {
            guard let wh = imageWidthHeight else {
                return
            }
            if isFrameLayout {
                self.imageView.width = wh
                self.imageView.height = wh
            }else {
                self.imageView.snp.updateConstraints { (make) in
                    make.width.height.equalTo(wh)
                }
            }
        }
    }
    
    deinit {
        print("GiftButton deinit")
    }
    
    init(frame: CGRect = .zero, imageName: String, titleType: TitiType = .none) {
        super.init(frame: frame)
        if frame == .zero {
            isFrameLayout = false
        }
        self.imageName = imageName
        self.titleType = titleType
        
        configPage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configPage()
    }
    
    
    func configPage() {
        
        self.addSubview(imageView)
        imageView.image = UIImage.init(named: self.imageName)
        if isFrameLayout {
            imageView.width = self.width/2
            imageView.height = imageView.width
            imageView.top = 5
            imageView.centerX = self.width/2
        }else {
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.centerX.equalTo(self)
                if self.imageWidthHeight != nil {
                    make.width.height.equalTo(self.imageWidthHeight!)
                }else {
                    make.width.height.equalTo(self.snp.width).multipliedBy(0.5)
                }
            }
        }
        
        configTitleLabel(titleType: self.titleType)
    }
    
    func configTitleLabel(titleType: TitiType) {
        
        switch self.titleType {
        case .title(let title):
            titleLabel.text = title
            self.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(imageView.snp.bottom).offset(5)
            }
        case .titleAndDescribe(let title, let describe):
            titleLabel.text = title
            desLabel.text = describe
            self.addSubview(titleLabel)
            self.addSubview(desLabel)
            
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(imageView.snp.bottom).offset(5)
            }
            
            desLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(titleLabel.snp.bottom)
            }
        default: break
            
        }
    }
    
}

