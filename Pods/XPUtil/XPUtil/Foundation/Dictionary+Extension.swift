//
//  Dictionary+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/11/2.
//  Copyright © 2017年 xyj. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    /// 获取一个随机值
    public func random() -> Value? {
        return Array(values).random
    }
    
    /// 是否存在该key
    public func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// 将不存在的键值对加进来。已存在的进行值得更新
    public func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (key, value) -> Void in
                result[key] = value
            }
        }
        return result
    }
    
    /// 
    public func difference(_ dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value as! _OptionalNilComparisonType {
                    result.removeValue(forKey: key)
                }
            }
        }
        return result
    }
    
    /// 转换字典键值对的类型
    public func map<K, V>(_ map: (Key, Value) -> (K, V)) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        }
        return mapped
    }
    
    
    /// 将JSONString转换成Dictionary
    public static func constructFromJSON (json: String) -> Dictionary? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,
                            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary {
            return data
        } else {
            return nil
        }
    }
    
    /// 转换成JSON
    public func formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
}
