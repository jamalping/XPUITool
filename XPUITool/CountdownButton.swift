//
//  CountdownButton.swift
//  XPUIToolExample
//
//  Created by xp on 2018/5/21.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

/// 记录倒计时开始的时间
var countdown_time: TimeInterval = 0
/*
 Use: 初始化，在外面添加点击事件，点击事件调用tap方法，实现倒计时。
 */
// MARK: --- 倒计时按钮
class CountdownButton: UIButton {
    
    /// 按钮点击事件
//    var tapClick: ((UIButton)->Void)?
    
    /// 倒计时时间
    var countdownTime: TimeInterval = 60
    
    /// 是否需要倒计时，默认true
    var isCountDown = true
    
    /// 遮盖view
    lazy private var coverView: UIView = {
        let view = UIView.init(frame: self.bounds)
        view.backgroundColor = .clear
        return view
    }()
    
    /// 倒计时时间，是否需要倒计时
    convenience init(countdownTime: TimeInterval = 60, isCountdown: Bool = true) {
        self.init()
        self.isCountDown = isCountdown
        self.countdownTime = countdownTime
        commonSet()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSet()
    }
    
    /// 基本设置
    private func commonSet() {
        
        let title = NSLocalizedString("获取验证码", comment: "")
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.gray, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15)
    }

    /// 按钮点击后的倒计时
    func tap() {
        
        if isCountDown {
            resetCountdownTimeWith(start: isCountDown)
            countdownStatus()
        }
    }
    
    /// 处理倒计时状态
    @objc func countdownStatus() {
        let remainTime: Int = Int(getCountdowntime())
        if remainTime < 0 {
            self.setTitle("获取验证码", for: .normal)
            self.setTitleColor(UIColor.black, for: .normal)
            
            coverView.removeFromSuperview()
            return
        }
        self.setTitle("\(remainTime)S", for: .normal)
        
        if !self.subviews.contains(coverView) {
            self.addSubview(coverView)
        }
        self.perform(#selector(countdownStatus), with: nil, afterDelay: 1)
    }
    
    /// 获取倒计时剩余时间
    func getCountdowntime() -> TimeInterval {
        let now = NSDate().timeIntervalSince1970
        return countdownTime - (now - countdown_time)
    }
    
    /**
     是否进入倒计时
     
     - parameter start: true:进入倒计时，false：倒计时结束
     */
    private func resetCountdownTimeWith(start: Bool) {
        if start {
            countdown_time = NSDate().timeIntervalSince1970
        }else {
            countdown_time -= countdownTime
        }
    }
}
