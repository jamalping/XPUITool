//
//  XYJPickView.swift
//  HslApp
//
//  Created by xyj on 2018/1/17.
//  Copyright © 2017年 XYJ. All rights reserved.
//

import UIKit
//import RxSwift

// MARK: pickView弹框类型
enum XYJPickViewType {
    case none // 自己给数据源值
    case cityThirdPicker // 三级地址
    case cityTwoPicker // 二级
    case bank // 银行
    case bussiness // 联系人关系
    case recentYear   // 最近12个月[[[年：[月：月]]]]
}

/// pickerView数据源
struct PickerData {
    
    /// 每一列的数据源
    var data: [ColumnPickerData]?
    
    /// pickerView有多少列：（最多支持三列，少于三列随意）
    func getNumberOfComponent() -> Int {
        var numbers = 0
        guard let datas = self.data, datas.count > 0 else {
            return numbers
        }
        numbers += 1
        var secondeColumn = false
        var thirdColumn = false
        datas.forEach { (columnPickerData) in
            if columnPickerData.data?.count ?? 0 > 0 {
                secondeColumn = true
                columnPickerData.data?.forEach({ (cpData) in
                    if cpData.data?.count ?? 0 > 0 {
                        thirdColumn = true
                    }
                })
            }
        }
        if secondeColumn {
            numbers += 1
        }
        if thirdColumn {
            numbers += 1
        }
        
        return numbers
    }
}

/// pickerView每一列的数据模型
struct ColumnPickerData {
    
    /// 隐藏的值：比如id
    var key: String?
    
    /// 要显示出来的值
    var value: String?
    
    /// 下一列的数据源
    var data: [ColumnPickerData]?
}

@objcMembers
class XPPickerView: UIView {
    
    let kWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first!
    
    /// 是否已经显示
    var isShowing: Bool = false
//    var keyValueResult = Variable<([String],[String])>(([""],[""]))
    // 选中的数据
    var keyValueResult = ([""],[""])
    
    // MARK: pickview的数据源
    fileprivate var numberOfComponent: (() -> Int)?
    fileprivate var numberOfRowsInComponent: ((_ pickerView: UIPickerView,_ component: Int) -> Int)?
    fileprivate var textOfSelectRow: ((_ pickerView: UIPickerView,_ row: Int, _ component: Int) -> String)?
    fileprivate var getTextSelectRow: ((_ pickerView: UIPickerView) -> ([String], [String]))?
    
    // MARK: pickview的代理方法
    var didSelectRow:((_ pickerView: UIPickerView,_ row: Int,_ component: Int) -> (Int, Int))?
    
    /// 选择框的高度
    fileprivate let pickViewH:CGFloat = 200
    /// 选择框的行高
    fileprivate let pickViewCellH:CGFloat = 49
    /// 工具条的高度
    private let toolBarHeight:CGFloat = 44
    
    /// 屏幕高度
    let screenH:CGFloat = UIScreen.main.bounds.height
    /// 屏幕宽度
    let screenW:CGFloat = UIScreen.main.bounds.width
    
    var pickerViewType: XYJPickViewType = .bank {
        didSet {
            getArrByType(pickerViewType)
        }
    }
    
    /// 记录滚动的位置:[component: row]每一列，对应的行
    var selectedCompanRow = [Int: Int]()
    
    /// 组装格式
    var data: PickerData? {
        didSet {
            /// 设置数据源
            self.numberOfComponent = {
                return (self.data?.getNumberOfComponent())!
            }
            
            self.numberOfRowsInComponent = { picker,component -> Int in
                let numberComponent = self.data?.getNumberOfComponent() ?? 0
                // 根据选中的那一列加载对应的下一列的数据
                switch (numberComponent, component) {
                case (1, 0),(2, 0),(3, 0):
                    return self.data?.data?.count ?? 0
                case (2, 1), (3, 1):
                    let selectedRow = picker.selectedRow(inComponent: 0)
                    return self.data?.data?[selectedRow].data?.count ?? 0
                case (3, 2):
                    let selectedRow1 = picker.selectedRow(inComponent: 0)
                    let selectedRow2 = picker.selectedRow(inComponent: 1)
                    return self.data?.data?[selectedRow1].data?[selectedRow2].data?.count ?? 0
                default: return 0
                }
            }
            
            self.textOfSelectRow = {picker ,row, component -> String in
                
                switch component {
                case 0:
                    return self.data?.data?[row].value ?? ""
                case 1:
                    
                    // 第一列选中的行
                    let oldSelectedRow1 = self.selectedCompanRow[0] ?? 0
                    
                    if (self.data?.data?[oldSelectedRow1].data?.count)! <= row {
                        let oldSelected2Row = self.selectedCompanRow[1] ?? 0
                        return self.data?.data?[oldSelectedRow1].data?.last?.value ?? ""
                    }else {
                        
                        return self.data?.data?[oldSelectedRow1].data?[row].value ?? ""
                    }
                    
                case 2:
                    let selectedRow1 = picker.selectedRow(inComponent: 0)
                    let selectedRow2 = self.selectedCompanRow[1] ?? 0
                    return self.data?.data?[selectedRow1].data?[selectedRow2].data?[row].value ?? ""
                    
                default:
                    return ""
                }
            }
            
            self.getTextSelectRow = { pickerView -> ([String],[String]) in
                let numberComponent = self.data?.getNumberOfComponent() ?? 0
                switch numberComponent {
                case 1:
                    let selectedRow1 = pickerView.selectedRow(inComponent: 0)
                    let component1Data = self.data?.data?[selectedRow1]
                    
                    let key = component1Data?.key ?? ""
                    let value = component1Data?.value ?? ""
                    self.selectedCompanRow[0] = selectedRow1
                    
                    return ([key], [value])
                case 2:
                    let selectedRow1 = pickerView.selectedRow(inComponent: 0)
                    var selectedRow2 = pickerView.selectedRow(inComponent: 1)
                    
                    let component1Data = self.data?.data?[selectedRow1]
                    
                    if (component1Data?.data?.count)! <= selectedRow2 {
                        selectedRow2 = 0
                    }
                    let component2Data = component1Data?.data?[selectedRow2]
                    let key1 = component1Data?.key ?? ""
                    let value1 = component1Data?.value ?? ""
                    let key2 = component2Data?.key ?? ""
                    let value2 = component2Data?.value ?? ""
                    
                    self.selectedCompanRow[0] = selectedRow1
                    self.selectedCompanRow[1] = selectedRow2
                    return ([key1, key2], [value1, value2])
                case 3:
                    let selectedRow1 = pickerView.selectedRow(inComponent: 0)
                    var selectedRow2 = pickerView.selectedRow(inComponent: 1)
                    var selectedRow3 = pickerView.selectedRow(inComponent: 2)
                    
                    let component1Data = self.data?.data?[selectedRow1]
                    if (component1Data?.data?.count)! <= selectedRow2 {
                        selectedRow2 = 0
                    }
                    let component2Data = component1Data?.data?[selectedRow2]
                    if (component2Data?.data?.count)! <= selectedRow3 {
                        selectedRow3 = 0
                    }
                    let component3Data = component2Data?.data?[selectedRow3]
                    
                    let value1 = component1Data?.value ?? ""
                    let value2 = component2Data?.value ?? ""
                    let value3 = component3Data?.value ?? ""
                    let key1 = component1Data?.key ?? ""
                    let key2 = component2Data?.key ?? ""
                    let key3 = component3Data?.key ?? ""
                    
                    self.selectedCompanRow[0] = selectedRow1
                    self.selectedCompanRow[1] = selectedRow2
                    self.selectedCompanRow[2] = selectedRow3
                    return ([key1, key2, key3], [value1, value2, value3])
                    
                default:
                    return ([""],[""])
                }
                
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: screenH-(pickViewH+toolBarHeight), width: screenW, height: pickViewH+toolBarHeight))
        
        self.backgroundColor = .white
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        configePage()
        
        bind()
        
    }
    
    convenience init(_ pickViewType: XYJPickViewType) {
        self.init()
        
        getArrByType(pickViewType)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configePage() {
        addSubview(pickerView)
        addSubview(toolView)
        
        layout()
    }
    
    func layout() {
        
        toolView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: toolBarHeight)
        
        pickerView.frame = CGRect.init(x: 0, y: toolBarHeight, width: self.frame.width, height: pickViewH)
        
//        toolView.snp.makeConstraints { (make) in
//            make.top.left.right.equalTo(zero)
//            make.height.equalTo(toolBarHeight)
//        }
//
//        pickerView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalTo(zero)
//            make.top.equalTo(toolBarHeight)
//        }
//        self.setNeedsLayout()
    }
    
    func bind() {
        // 确定按钮点击绑定一个输出值
        let button = self.toolView.sureItem.acceptBtn(title: "确定")!
        button.addTarget(self, action: #selector(sureDone), for: .touchUpInside)
        self.toolView.allItem.acceptBtn(title: "清除")!.addTarget(self, action: #selector(clear), for: .touchUpInside)
        self.toolView.cancelItem.acceptBtn(title: "取消")!.addTarget(self, action: #selector(cancle), for: .touchUpInside)
        
//        self.toolView.sureItem.acceptBtn(title: "确定")?.rx.tap.asObservable().map({ (_) -> ([String], [String]) in
//            self.hidden()
//            return ((self.getTextSelectRow?(self.pickerView)))!
//        }).bind(to: self.keyValueResult).disposed(by: self.disposeBag)
//
//        self.toolView.allItem.acceptBtn(title: "清除")?.rx.tap.asObservable()
//            .map{
//                self.hidden()
//                return (["全部"],[""])
//            }.bind(to: self.keyValueResult).disposed(by: self.disposeBag)
//
//        toolView.cancelItem.acceptBtn(title: "取消")?.rx.tap.asObservable().subscribe(onNext: { () in
//            self.hidden()
//        }).disposed(by: self.disposeBag)
    }
    
    @objc func sureDone() -> Void {
        self.hidden()
        
        // 回调
        self.keyValueResult =  self.getTextSelectRow!(self.pickerView)
    }
    
    @objc func clear() -> Void {
        print("点击了清除")
        self.hidden()
        self.keyValueResult =  (["全部"],[""])
    }
    
    @objc func cancle() -> Void {
        print("点击了取消")
        self.hidden()
    }
    
    func show() {
        
        if isShowing {
            return
        }
        
        markView.addSubview(self)
        kWindow.addSubview(markView)
        
        // 根据上次选中的数据加载pickerView
        let number = self.data?.getNumberOfComponent() ?? 0
        for i in 0 ..< number {
            self.pickerView.reloadComponent(i)
            self.pickerView.selectRow(self.selectedCompanRow[i] ?? 0, inComponent: i, animated: true)
        }
        UIView.animate(withDuration: 0.33) {
            self.markView.frame.origin.y = 0
        }
        
        isShowing = true
    }
    
    func hidden() {
        
        if !isShowing {
            return
        }
        UIView.animate(withDuration: 0.33, animations: {
            self.markView.frame.origin.y = self.screenH
        }) { (_) in
            self.markView.subviews.map{ $0.removeFromSuperview() }
            self.markView.removeFromSuperview()
        }
        
        isShowing = false
    }
    
    /// 工具条
    lazy var toolView:XPBasePickToolBarView = {
        let view = XPBasePickToolBarView()
        _ = view.initWithCustomerTool()
        return view
    }()
    
    let pickerView:UIPickerView = UIPickerView.init()
    
    lazy var markView: UIView = {
        let view = UIView.init(frame: self.kWindow.bounds)
        view.backgroundColor =  UIColor.white
        //UIColor.init(white: 0.5, alpha: 0.5)
        view.frame.origin.y = UIScreen.main.bounds.minY
        //        view.addTapGes(target: self, action: #selector(hidden))
        return view
    }()
    
    // MARK: 根据pickviewtype的类型获取数据
    func getArrByType(_ pickViewType: XYJPickViewType) {
        
//        let shareBaseConfig = XYJPickerViewBaseConfig.shareBaseConfig
        
        if pickViewType == .recentYear {
            data = PickerData.init(data: [ColumnPickerData.init(key: "workID", value: "jamal", data: nil),
                                   ColumnPickerData.init(key: "workID", value: "lixp", data: nil),
                                   ColumnPickerData.init(key: "workID", value: "lixiaoping", data: nil),
                                   ColumnPickerData.init(key: "workID", value: "jamalping", data: nil)])
            toolView.items?.remove(at: 3)
            toolView.items?.insert(toolView.allItem, at: 3)
        } else if pickViewType == .bussiness {
            data = PickerData.init(data: [ColumnPickerData.init(key: "workID", value: "jamal", data: nil),
                                          ColumnPickerData.init(key: "workID", value: "lixp", data: nil),
                                          ColumnPickerData.init(key: "workID", value: "lixiaoping", data: nil),
                                          ColumnPickerData.init(key: "workID", value: "jamalping", data: nil)])
        } else if pickViewType == .cityTwoPicker {
            data = PickerData.init(data:
                [ColumnPickerData.init(key: "workID", value: "jamal", data: [
                    ColumnPickerData.init(key: "workID", value: "jamal", data: nil),
                    ColumnPickerData.init(key: "workID", value: "jamal", data: nil),
                    ColumnPickerData.init(key: "workID", value: "jamal", data: nil)]),
                 ColumnPickerData.init(key: "workID", value: "lixp", data: [
                    ColumnPickerData.init(key: "workID", value: "lixp", data: nil),
                    ColumnPickerData.init(key: "workID", value: "lixp", data: nil),
                    ColumnPickerData.init(key: "workID", value: "lixp", data: nil)]),
                 ColumnPickerData.init(key: "workID", value: "lixiaoping", data: [
                    ColumnPickerData.init(key: "workID", value: "lixiaoping", data: nil),
                    ColumnPickerData.init(key: "workID", value: "lixiaoping", data: nil),
                    ColumnPickerData.init(key: "workID", value: "lixiaoping", data: nil)]),
                 ColumnPickerData.init(key: "workID", value: "jamalping", data: [
                    ColumnPickerData.init(key: "workID", value: "jamalping", data: nil),
                    ColumnPickerData.init(key: "workID", value: "jamalping", data: nil),
                    ColumnPickerData.init(key: "workID", value: "jamalping", data: nil)])])
        }
        
        // 设置默认选中每一列的第一行
        let numberComponent = self.data?.getNumberOfComponent() ?? 0
        for i in 0 ..< numberComponent {
            selectedCompanRow[i] = 0
        }
    }
}

extension XPPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: 实现UIPickerViewDataSource的方法
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponent != nil ? numberOfComponent!() : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRowsInComponent != nil ? numberOfRowsInComponent!(pickerView,component) : 0
        
    }
    
    // MARK: 实现UIPickerViewDelegate的方法
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickViewCellH
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerView.subviews[1].backgroundColor = UIColor.init(white: 0.66, alpha: 0.5)
        pickerView.subviews[2].backgroundColor = UIColor.init(white: 0.66, alpha: 0.5)
        let lab = UILabel()
        lab.text = textOfSelectRow != nil ? textOfSelectRow!(pickerView,row,component) : ""
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.frame = CGRect(x: 0, y: 0, width: screenW, height: pickViewCellH)
        lab.frame = CGRect(x: 0, y: 0, width: screenW, height: pickViewCellH)
        lab.textAlignment = NSTextAlignment.center
        
        return lab
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("选中的列、行",component ,row)
        let numberComponent = self.data?.getNumberOfComponent() ?? 0
        selectedCompanRow = [component: row]
        switch (numberComponent, component) {
        case (2, 0):
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        case (3, 0):
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case (3, 1):
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        default: break
        }
    }
}

// MARK: PickerToolBar
@objcMembers
class XPBasePickToolBarView: UIToolbar {
    func initWithCustomerTool() -> UIToolbar {
        self.barTintColor = UIColor.white
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let  spaceItem1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)   //左边空格
        spaceItem1.width = 15
        let  spaceItem2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem2.width = 15
        self.items = [spaceItem1,cancelItem,spaceItem,spaceItem,spaceItem,sureItem,spaceItem2]
        self.backgroundColor = UIColor.black
        return self
    }
    
    func cancelDone() {}
    
    func sureDone() {
        print("点击确定")
    }
    
    func allDone() {}
    
    // 有的有清除按钮
    lazy var allItem: UIBarButtonItem = {
        return self.initWithToolBar(title: "清除", titleColor: .darkGray, nil, action: #selector(allDone))
    }()
    
    lazy var cancelItem: UIBarButtonItem = {
        return self.initWithToolBar(title: "取消", titleColor: .darkGray, nil, action: #selector(cancelDone))
    }()
    
    lazy var sureItem: UIBarButtonItem = {
        return self.initWithToolBar(title: "确定", titleColor: .red, nil, action: #selector(sureDone))
    }()
    
    func initWithToolBar(title:String,titleColor:UIColor ,_ target: AnyObject?, action: Selector?) -> UIBarButtonItem {
        
        let btn:UIButton = UIButton.init(type: .custom)
        
        btn.frame =  CGRect(x: 0, y: 0, width: 42, height: 44)
        
        btn.setTitle(title, for: .normal)
        
        btn.setTitleColor(titleColor, for: .normal)
        if target != nil && action != nil {
            btn.addTarget(target!, action: action!, for: .touchUpInside)
        }
        
        return UIBarButtonItem.init(customView: btn)
        
    }
}


extension UIBarButtonItem {
    public func acceptBtn() -> UIButton {
        for view in (self.customView?.subviews) ?? [] {
            if let btnView = view as? UIButton {
                return btnView
            } else {
                continue
            }
        }
        return UIButton()
    }
    
    public func acceptBtn(title: String) -> UIButton? {
        let btn = self.customView as! UIButton
        if btn.title(for: .normal) == title {
            return btn
        }
        return nil
    }
}

