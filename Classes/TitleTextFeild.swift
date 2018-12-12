//
//  TitleTextFeild.swift
//  demo
//
//  Created by Apple on 2018/12/10.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit


/// 右边按钮类型
///
/// - arrow: <#arrow description#>
/// - none: <#none description#>
/// - ather: <#ather description#>
enum RightBtnType {
    case arrow
    case none
    case ather
}


/// TextFeild响应类型
///
/// - write: 弹键盘
/// - click: 点击，弹其他视图
/// - none:
enum TextFeildResponseType {
    case write
    case click
    case none
}

// MARK: - Title+TextFeild+rightBtn
class TitleTextFeild: UIView {
    
    let titleLabel = UILabel.init(text: "title", textColor: .black, font: UIFont.systemFont(ofSize: 15))
    
    lazy var textFeild: UITextField = {
        let textFeild = UITextField()
        textFeild.font = UIFont.systemFont(ofSize: 15)
        return textFeild
    }()
    ///
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
    var rightBtnType: RightBtnType = .arrow
    
    var feildLeftMargin: CGFloat = 0
    
    var feildRightMargin: CGFloat = 0
    
    var feildResponseType: TextFeildResponseType = .write
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - title: title
    ///   - placeholder: textFeild.placeholder
    ///   - rightBtnType: 右边按钮类型
    ///   - feildLeftMargin: textFeild距离最左边的间距
    ///   - feildRightMargin: textFeild距离最右边的间距
    ///   - feildtextAlignment: textFeild对齐方式
    ///   - feildResponseType: textFeild响应方式
    convenience init(title: String?, placeholder: String?,rightBtnType: RightBtnType = .arrow, feildLeftMargin: CGFloat = 100, feildRightMargin: CGFloat = 0, feildtextAlignment: NSTextAlignment = .left,  feildResponseType: TextFeildResponseType = .write) {
        self.init(frame: .zero)
        
        self.titleLabel.text = title
        self.textFeild.placeholder = placeholder
        textFeild.delegate = self
        self.textFeild.textAlignment = feildtextAlignment
        self.feildLeftMargin = feildLeftMargin
        self.feildRightMargin = feildRightMargin
        
        self.feildResponseType = feildResponseType
        self.rightBtnType = rightBtnType
        
        configPage()
    }
    
    func configPage() {
        self.addSubview(titleLabel)
        self.addSubview(textFeild)
        self.addSubview(underLineView)
        switch self.rightBtnType {
        case .arrow:
            self.addSubview(arrowView)
        default: break
        }
        if self.feildResponseType == .click {
//            let data = PickerData.init(data: [ColumnPickerData.init(key: "workID", value: "jamal", data: nil),
//                                              ColumnPickerData.init(key: "workID", value: "lixp", data: nil),
//                                              ColumnPickerData.init(key: "workID", value: "lixiaoping", data: nil),
//                                              ColumnPickerData.init(key: "workID", value: "jamalping", data: nil)])
//            let pickView = XPPickerView.init()
//            pickView.data = data
//
//            self.textFeild.inputView = pickView
            let aView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
            aView.backgroundColor = .red
            self.textFeild.inputView = aView
        }
        
        layout()
    }
    
    func layout() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.top.equalTo(self)
        }
        
        textFeild.snp.makeConstraints { (make) in
            make.left.equalTo(self.feildLeftMargin)
            make.bottom.top.equalTo(self)
            make.right.equalTo(-self.feildRightMargin)
        }
        
        switch self.rightBtnType {
        case .arrow:
            arrowView.snp.makeConstraints { (make) in
                make.right.equalTo(-10)
                make.centerY.equalTo(self)
            }
        default: break
            
        }
        
        underLineView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}

extension TitleTextFeild: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch self.feildResponseType {
        case .none:
            return false
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch self.feildResponseType {
        case .write:
            return true
        default:
            return false
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        switch self.feildResponseType {
        case .click:
            print("点击")
        default:
            print("弹键盘")
        }
    }
}
