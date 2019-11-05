//
//  ViewController.swift
//  XPUIToolExample
//
//  Created by xp on 2018/6/1.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

extension UIView {
    public func circleView(frame: CGRect? = nil) {
        print("yuan")
        let aFrame = frame ?? self.bounds
        let maskPath = UIBezierPath.init(roundedRect: aFrame, byRoundingCorners: .allCorners, cornerRadii: aFrame.size)
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 将View裁剪成圆形
    ///
    /// - Parameter radius: 数值
    public func radiusView(radius:CGFloat) {
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

class ViewController: UIViewController {

    enum TestType: String {
        case translucentCircularButton = "translucentCircularButton"
        case slid = "slid"
        case titleTextFeil = "titleTextFeil"
        case gift = "giftListView"
        case animation = "animation"
        case tiledLayer = "CATiledLayer加载大图"
        case xppickerView = "测试xppickerView"
        case xpOnlineBtn = "测试在线动画按钮"
        case xpRotantion = "旋转放大动画"
        case continousSendGif = "连续送礼物动画"
        case tapZan = "仿抖音点赞动画"
        case ringRing = "环形进度"
    }
    let datasource: [TestType] = [.translucentCircularButton, .slid, .titleTextFeil, .gift, .animation, .tiledLayer, .xppickerView, .xpOnlineBtn, .xpRotantion, .continousSendGif,.tapZan, .ringRing]
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let view = touch?.view
        let point = touch?.location(in: view)
        
        let pop = PopMenu.init(width: 100, rowHeight: 44, touchPoint: point!)
        pop.popData = [("","编辑"),("","删除"),("","取消")]
        pop.didSelectMenuBlock = { index in
            print(index)
        }
        pop.show()
    }

}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = self.datasource[indexPath.row].rawValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.datasource[indexPath.row] {
        case .translucentCircularButton:
            let vc = TestVC1()
            self.navigationController?.pushViewController(vc, animated: true)
        case .slid:
            let vc = XPSlideViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .titleTextFeil:
            let vc = TestVC1()
            self.navigationController?.pushViewController(vc, animated: true)
        case .gift:
            let vc = TestVC2()
            self.navigationController?.pushViewController(vc, animated: true)
        case .animation:
            let vc = TestAnimationVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .tiledLayer:
            let vc = TestTiledLayerVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .xppickerView:
            let vc = TestXPPickerViewVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .xpOnlineBtn:
            let vc = TestOnlineButtonVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .xpRotantion:
            let vc = TestRotationVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .continousSendGif:
            let vc = TestcontinueSendGifVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .tapZan:
            
            let vc = TestTapZanVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .ringRing:
            let vc = TestRingProgrssVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default: break
            
        }
    }
}

