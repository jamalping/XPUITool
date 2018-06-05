//
//  ContactsManager.swift
//  XPUtilExample
//
//  Created by xp on 2018/5/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

import UIKit
import CoreData

import Contacts
import ContactsUI

@available(iOS 9.0, *)
public class Contact {
    // MARK: - 属性列表
    /// 姓名
    var name: String
    /// 电话号码列表
    var phoneNumbers: [String]
    
    /// 数据字典
    var dic: [String: Any] {
        return ["name": name, "phoneNumber": phoneNumbers]
    }
    
    /// 格式化输出
    var description: String {
        return "name: \(name), phoneNumber: \(phoneNumbers)"
    }
    
    //  MARK: - 构造器
    
    /// 构造器
    ///
    /// - Parameters:
    ///   - name: 联系人姓名
    ///   - phoneNumber: 联系人电话号码列表
    init(name: String, phoneNumbers: [String]) {
        self.name = name
        self.phoneNumbers = phoneNumbers
    }
}

//  MARK: - 枚举

/// 系统通讯录的权限授予状态
///
/// - deniedOrRestricted: 访问被限制或拒绝
/// - authorized: 成功授权
/// - notDeterMined: 从未发起过授权请求
fileprivate enum ContactsAuthorizationStatus: Int {
    case deniedOrRestricted = 1
    case authorized
    case notDeterMined
}

/// 异常
///
/// - authorizeFailed: 授权失败
public enum ContactsToolError: Error {
    case authorizeFailed
}

//  MARK: - 类

/// 联系人工具类
@available(iOS 9.0, *)
public class ContactsManager: NSObject, CNContactPickerDelegate, UINavigationControllerDelegate  {
    public typealias ContactOnSuccess = (_ location: Contact) -> ()
    public typealias ContactOnCancle = (_ errorCode: String) -> ()
    
    //  MARK: - 构建单例
    /// 单例
    private static let shareInstance: ContactsManager = ContactsManager.init()
    //  封闭常规创建方法
    private override init() {}
    
    /// 获取单例
    ///
    /// - Returns: 单例
    class func shareContactsTool() -> ContactsManager {
        return shareInstance
    }
    
    /// 联系人个数
    var contactCount: Int?
    {
        do {
            return try contactStore.containers(matching: nil).count
        } catch {
            print(error)
        }
        return nil
    }
    
    //  MARK: - 构建属性
    
    /// 系统通讯录获取工具
    /// 系统通讯录获取工具
    @available(iOS 9.0, *)
    private lazy var contactStore: CNContactStore = CNContactStore.init()
    
    private var error: Unmanaged<CFError>?
    
    /// 当前页面所属的控制器
    private lazy var viewController: UIViewController? = {
        let currentView: UIView? = UIApplication.shared.keyWindow?.subviews[0]
        let responder = currentView?.next
        if (responder?.isKind(of: UIViewController.classForCoder()))! {
            return responder as? UIViewController
        }
        
        return nil
    }()
    
    /// 通讯录联系人数据
    private var originalContactsData: [Contact] = []
    
    /// 使用系统自带界面获取联系人成功的回调
    private var getContactOnSuccess: ContactOnSuccess?
    /// 使用系统自带界面获取联系人取消的回调
    private var getContactOnCancle: ContactOnCancle?
    
    /// 弹出通讯录
    ///
    /// - Parameters:
    ///   - down_address_book: 是否获取用户所有通讯录
    ///   - didSelect: 点击哪一行的回调
    public func clickgContactsBtn(onSuccess: @escaping ContactOnSuccess, onCancle: @escaping ContactOnCancle) {
        self.getContactOnSuccess = onSuccess
        self.getContactOnCancle = onCancle
        
        let nav = UINavigationBar.appearance()
        nav.setBackgroundImage(UIImage.init(), for: .default)
        nav.isTranslucent = false
        
        UIApplication.shared.statusBarStyle = .default
        
        let authorStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        let peoplePicker = CNContactPickerViewController()
        
        peoplePicker.delegate = self
        
        peoplePicker.predicateForSelectionOfContact = NSPredicate(value: true)
        peoplePicker.predicateForSelectionOfProperty = NSPredicate(value: false)// 防止自动dismiss
        
        let vc = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.first
        
        if authorStatus == CNAuthorizationStatus.notDetermined {
            // 用户未授权
            CNContactStore().requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if granted { // 授权成功
                    
                    vc?.present(peoplePicker, animated: true, completion: {
                        // 读取所有的联系人数据
                        self.originalContactsData = try self.readRecordsWithContacts()
                        //                        userDefaults.setValue(self.array , forKey: userAddressBookKey)
                        //                        userDefaults.synchronize()
                        } as? () -> Void)
                    
                } else {
                    // 授权失败
                    print("\(String(describing: error))")
                }
            })
            
        } else if authorStatus == CNAuthorizationStatus.authorized {
            
            // 已授权 弹出通讯录
            vc?.present(peoplePicker, animated: true, completion: {
                // 读取所有的联系人数据
                self.originalContactsData = try self.readRecordsWithContacts()
                
                //                UserDefaults.standard.setValue(self.array, forKey: userAddressBookKey)
                //                UserDefaults.standard.synchronize()
                
                } as? () -> Void)
            
        } else if authorStatus == CNAuthorizationStatus.restricted || authorStatus == CNAuthorizationStatus.denied {
            
            // 提示用户去打开设置
            let sureAction = UIAlertAction.init(title: "确定", style: .destructive, handler: { (alert) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                
                if UIApplication.shared.canOpenURL(url!) {
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url! as URL)
                    }
                }
            })
            let cancleAction = UIAlertAction.init(title: "取消", style: .destructive, handler: nil)
            let alertController = UIAlertController.init(title: "温馨提示", message: "\"设置\"-隐私-通讯录中打开\"应极\"的访问权限", preferredStyle: .alert)
            alertController.addAction(sureAction)
            alertController.addAction(cancleAction)
            vc?.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //  MARK: - 获取联系人
    /// 从系统获取联系人数组
    ///
    /// - Returns: 联系人数组
    public func loadConcatcsFromSystem() throws -> [Contact] {
        do {
            try readRecords()
        } catch let error{
            throw error
        }
        return originalContactsData
    }
    
    //  MARK: - 私有逻辑
    
    /// 判断当前手机号是否有效(这个项目内不做这个判断)
    ///
    /// - Parameter mobileNumber: 被判断的手机号码
    /// - Returns: 当前手机号码是否有效
    private func validateMobileNumber(mobileNumber: String) -> Bool {
        guard mobileNumber.count == 11 else {
            print("手机号码位数不合法 >> \(mobileNumber)")
            return false
        }
        //  这里考虑增加一个是否支持虚拟号段的判断
        let mobile = "^1[3|5|8][0-9]\\d{8}$"
        let regexMobile = NSPredicate.init(format: "SELF MATCHES %@", mobile)
        return regexMobile.evaluate(with: mobileNumber)
    }
    
    /// 去掉手机号码中的无意义字符
    ///
    /// - Parameter str: 含有无意义字符的号码
    /// - Returns: 去掉无意义字符的号码
    private func removeUnuseCharacter(str: String) -> String {
        var tempStr = str
        
        if tempStr.contains("-") { tempStr = tempStr.replacingOccurrences(of: "-", with: "") }
        if tempStr.contains("(") { tempStr = tempStr.replacingOccurrences(of: "(", with: "") }
        if tempStr.contains(")") { tempStr = tempStr.replacingOccurrences(of: ")", with: "") }
        if tempStr.contains(" ") { tempStr = tempStr.replacingOccurrences(of: " ", with: "") }
        if tempStr.contains(" ") { tempStr = tempStr.replacingOccurrences(of: " ", with: "") }
        
        return tempStr
    }
    
    /// 从系统通讯录中刷新通讯录数据
    private func readRecords() throws {
        //  清空当前的原始数据
        originalContactsData.removeAll()
        
        //  获取联系人数据
        do {
            originalContactsData = try readRecordsWithContacts()
        } catch let error {
            throw error
        }
    }
    
    
    /// 上传通讯录
    ///
    /// - Parameters:
    ///   - urlStr: url地址
    ///   - contacts: <#contacts description#>
    func uploadContactsToHost(urlStr: String, contacts: [Contact]) {
        var params: [[String: Any]] = []
        for contact: Contact in contacts {
            var paramDic: [String: Any] = [:]
            paramDic["link_name"] = contact.name
            var numbers: [String] = []
            for number: String in contact.phoneNumbers {
                numbers.append(number)
            }
            paramDic["link_nums"] = numbers
            params.append(paramDic)
        }
        var paramsDic: [String: Any] = ["data": params]
        paramsDic["cust_id"] = "123456"
        paramsDic["device_id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        print(paramsDic)
        
//        PHNetworkTool.shareNetworkTool().postRequest(urlStr: urlStr, params: paramsDic, success: { (resultDic) -> () in
//            printLog(message: resultDic)
//        }) { (error) -> () in
//            printLog(message: error)
//        }
    }
    
    /// 使用Contacts获取联系人
    private func readRecordsWithContacts() throws -> [Contact]  {
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
        var results = [Contact]()
        do {
            try contactStore.enumerateContacts(with: CNContactFetchRequest.init(keysToFetch: keysToFetch as! [CNKeyDescriptor]), usingBlock: { [weak self] (contact, pointer) in
                
                //  确保当前联系人至少有一个电话号码
                guard contact.phoneNumbers.count > 0 else { return }
                //  获取电话号码列表
                let phoneNums = contact.phoneNumbers
                var phoneNumbers: [String] = []
                //  遍历
                for phoneNum in phoneNums {
                    //  获取这个电话号码的合法值
                    let phoneNumber: CNPhoneNumber = phoneNum.value
                    //  获取这个电话号码的字符串值
                    if let phoneStr = self?.removeUnuseCharacter(str: phoneNumber.stringValue) {
                        guard phoneStr != "" else { continue }
                        phoneNumbers.append(phoneStr)
                    }
                }
                
                //  防御代码
                guard phoneNumbers != [] else { return }
                //  保存联系人
                results.append(Contact.init(name: "\(contact.familyName)\(contact.givenName)", phoneNumbers: phoneNumbers))
                
            })
        } catch _ {
            //  抛出一个自己封装的异常
            throw ContactsToolError.authorizeFailed
        }
        
        return results
    }
    
}

// MARK: - CNContactPickerDelegate
@available(iOS 9.0, *)
public extension ContactsManager {
    public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        getContactOnCancle!("CANCEL")
    }
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        guard contact.phoneNumbers.count > 0 else {
            return
        }
        
        var phoneNums: [String] = []
        for phoneNumber in contact.phoneNumbers {
            let phoneNum: CNPhoneNumber = phoneNumber.value
            phoneNums.append(removeUnuseCharacter(str: phoneNum.stringValue))
        }
        let contact: Contact = Contact.init(name: "\(contact.familyName)\(contact.givenName)", phoneNumbers: phoneNums)
        getContactOnSuccess!(contact)
    }
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        print("选中")
    }
}

