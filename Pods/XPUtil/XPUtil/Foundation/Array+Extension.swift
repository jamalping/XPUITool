//
//  Array+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/11/2.
//  Copyright © 2017年 xyj. All rights reserved.
//

import Foundation

public extension Array {
    
    /// 随机一个元素
    public var random: Element? {
        get {
            guard count > 0 else { return nil }
            let index = Int(arc4random_uniform(UInt32(count)))
            return self[index]
        }
    }
    
    
}

extension Array where Element: Equatable {
    
    /// 判断数组中是否包含某个数组
    public func containArray(_ array: [Element]) -> Bool {
        var flag: Bool = true
        array.forEach { (element) in
            if !self.contains(element) {
                flag = false
            }
        }
        return flag
    }
    
    
    /// 找出不同于参数的元素的数组
    public func difference(_ values: [Element]...) -> [Element] {
        var result = [Element]()
        
        elements: for element in self {
            for value in values {
                if value.contains(element) {
                    continue elements
                }
            }
            result.append(element)
        }
        return result
    }
    
    
    /// 找出多个数组中共同的元素
    public func intersection(_ values: [Element]...) -> [Element] {
        var result = self
        var intersection = Array()
        
        for (i, value) in values.enumerated() {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if i > 0 {
                result = intersection
                intersection = Array()
            }
            
            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.forEach { (item: Element) -> Void in
                if result.contains(item) {
                    intersection.append(item)
                }
            }
        }
        return intersection
    }
    
    /// 将数组中不存在的元素加进来
    public func union(_ values: [Element]...) -> [Element] {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }
    
    /// 数组中相同的元素只保留一个
    public func unique() -> Array {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}
