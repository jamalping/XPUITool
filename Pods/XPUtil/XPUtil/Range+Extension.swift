//
//  Range+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import Foundation

public extension Range {

    // 将Range转成NSRange：Range的Bund必须是String.Index
    var nsRange: NSRange? {
        guard let loc = self.lowerBound as? String.Index, let length: String.Index = self.upperBound as? String.Index else { return nil }
        return NSMakeRange(loc.encodedOffset, length.encodedOffset)
    }
    
    
}

