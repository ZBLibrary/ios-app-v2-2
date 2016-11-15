//
//  GYConactBook.swift
//  GYAdressBook
//
//  Created by zhuguangyang on 16/8/31.
//  Copyright © 2016年 Giant. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI

class GYPersonModel: NSObject {
    
    var firstName: String = ""
    var lastName: String = ""
    var name1: String = ""
    var phoneNumber1: String = ""
    var sectionNumber: NSInteger = 0
    var friendId: String = ""
    var recordID: NSInteger = 0
    
    var rowSelected: Bool = true
    var email: String = ""
    var tel: String = ""
    /// 图片
    var icon: NSData?
}

class GYConactBook: NSObject {
    
    private var addressArr:NSArray = NSArray()
    private var persons:NSMutableArray = NSMutableArray()
    private var listContent:NSMutableArray = NSMutableArray()
    private var liast2Content:NSMutableArray = NSMutableArray()
    
    var perArr: NSMutableArray = NSMutableArray()
    var localCollation: UILocalizedIndexedCollation?
    var sectionTitles: NSMutableArray = NSMutableArray()
    
    //调用super.init() 必须初始化一些不是nullable值
    override init() {
        super.init()
        
    }
    
    
    func getAllPerson() -> String? {
        
//        let addressBookTemp = NSMutableArray()
        let addressBooks = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        let staticid = ABAddressBookGetAuthorizationStatus()
        
        /**
         *  拒绝授权
         */
        if staticid == ABAuthorizationStatus.Denied {
            return nil
        }
        
        /// 发出通讯录的请求
        let sema = dispatch_semaphore_create(0)
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, { (granted, error) in
            
            if (error != nil) {
                
                return
            }
            
            //判断是否授权
            if granted {
                
                print("已授权")
                dispatch_semaphore_signal(sema)
                
            } else {
                print("未授权")
            }
            
        })
        
        /**
         *  一直等待
         */
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        
        
        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks).takeRetainedValue()
        
        //        let nPeople = ABAddressBookGetPersonCount(addressBooks) 
        
        var phoneString = ""
        
        for person: ABRecordRef in allPeople as NSArray {
            
//            let model = GYPersonModel()
            
            //转型错误 Could not cast value of type 'Swift.UnsafePointer<()>' (0x10274c028) to 'Swift.AnyObject' (0x10273c018).
            //http://swifter.tips/unsafe/
            // let person = CFArrayGetValueAtIndex(allPeople, i) as? ABRecordRef
            //TODO:联系人名字
//            if let abName = ABRecordCopyValue(person, kABPersonFirstNameProperty) {
//                model.name1 = abName.takeRetainedValue() as? String ?? ""
//            }
//            
//            //            if let abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty){
//            //            }
//            
//            if let abFullName = ABRecordCopyCompositeName(person) {
//                model.name1 = abFullName.takeRetainedValue() as String ?? ""
//            }
            
            let phoneValues:ABMutableMultiValueRef? =
                ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
            
            if phoneValues != nil {
                for i in 0..<ABMultiValueGetCount(phoneValues) {
                    
                    if let value = ABMultiValueCopyValueAtIndex(phoneValues
                        , i) {
                        var phone = value.takeRetainedValue() as! String
                        
                        if phone == "<null>" || phone == "" {
                            continue
                        }
                        
                        phone = phone.stringByReplacingOccurrencesOfString("+", withString: "")
                        phone = phone.stringByReplacingOccurrencesOfString("-", withString: "")
                        
                        phoneString = phoneString + "," + phone
                    }
                    
                }
                
            }
            
//            model.recordID = NSInteger(ABRecordGetRecordID(person))
//            //某一行是否被默认选中
//            model.rowSelected = false
//            
//            addressBookTemp.addObject(model)
            
            
            
        }
        
        /*
        let theCollation = UILocalizedIndexedCollation.currentCollation()
        
        self.sectionTitles.removeAllObjects()
        //27个索引 英文字母+#
        self.sectionTitles.addObjectsFromArray(theCollation.sectionTitles)
        
        for addressBook:GYPersonModel in (addressBookTemp  as NSArray) as! [GYPersonModel]{
            if addressBook.name1 != "" {
                //获取所在索引的下标
                let sect = theCollation.sectionForObject(addressBook, collationStringSelector: Selector("name1"))
                
                addressBook.sectionNumber = sect
                
            }
        }
        
        let highSection = theCollation.sectionTitles.count
        
        let sectionArrays = NSMutableArray(capacity: highSection)
        
        for _ in 0..<highSection {
            
            //数组装数组[[],[]] 显示索引下的联系人
            let sectionArray = NSMutableArray(capacity: 1)
            sectionArrays.addObject(sectionArray)
            
        }
        
        
        
        //将对应的名字加入到27个数组
        for addressBook: GYPersonModel in addressBookTemp as NSArray as! [GYPersonModel] {
            
            (sectionArrays.objectAtIndex(addressBook.sectionNumber) as! NSMutableArray).addObject(addressBook)
            
        }
        
        for sectionArray in sectionArrays {
            
            let personModel = (sectionArray as! [GYPersonModel]).first
            
            if personModel?.name1 == "" {
                continue
            } else {
                
                let sortedSection = theCollation.sortedArrayFromArray(sectionArray as! [GYPersonModel], collationStringSelector: Selector("name1"))
                
                listContent.addObject(sortedSection)
            }
            
        }
        
        
        let temp = NSMutableArray()
        
        //清除掉空数组
        listContent.enumerateObjectsUsingBlock { (arrArr, idx, stop) in
            
            let sortArr:NSArray =  arrArr as! NSArray
            
            if Bool(sortArr.count) {
                //不作处理 
                
            } else {
                //将空数组添加到temp中
                temp.addObject(sortArr)
                
            }
            
        }
        listContent.removeObjectsInArray(temp as [AnyObject])
        */
        return phoneString
        
    }
    
    
    
}
