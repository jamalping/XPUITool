//
//  XPSegmentTitleView.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/11.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

@objc protocol XPSegmentTitleClickDelegate {
    func XPSegmentTitleSelectedIndex(index: Int)
}

class XPSegmentTitleView: UIView {
    
    var titles = [String]() {
        didSet{
            initSubViews()
        }
    }
    
    var xpSegmentTitleClick: ((_ index: Int) -> ())?
    
    weak var delegate: XPSegmentTitleClickDelegate?
    
    var defaultTag: Int = 10086
    
    /// 标题间距
    var itemMargin: CGFloat = 20
    
    var btnArray = [XPTitleButton]()
    
    var selectColor: UIColor = .red
    
    var normalColor: UIColor = .black
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    lazy var titleSelectFont = self.titleFont
    
    var selectedIndex: Int = 0
    
    var isNeedUnderLine: Bool = true {
        didSet {
            underLineView.isHidden = isNeedUnderLine
        }
    }
    
    lazy var underLineView: UIView = UIView.init(backGroundColor: UIColor.blue)
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.delegate = self

        return scrollView
    }()
    
    
    init(frame: CGRect, titles: [String]? = nil) {
        if titles != nil {
            self.titles = titles!
        }
        
        super.init(frame: frame)
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
        self.addSubview(scrollView)
        scrollView.addSubview(underLineView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func initSubViews() {
        self.btnArray.removeAll()
        self.titles.enumerated().forEach { (index, element) in

            let btn = XPTitleButton.init(title: element, titleNormalColor: self.normalColor, titleSelectColor: self.selectColor, titleFont: self.titleFont)
            btn.tag = defaultTag + btnArray.count
            btn.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
            if (self.btnArray.count == self.selectedIndex) {
                btn.isSelected = true
            }
            self.scrollView.addSubview(btn)
            self.btnArray.append(btn)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc func buttonClick(button: UIButton) {
        let index: Int = button.tag - defaultTag
        if index == self.selectedIndex || index < 0 || index > self.titles.count - 1 {
            return
        }
        
        let lastBTn = self.btnArray[self.selectedIndex]
        lastBTn.isSelected = false
        let currentBtn  = self.btnArray[index]
        currentBtn.isSelected = true
        
        if self.xpSegmentTitleClick != nil {
            self.xpSegmentTitleClick?(index)
        }else {
            self.delegate?.XPSegmentTitleSelectedIndex(index: index)
        }
        self.selectedIndex = index
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func underLineViewMove(selected index: Int, animation: Bool) {
        
        UIView.animate(withDuration: animation ? 0.33 : 0) {
            
            let button = self.btnArray[index]
            
            self.underLineView.frame = CGRect.init(x: button.left, y: self.scrollView.height-2, width: button.width, height: 1)
        }
        
        showSelectedBtn(index: index)
    }
    
    
    /// 显示选中的按钮
    ///
    /// - Parameter index: <#index description#>
    func showSelectedBtn(index: Int) {
        let button = self.btnArray[index]
        print(button.left, button.right,self.scrollView.contentOffset.x,self.scrollView.width)
        if button.right > self.scrollView.contentOffset.x + self.scrollView.width {
            self.scrollView.setContentOffset(CGPoint.init(x: button.right - self.scrollView.width, y: 0), animated: true)
        }
        if button.left < self.scrollView.contentOffset.x {
            self.scrollView.setContentOffset(CGPoint.init(x: button.left, y: 0), animated: true)
        }
    }
    
    func getWidthWithString(string: String, font: UIFont) -> CGFloat{
        let attr = [NSAttributedStringKey.font: font]
        return (string as NSString).boundingRect(with: CGSize.init(width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: attr, context: nil).size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        if (self.btnArray.count == 0) {
            return
        }
        var totalBtnWidth: CGFloat = 0.0
        
        let btnHeight = self.bounds.height
        
        self.btnArray.enumerated().forEach { (index, button) in
            let title = self.titles[index]
            
            let rTitleFont = button.isSelected ? titleSelectFont : self.titleFont
            
            let btnWidth = self.getWidthWithString(string: title, font: rTitleFont) + self.itemMargin
            
            
            button.frame = CGRect.init(x: totalBtnWidth, y: 0, width: btnWidth, height: btnHeight)
            
            totalBtnWidth = totalBtnWidth + btnWidth
        }
        
        if totalBtnWidth <= self.bounds.width { // 不能滑动
            
            self.scrollView.contentSize = self.bounds.size
        }else { // 超出屏幕，可以滑动
            self.scrollView.contentSize = CGSize.init(width: totalBtnWidth, height: btnHeight)
        }
        underLineViewMove(selected: self.selectedIndex, animation: true)
    }
    
}


extension XPSegmentTitleView: UIScrollViewDelegate {
    
}

class XPTitleButton: UIButton {
    convenience init(title: String, titleNormalColor: UIColor, titleSelectColor: UIColor, titleFont: UIFont) {
        self.init(type: .custom)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleNormalColor, for: .normal)
        self.setTitleColor(titleSelectColor, for: .selected)
        self.titleLabel?.font = titleFont
    }
}
