//
//  AddFriendsTableViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

//添加好友
struct myFriend {
    var isExist=false
    var Name=""
    var imgUrl=""
    var status = -10014  //－10014不是浩泽用户 0没关系 1"已发送" 2"已添加"
    var phone=""
    var messageCount=0
}

class AddFriendsTableViewController: UITableViewController,UITextFieldDelegate {

    
    var sendPhone=""
    var seachResult=myFriend( )
    var bookPhone=[myFriend]()
    //NSMutableArray
    var tabelHeaderView:FriendSearch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("添加好友")
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.tableView.rowHeight = 44
        //headerview
        //self.tableView.sectionHeaderHeight=49
        
        tabelHeaderView = Bundle.main.loadNibNamed("FriendSearch", owner: self, options: nil)?.last as! FriendSearch
        tabelHeaderView.searchButton.addTarget(self, action: #selector(SearchPhone), for: .touchUpInside)
        tabelHeaderView.SearchTextFD.delegate=self
        self.tableView.tableHeaderView=tabelHeaderView
        NotificationCenter.default.addObserver(self, selector: #selector(addfriendSuccess), name: NSNotification.Name(rawValue: "sendAddFriendMesSuccess"), object: nil)
        
        Tongxunlu()
    }

    func addfriendSuccess()
    {
        if seachResult.isExist==true&&seachResult.phone==sendPhone
        {
            seachResult.status=1
        }
        bookPhone=[myFriend]()
        Tongxunlu()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
    }
    func back()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionview=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: 49))
        sectionview.backgroundColor=UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
        let sectionlabel=UILabel(frame: CGRect(x: 15, y: 24, width: 100, height: 12))
        sectionlabel.textAlignment=NSTextAlignment.left
        sectionlabel.text=section==0 ? loadLanguage("搜索结果" ):loadLanguage("通讯录好友")
        sectionlabel.font=UIFont.systemFont(ofSize: 12)
        sectionlabel.textColor=UIColor(red: 135/255, green: 136/255, blue: 137/255, alpha: 1)
        sectionview.addSubview(sectionlabel)
        return sectionview
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0&&self.seachResult.isExist==false
        {
            return 0
        }
        return 49
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section==0&&self.seachResult.isExist==false
        {
            return 0
        }
        if section==0
        {
            return 1
        }
        else
        {
            return bookPhone.count//通讯录好友数量
        }
        
        //return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("AddFriendTableViewCell", owner: self, options: nil)?.last as! AddFriendTableViewCell
        cell.AddFriendButton.addTarget(self, action: #selector(toAddFriend), for: .touchUpInside)
        // Configure the cell...
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        cell.AddFriendButton.tag=(indexPath as NSIndexPath).section+(indexPath as NSIndexPath).row
        if (indexPath as NSIndexPath).section==0
        {
            if seachResult.isExist==true
            {
                switch (seachResult.status)
                {
                case 0:
                    cell.AddFriendButton.isEnabled=true
                    cell.AddFriendButton.setTitle(loadLanguage("添加"), for: UIControlState())
                    break
                case 1:
                    cell.AddFriendButton.isEnabled=false
                    cell.AddFriendButton.setTitle(loadLanguage("已发送"), for: UIControlState())
                    cell.AddFriendButton.backgroundColor=UIColor.clear
                    cell.AddFriendButton.setTitleColor(UIColor.gray, for: UIControlState())
                    break
                case 2:
                    cell.AddFriendButton.isEnabled=false
                    cell.AddFriendButton.setTitle(loadLanguage("已添加"), for: UIControlState())
                    cell.AddFriendButton.backgroundColor=UIColor.clear
                    cell.AddFriendButton.setTitleColor(UIColor.gray, for: UIControlState())
                    break
                default:
                    break
                    
                }
                
                cell.headImage.image=seachResult.imgUrl=="" ? UIImage(named: "DefaultHeadImage") : UIImage(data: try! Data(contentsOf: URL(string: seachResult.imgUrl)!))
                cell.Name.text=seachResult.Name
            }
            
        
        }
        else
        {
            switch (bookPhone[(indexPath as NSIndexPath).row].status)
            {
            case 0:
                cell.AddFriendButton.isEnabled=true
                cell.AddFriendButton.setTitle(loadLanguage("添加"), for: UIControlState())
                break
            case 1:
                cell.AddFriendButton.isEnabled=false
                cell.AddFriendButton.setTitle(loadLanguage("已发送"), for: UIControlState())
                cell.AddFriendButton.backgroundColor=UIColor.clear
                cell.AddFriendButton.setTitleColor(UIColor.gray, for: UIControlState())
                break
            case 2:
                cell.AddFriendButton.isEnabled=false
                cell.AddFriendButton.setTitle(loadLanguage("已添加"), for: UIControlState())
                cell.AddFriendButton.backgroundColor=UIColor.clear
                cell.AddFriendButton.setTitleColor(UIColor.gray, for: UIControlState())
                break
            default:
                break
                
            }
            
            cell.headImage.image=bookPhone[(indexPath as NSIndexPath).row].imgUrl=="" ? UIImage(named: "DefaultHeadImage") : UIImage(data: try! Data(contentsOf: URL(string: bookPhone[(indexPath as NSIndexPath).row].imgUrl)!))
            cell.Name.text=bookPhone[(indexPath as NSIndexPath).row].Name
        }
        return cell
    }
    
    func toAddFriend(_ button:UIButton)
    {
        if button.tag==0
        {
            sendPhone=seachResult.phone
        }
        else{
            sendPhone=bookPhone[button.tag-1].phone
        }
        self.performSegue(withIdentifier: "showSendYanZH", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showSendYanZH"
        {
            let page=segue.destination as! SendYanZHViewController
            page.sendphone=sendPhone
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


    //数据访问
    func SearchPhone()
    {
        tabelHeaderView.SearchTextFD.resignFirstResponder()
        let phonestr=tabelHeaderView.SearchTextFD.text!
        if phonestr==""
        {
            let alert=UIAlertView(title: "", message: loadLanguage("输入信息不能为空！"), delegate: self, cancelButtonTitle: "ok")
            alert.show()
            return
        }
        let werbservice = MyInfoWerbservice()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        werbservice.getUserNickImage([phonestr], return: { (responseObject,statusManager) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
                self.seachResult.phone=phonestr
                if statusManager?.networkStatus==kSuccessStatus
                {
                        let state=responseObject?.object(forKey: "state") as? Int
                    print(responseObject)
                        if state>0
                        {
                            
                            let friend=(responseObject?.object(forKey: "data") as AnyObject).object(at: 0) as AnyObject
                            self.seachResult.isExist=true
                            self.seachResult.status=friend.object(forKey: "Status") as! Int
                            if self.seachResult.status == -10013
                            {
                                self.seachResult.isExist=false
                               
                            }
                            else
                            {
                                self.seachResult.phone=friend.object(forKey: "mobile") as! String
                                
                                self.seachResult.imgUrl=friend.object(forKey: "headimg") as! String
                            self.seachResult.Name=friend.object(forKey: "nickname") as! String
                                self.seachResult.Name=self.seachResult.Name.characters.count==0 ? self.seachResult.phone: self.seachResult.Name
                            }
                            self.tableView.reloadData()
                        }
                    else
                        {
                            let alert=UIAlertView(title: "", message:loadLanguage("对不起，没有找到！"), delegate: self, cancelButtonTitle: "ok")
                            alert.show()
                    }
                
            }
            else
                {
                    let alert=UIAlertView(title: "", message: loadLanguage("对不起，网络异常！"), delegate: self, cancelButtonTitle: "ok")
                    alert.show()
            }
            
        })
        
    
    }
    
    func Tongxunlu()
    {
        let friends:[String]=getSysContacts()
        var friendsString=""
        if friends.count>=2
        {
           for i in 0...(friends.count-2)
           {
               friendsString+=friends[i]+","
           }
           friendsString+=friends[friends.count-1]
           getTXFriends(friendsString)
        }
    }
    func getTXFriends(_ TXLfriends:String){
        if TXLfriends==""
        {
            return
        }
        let werbservice = MyInfoWerbservice()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        werbservice.getUserNickImage([TXLfriends], return: { [weak self](responseObject,statusManager) -> Void in
            
            if let strongSelf=self{
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                if statusManager?.networkStatus==kSuccessStatus
                {
                    let state=responseObject?.object(forKey: "state") as! Int
                    if state>0
                    {
                        
                        let friends=responseObject?.object(forKey: "data") as! NSMutableArray
                        for i in 0...(friends.count-1)
                        {
                            var friendtmp=myFriend()
                            friendtmp.isExist=true
                            let friendData=friends[i] as AnyObject
                            friendtmp.status=friendData.object(forKey: "Status") as! Int
                            if (friendtmp.status+10014)==0
                            {
                                continue
                            }
                            friendtmp.imgUrl=friendData.object(forKey: "headimg") as! String
                            friendtmp.Name=friendData.object(forKey: "nickname") as! String
                            friendtmp.phone=friendData.object(forKey: "mobile") as! String
                            
                            friendtmp.Name=friendtmp.Name.characters.count==0 ? friendtmp.phone: friendtmp.Name
                            
                            strongSelf.bookPhone.append(friendtmp)
                        }
                        strongSelf.tableView.reloadData()
                    }
                    
                }
                
            }
        })
    }
    

 
    //查找联系人
    
    func getSysContacts() -> [String] {
        enum MyError: Error {
            case notExist
            case outOfRange
        }
        var addressBook: ABAddressBook?
        var error:Unmanaged<CFError>?
        let tmpaddress =  ABAddressBookCreateWithOptions(nil, &error)
        if tmpaddress != nil
        {
            addressBook=tmpaddress?.takeRetainedValue()
        }
        else
        {
            return []
        }
        
        //var error:Unmanaged<CFError>?
        
        
        
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        
        if sysAddressBookStatus == .denied || sysAddressBookStatus == .notDetermined {
            // Need to ask for authorization
            let authorizedSingal:DispatchSemaphore = DispatchSemaphore(value: 0)
            let askAuthorization:ABAddressBookRequestAccessCompletionHandler = { success, error in
                if success {
                    _=ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
                    _=authorizedSingal.signal()
                }
            }
            ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
            _=authorizedSingal.wait(timeout: DispatchTime.distantFuture)
        }
        
        return analyzeSysContacts( ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray )
    }
    
    func analyzeSysContacts(_ sysContacts:NSArray) -> [String] {
        var allContacts:Array = [String]()
        for contact in sysContacts {
            for (_, value) in analyzeContactProperty(contact as ABRecord, property: kABPersonPhoneProperty,keySuffix: "Phone") ?? ["":""] {
                //print(value)
                var tmpvalue=value.replacingOccurrences(of: "-", with: "")
                tmpvalue=tmpvalue.replacingOccurrences(of: " ", with: "")
                
                if checkTel(tmpvalue as NSString)
                {
                    allContacts.append(tmpvalue)
                }
            }
        }
        return allContacts
    }
    
    func analyzeContactProperty(_ contact:ABRecord, property:ABPropertyID, keySuffix:String) -> [String:String]? {
        let propertyValues:ABMultiValue? = ABRecordCopyValue(contact, property)?.takeRetainedValue()
        if propertyValues != nil {
            //var values:NSMutableArray = NSMutableArray()
            var valueDictionary:Dictionary = [String:String]()
            if propertyValues?.count<=0
            {
                return [String:String]()
            }
            for i in 0 ..< ABMultiValueGetCount(propertyValues) {
                var label:String = ABMultiValueCopyLabelAtIndex(propertyValues, i).takeRetainedValue() as String
                label += keySuffix
                let value = ABMultiValueCopyValueAtIndex(propertyValues, i)
                switch property {
                    
                default :
                    valueDictionary[label] = value?.takeRetainedValue() as? String ?? ""
                }
            }
            return valueDictionary
        }else{
            return nil
        }
    }
}
