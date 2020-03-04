//
//  SelectAgentView.swift
//  XPUIToolExample
//
//  Created by jamalping on 2020/3/2.
//  Copyright © 2020 worldunion. All rights reserved.
//

import UIKit

/// 选择经纪人列表
class SelectAgentV: BasePopView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(byRoundingCorners: [.topLeft, .topRight], radii: 10)
    }
    
}


//extension UIView {
//    /// 部分圆角
//    ///
//    /// - Parameters:
//    ///   - corners: 需要实现为圆角的角，可传入多个
//    ///   - radii: 圆角半径
//    /// eg: view.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: 50)
//    public func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
//
//        //创建贝塞尔,指定画圆角的地方为下方的左，右两个角添加阴影
//        let mask: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radii, height: radii))
//        let shape:CAShapeLayer = CAShapeLayer()
//        shape.fillColor = UIColor.gray.cgColor
//        //Layer的线为贝塞尔曲线
//        shape.path = mask.cgPath
//        shape.frame = self.bounds;
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = CGSize.init(width: 1, height: 2)
//        self.layer.shadowRadius = radii
//        self.layer.addSublayer(shape)
//    }
//}
