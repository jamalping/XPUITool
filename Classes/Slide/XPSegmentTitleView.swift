//
//  XPSegmentTitleView.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/11.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

/// 选中代理
@objc protocol XPSegmentTitleClickDelegate {
    func XPSegmentTitleSelectedIndex(index: Int)
}

/// 下划线类型
///
/// - equalButton: 等于按钮长度
/// - equalTitle: 等于文字长度
/// - custom: 自定义长度
/// - none: 没有下划线
enum UnderlineType {
    case equalButton
    case equalTitle
    case custom(width: CGFloat)
    case none
}

// MARK: - 滑动选择标题栏
class XPSegmentTitleView: UIView {
    
    var titles = [String]() {
        didSet{
            initSubViews()
        }
    }
    
    /// 下划线类型
    var underlineType: UnderlineType = .equalButton {
        didSet {
            configUnderLineView(underLineType: underlineType)
        }
    }
    
    /// 选中后的回调，与delegate任选其一
    var xpSegmentTitleClick: ((_ index: Int) -> ())?
    
    /// 选中后的代理，与上面的回调只会调用一个
    weak var delegate: XPSegmentTitleClickDelegate?
    
    /// 按钮默认tag
    fileprivate var defaultTag: Int = 10086
    
    /// 标题间距
    var itemMargin: CGFloat = 20
    /// 存档标题按钮的数组
    var btnArray = [XPTitleButton]()
    /// 选中时的颜色
    var selectColor: UIColor = .red {
        didSet {
            self.btnArray.forEach { (button) in
                button.setTitleColor(selectColor, for: .selected)
            }
            self.underLineView?.backgroundColor = selectColor
        }
    }
    /// 正常是的颜色
    var normalColor: UIColor = .black {
        didSet {
            self.btnArray.forEach { (button) in
                button.setTitleColor(normalColor, for: .normal)
            }
        }
    }
    
    /// 一般文字字体，可设置
    var titleNormalFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 选中文字字体，可设置
    lazy var titleSelectFont = self.titleNormalFont
    /// 当前选中
    fileprivate var selectedIndex: Int = 0
    
    /// 下划线
    lazy var underLineView: UIView? = UIView.init(backGroundColor: self.selectColor)
    
    /// 滚动视图
    fileprivate lazy var scrollView: UIScrollView = {
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
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        configUnderLineView(underLineType: self.underlineType)
    }
    
    
    /// 配置下划线视图
    ///
    /// - Parameter underLineType: <#underLineType description#>
    func configUnderLineView(underLineType: UnderlineType) {
        switch underlineType {
        case .none:
            self.underLineView = nil
        default:
            self.underLineView = UIView.init(backGroundColor: selectColor)
        }
        guard let underLine = self.underLineView else {
            return
        }
        self.scrollView.addSubview(underLine)
    }
    
    /// 初始化按钮
    func initSubViews() {
        self.btnArray.removeAll()
        self.titles.enumerated().forEach { (index, element) in

            let btn = XPTitleButton.init(title: element, titleNormalColor: self.normalColor, titleSelectColor: self.selectColor, titleFont: self.titleNormalFont)
            btn.tag = defaultTag + btnArray.count
            btn.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
            self.scrollView.addSubview(btn)
            self.btnArray.append(btn)
        }
    }
    
    /// 当加到父视图上，开始布局，并设置默认位置
    ///
    /// - Parameter newSuperview: <#newSuperview description#>
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        layoutScrollViewSubView()
        
        didSelectedIndex(selectIndex: self.selectedIndex)
    }
    
    
    /// 按钮点击事件
    ///
    /// - Parameter button: <#button description#>
    @objc func buttonClick(button: UIButton) {
        let index: Int = button.tag - defaultTag
        if index == self.selectedIndex || index < 0 || index > self.titles.count - 1 {
            return
        }
        
        didSelectedIndex(selectIndex: index)
    }
    
    
    /// 选中了某个位置
    ///
    /// - Parameter selectIndex: <#selectIndex description#>
    func didSelectedIndex(selectIndex: Int) {
        
        let lastBTn = self.btnArray[self.selectedIndex]
        lastBTn.titleLabel?.font = self.titleNormalFont
        lastBTn.isSelected = false
        let currentBtn  = self.btnArray[selectIndex]
        currentBtn.titleLabel?.font = self.titleSelectFont
        currentBtn.isSelected = true
        
        if self.xpSegmentTitleClick != nil {
            self.xpSegmentTitleClick?(selectIndex)
        }else {
            self.delegate?.XPSegmentTitleSelectedIndex(index: selectIndex)
        }
        underLineDidSelected(selected: selectIndex, animation: true)
        
        self.selectedIndex = selectIndex
    }
    
    
    /// 选中时，下划线布局
    ///
    /// - Parameters:
    ///   - index: 选中位置
    ///   - animation: 是否动画
    func underLineDidSelected(selected index: Int, animation: Bool) {
        guard let underline = self.underLineView else {
            return
        }
        UIView.animate(withDuration: animation ? 0.33 : 0) {
            
            let button = self.btnArray[index]
        
            switch self.underlineType {
            case .equalButton:
                underline.frame = CGRect.init(x: button.frame.minX, y: button.frame.height-2, width: button.frame.width, height: 2)
            case .equalTitle:
                underline.frame = CGRect.init(x: button.frame.minX + self.itemMargin/2, y: button.frame.height-2, width: button.frame.width - self.itemMargin, height: 2)
            case .custom(width: let width):
                underline.frame.size = CGSize.init(width: width, height: 2)
                underline.center = CGPoint.init(x: button.center.x, y: button.frame.height - 1)
            default: break
            }
            
        }
    }
    
    
    /// 显示选中的按钮,按钮可能被超出屏幕，当超出时，自动显示
    ///
    /// - Parameter index: <#index description#>
    func showSelectedBtn(selectedIndex: Int) {
        let button = self.btnArray[selectedIndex]
        print(button.left, button.right,self.scrollView.contentOffset.x,self.scrollView.width)
        if button.right > self.scrollView.contentOffset.x + self.scrollView.width {
            self.scrollView.setContentOffset(CGPoint.init(x: button.right - self.scrollView.width, y: 0), animated: true)
        }
        if button.left < self.scrollView.contentOffset.x {
            self.scrollView.setContentOffset(CGPoint.init(x: button.left, y: 0), animated: true)
        }
    }
    
    /// 获取文字宽度
    ///
    /// - Parameters:
    ///   - string: 文字
    ///   - font: 文字字体
    /// - Returns: 文字宽度
    func getWidthWithString(string: String, font: UIFont) -> CGFloat{
        let attr = [NSAttributedStringKey.font: font]
        return (string as NSString).boundingRect(with: CGSize.init(width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: attr, context: nil).size.width
    }
    
    /// 布局
    func layoutScrollViewSubView() {
        self.scrollView.frame = self.bounds
        if (self.btnArray.count == 0) {
            return
        }
        var totalBtnWidth: CGFloat = 0.0
        let btnHeight = self.bounds.height
        // 按钮布局
        self.btnArray.enumerated().forEach { (index, button) in
            let title = self.titles[index]
            
            let rTitleFont = button.isSelected ? titleSelectFont : self.titleNormalFont
            
            let btnWidth = self.getWidthWithString(string: title, font: rTitleFont) + self.itemMargin
            
            button.frame = CGRect.init(x: totalBtnWidth, y: 0, width: btnWidth, height: btnHeight)
            
            totalBtnWidth = totalBtnWidth + btnWidth
        }
        
        // 设置scrollView的contentSize
        if totalBtnWidth <= self.bounds.width { // 不能滑动
            self.scrollView.contentSize = self.bounds.size
        }else { // 超出屏幕，可以滑动
            self.scrollView.contentSize = CGSize.init(width: totalBtnWidth, height: btnHeight)
        }
        
        
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
