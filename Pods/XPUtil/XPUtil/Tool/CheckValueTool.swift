//
//  CheckValueTool.swift
//  XPUtilExample
//
//  Created by xp on 2018/5/23.
//  Copyright © 2018年 xyj. All rights reserved.
//


import Foundation

public enum regeXStringType: String {
    case kAlphaNum = "[a-z0-9A-Z_]+"
    case kAlpha = "[a-zA-Z_]+"
    case kNumbers = "[0-9]+"
    case kNumbersPeriod = "[0-9.]+"
    case kNumbersheng = "[0-9-]+"
    case kNumberX = "[0-9xX]+"
}

/// 有效性校验
public struct CheckValueTool {
    /// 是否是有效的手机号
    public static func isValidatePhoneNumber(_ phoneNumber: String) -> Bool {
        
        let emailRegex = "^1+[0-9]+\\d{9}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with:phoneNumber)
    }
    /// 是否是有效的邮箱
    public static func isValidateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with:email)
    }
    
    /// 是否是有效的身份证
    public static func isValidateIDCard(_ idCard: String) -> Bool {
        let idCardRegex = "[0-9]{17}x"
        let idCardRegex1 = "[0-9]{15}"
        let idCardRegex2 = "[0-9]{18}"
        let idCardRegex3 = "[0-9]{17}X"
        let idCardTest = NSPredicate(format: "SELF MATCHES %@", idCardRegex)
        let idCardTest1 = NSPredicate(format: "SELF MATCHES %@", idCardRegex1)
        let idCardTest2 = NSPredicate(format: "SELF MATCHES %@", idCardRegex2)
        let idCardTest3 = NSPredicate(format: "SELF MATCHES %@", idCardRegex3)
        return idCardTest.evaluate(with:idCard) || idCardTest1.evaluate(with:idCard) || idCardTest2.evaluate(with:idCard) || idCardTest3.evaluate(with:idCard)
    }
    
    
    /// 是否是有效的港澳通行证
    public static func isValidateHongkong(_ hkNumber: String) -> Bool {
        let idCardRegex = "^[Hh]{1}([0-9]{10}|[0-9]{8})$"
        let idCardTest = NSPredicate(format: "SELF MATCHES %@", idCardRegex)
        return idCardTest.evaluate(with:hkNumber)
    }
    
    /// 是否是有效的港澳通行证
    public static func isValidateMacao(_ mcNumber: String) -> Bool {
        let idCardRegex = "^[Mm]{1}([0-9]{10}|[0-9]{8})$"
        let idCardTest = NSPredicate(format: "SELF MATCHES %@", idCardRegex)
        return idCardTest.evaluate(with:mcNumber)
    }
    
    /// 台湾
    public static func isValidateTaiwan(_ twNumber: String) -> Bool {
        let idCardRegex = "^[0-9]{10}|[0-9]{8}$"
        let idCardTest = NSPredicate(format: "SELF MATCHES %@", idCardRegex)
        return idCardTest.evaluate(with:twNumber)
    }
    
    /// 护照
    public static func isValidatePassport(_ passport: String) -> Bool {
        let idCardRegex = "[a-zA-Z\\d]{1,25}$"
        let idCardTest = NSPredicate(format: "SELF MATCHES %@", idCardRegex)
        return idCardTest.evaluate(with:passport)
    }
    
    /// 是否是有效的车牌号
    public static func isValidateCarNo(_ CarNo: String) -> Bool {
        let idCardRegex = "^[\\u4e00-\\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fa5]$"
        let idCardTest = NSPredicate(format: "SELF MATCHES %@", idCardRegex)
        return idCardTest.evaluate(with:CarNo)
    }
    
    /// 检测输入的有效性
    ///
    /// - Parameters:
    ///   - string: 输入的字符
    ///   - regeXStr: 正则表达式
    /// - Returns: 是否有效
    public static func isValueData(string: String,regeXType: regeXStringType) -> Bool {
        return self.isValueData(string: string, predicateString: regeXType.rawValue)
    }
    
    public static func isValueData(string: String,predicateString: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateString)
        return predicate.evaluate(with:string)
    }
    
}


