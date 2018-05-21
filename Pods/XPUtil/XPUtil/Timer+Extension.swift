//
//  Timer+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/12.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import Foundation

extension Timer {
    
    /// MARK -- 暂停
    func pauseTimer() {
        if !self.isValid {
            return
        }
        self.fireDate = Date.distantFuture
    }
    
    /// MARK -- 重启
    func resumeTimer() {
        if !self.isValid {
            return
        }
        self.fireDate = Date()
    }
    
    /// MARK -- 隔一段时间启动
    func resumeTimerAfterInterval(_ interval:TimeInterval) {
        if !self.isValid {
            return
        }
        
        self.fireDate = Date.init(timeIntervalSinceNow: interval)
    }
    
}
