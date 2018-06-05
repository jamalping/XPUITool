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
        return self.count
    }
    
    /// 提取字符串中的数字组成新的字符串
    var scannerNum: String {
        return self.filter { return Int(String($0)) != nil }
    }

    /// 删除两端空格
    var trimmingSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    subscript (i: Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            return String(self[startIndex])
        }
    }

    // 下标范围取值：eg: "12345"[1..<3] = "23"
    subscript (i : Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: i.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: i.upperBound)
            return String(self[startIndex ..< endIndex])
        }
    }
    
    // 用目标字符串替换range下标的字符串
    // var aa = "123456"
    // aa.replace(in: 1..<4, with: "*") 结果为：1*56
    mutating func replace(in range: Range<Int>, with astring: String) -> String {
        
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        return self.replacingCharacters(in: startIndex..<endIndex, with: astring)
    }

    
    /// 格式化金额
    func formatMoney() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        guard let floatValue = Float(self), var resultString = formatter.string(from: NSNumber.init(value: floatValue)) else {
            return nil
        }
        resultString.removeSubrange(resultString.startIndex ..< resultString.index(resultString.startIndex, offsetBy: 1))
        return resultString
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
        let classStringName = "_TtC\(appName.count)\(appName)"+"\(string.count)"+string

        return NSClassFromString(classStringName)
    }

    
    /// 匹配字符串在目标字符串的位置（可用于搜索标记）
    ///
    /// - Parameter string: 字符串
    /// - Returns: 字符串所在的位置
    func match(string: String) -> [NSRange] {
        var result = [NSRange?]()
        
        string.forEach { (aChar) in
            let temArray = self.enumerated().map({ (index,bChar) -> NSRange? in
                if aChar == bChar {
                    return NSMakeRange(index, 1)
                }
                return nil
            })
            result.append(contentsOf: temArray)
        }
        return result.filter{ return $0 != nil }.map{ return $0! }
    }
    
    /// 共用方法，传参数正则表达试
    public func isValidRegexString(regexString: String) ->Bool {
        do {
            let pattern = regexString
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            return matches.count > 0
            
        } catch {
            return false
        }
    }
    
    // 匹配数字递增或者递减。比如（123456、654321）
    func isIncreasOrdiminish() -> Bool {
        let regeXStr = "(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5})\\d"
        return self.isValidRegexString(regexString: regeXStr)
    }
    
    // 匹配6个数字是否相同
    func isSameString() -> Bool {
        let regeXStr = "([\\d])\\1{5,}" // 匹配6个数字相同
        return self.isValidRegexString(regexString: regeXStr)
    }
    // 匹配2233类型（比如2233、2222，333444）
    func is2233String() -> Bool {
        let regeXStr = "([\\d])\\1{1,}([\\d])\\2{1,}"
        return self.isValidRegexString(regexString: regeXStr)
    }
    
    // 是否是简单密码
    var isSimplePwd: Bool {
        if isIncreasOrdiminish() || isSameString() || is2233String() {
            return true
        }
        return false
    }
}

