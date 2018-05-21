//
//  String+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import Foundation

public extension String {

    /// 长度
    var length: Int {
        return self.characters.count
    }

    /// 删除两端空格
    var trimmingSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    // 下标范围取值：eg: "12345"[1..<3] = "23"
    subscript (i : Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: i.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: i.upperBound)
            return String(self[startIndex ..< endIndex])
        }
    }

    /// MD5加密
    ///
    /// - Returns: 加密后的字符串
//    func md5() -> String{
//        let cStr = self.cString(using: String.Encoding.utf8);
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
//        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
//        let md5String = NSMutableString();
//        for i in 0 ..< 16{
//            md5String.appendFormat("%02x", buffer[i])
//        }
//        free(buffer)
//
//        return md5String as String
//    }

    /// 每隔一段插入一个字符
    ///
    /// - Parameters:
    ///   - string: 插入的字符串
    ///   - len: 每隔几位
    /// - Returns: 插入后的字符串
    func insert(string: String, len: Int) -> String {
        if self.length < 1 { return self }
        var resultString = ""
        var index = 0
        while  index < self.length {
            if index + len >= self.length {
                resultString += self[index..<self.length]
                break
            }
            let news = self[index..<index+len]
            resultString = resultString + news + string
            index += len
        }
        return resultString
    }

    /// 使用正则表达式替换
    ///
    /// - Parameters:
    ///   - pattern: 正则
    ///   - with: <#with description#>
    ///   - options: <#options description#>
    /// - Returns: <#return value description#>
    /// - eg:pregReplace(pattern: "[A-Z]", with: "_$0")  大写转小写，并前面添加一个_
    func regexReplace(pattern: String, with: String,
                      options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.length),
                                              withTemplate: with)
    }

    /// 获取字符串子串
    ///
    /// - Parameter index: 切割的初始位置
    /// - Returns: 子串
    func subString(from index: Int) -> String {
        if index <= self.length {
            return String(self[index..<self.length])
        }
        return self
    }

    /// 获取字符串子串
    ///
    /// - Parameter index: 切割的最终位置
    /// - Returns: 子串
    func subString(to index: Int) -> String {
        if index <= self.length {
            return String(self[0..<index])
        }
        return self
    }

    /// 根据字符串生成Swift的类
    ///
    /// - Parameter string: 类名的字符串
    /// - Returns: Swift类
    static func swiftClassFromString(string: String) -> AnyClass? {

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let classStringName = "_TtC\(appName.characters.count)\(appName)"+"\(string.characters.count)"+string

        return NSClassFromString(classStringName)
    }

//    public func underline() -> NSAttributedString {
//        let underlineString = NSAttributedString(string: self, attributes:[NSAttributedStringKey.underlineStyle: NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue)])
//        return underlineString
//    }
}

