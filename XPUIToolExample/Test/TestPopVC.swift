//
//  TestPopVC.swift
//  XPUIToolExample
//
//  Created by jamalping on 2020/2/28.
//  Copyright © 2020 worldunion. All rights reserved.
//

import UIKit
/// 选择经纪人列表
//class SelectAgentView: BasePopView {
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.corner(byRoundingCorners: [.topLeft, .topRight], radii: 10)
//    }
//    
//}

class TestPopVC: UIViewController {
    var popVIew: SelectAgentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popVIew = SelectAgentView.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height-200, width: UIScreen.main.bounds.width, height: 200))
        popVIew!.backgroundColor = .white
        popVIew?.showType = .bottomToTop
        popVIew!.markView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hiddenPopVIew)))
        popVIew!.show()
    }
    
    @objc
    func hiddenPopVIew() {
        popVIew?.hidden()
    }
}





/// 选择经纪人列表
class SelectAgentView: BasePopView {
    
    lazy var tableView:UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .white
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellIdentfier)
//        tableview.register(UINib(nibName: "\(UITableViewCell.self)", bundle: nil),forCellReuseIdentifier: UITableViewCell.cellIdentfier)
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configPage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configPage() {
        tableView.frame = self.bounds
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(byRoundingCorners: [.topLeft, .topRight], radii: 10)
    }
}

extension SelectAgentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellIdentfier)
        cell?.textLabel?.text = String(indexPath.row)
        return cell!
    }
    
    
}


extension UIView {
    /// 圆形的裁剪
    ///
    /// - Parameters:
    ///   - corners: 方位
    ///   - radii: 圆角度数
    public func cornerRadius(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        //创建贝塞尔,指定画圆角的地方为下方的左，右两个角添加阴影
        let mask: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radii, height: radii))
        let shape:CAShapeLayer = CAShapeLayer()
        //Layer的线为贝塞尔曲线
        shape.path = mask.cgPath
        self.layer.mask = shape
    }
}

extension UITableViewCell: Cellidentfierable {}

extension UICollectionViewCell: Cellidentfierable{}

// MARK: - Cell标志协议
protocol Cellidentfierable {
    static var cellIdentfier: String { get }
}

extension Cellidentfierable where Self: UITableViewCell{
    static var cellIdentfier: String {
        return "\(self)"
    }
}

extension Cellidentfierable where Self: UICollectionViewCell{
    static var cellIdentfier: String {
        return "\(self)"
    }
}
