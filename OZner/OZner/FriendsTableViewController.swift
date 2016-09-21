//
//  FriendsTableViewController.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI
//排名结构体
struct myRankstruct {
    var rank=""
    var max=""
    var zanCount=""
    var type=""
    var time=""
    var Nickname=""
    var Icon=""
}
struct deviceTypezb {
    let CUP="CP001"
    let Tap="SC001"
    let WaterPre="MXCHIP_HAOZE_Water"
}

class FriendsTableViewController: UITableViewController,UITextFieldDelegate,UITextViewDelegate {
    
    let NavTitleView=Bundle.main.loadNibNamed("FriendsNav", owner: nil, options: nil)?.last as! FriendsNav
    var currentTabel=1 as Int{
        didSet{
            
            chatBarView.removeFromSuperview()
            
        }
    }//0表示选中我的排名，1表示选中我的好友
    var myfriendarray=[myFriend]()
    
    //留言
    var liuyanCellViews=[String:UIView]()
    var chatBarView:chatBarViewLiuyan!
    var currentliuyanAtIndex = -1{
        didSet{
            if currentliuyanAtIndex>=0
            {
                chatBarView.removeFromSuperview()
                self.tableView.superview!.addSubview(chatBarView)
                
            }
            else
            {
                chatBarView.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
    var myfriendCellArray=[String:FriendsCell]()
    
    
    //朋友的用户ID
    var friendId=[String]()
    var myUserId=""
    
    var rightBarButton:FriendsNavRight!
    
    //rankView 排名视图
    var RankView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("我的好友")
        
        //添加导航视图
        NavTitleView.bottomLeft.isHidden=true
        NavTitleView.bottomRight.isHidden=false
        NavTitleView.MyRankButton.setTitleColor(NavTitleView.color_normol, for: UIControlState())
        NavTitleView.MyFriendsButton.setTitleColor(NavTitleView.color_select, for: UIControlState())
        NavTitleView.MyRankButton.addTarget(self, action: #selector(RankAndFriendclick), for: .touchUpInside)
        NavTitleView.MyFriendsButton.addTarget(self, action: #selector(RankAndFriendclick), for: .touchUpInside)
        //验证消息
        
        //showYZNews
        
        rightBarButton=Bundle.main.loadNibNamed("FriendsNavRight", owner: nil, options: nil)?.last as! FriendsNavRight
        rightBarButton.TongzhiButton.addTarget(self, action: #selector(toYZNews), for: .touchUpInside)
        rightBarButton.AddFriend.addTarget(self, action: #selector(toAddFriends), for: .touchUpInside)
        
        // FriendsNavRight.
        self.navigationItem.titleView=NavTitleView
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: rightBarButton)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationController?.isNavigationBarHidden=false
        self.tableView.rowHeight = 65
        self.refreshControl=nil
        //chatbarView
        chatBarView=Bundle.main.loadNibNamed("chatBarViewLiuyan", owner: self, options: nil)?.last as! chatBarViewLiuyan
        chatBarView.inputTextfiled.delegate=self
        chatBarView.sendButton.layer.borderColor=UIColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 1).cgColor
        chatBarView.sendButton.layer.borderWidth=1
        chatBarView.sendButton.layer.cornerRadius=8
        chatBarView.sendButton.addTarget(self, action: #selector(SendMess), for: .touchUpInside)
        chatBarView.frame=CGRect(x: 0, y: Screen_Hight-48, width: Screen_Width, height: 48)
        
        /*-------------键盘监听事件---------------------*/
        //使用NSNotificationCenter 鍵盤出現時
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        //使用NSNotificationCenter 鍵盤隐藏時
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //加载数据
        let userinfo_local=getPlistData("userinfoURL")
        if userinfo_local.count != 0
        {
            myUserId=userinfo_local.object(forKey: "UserId") as! String
            //myUserName=userinfo_local.objectForKey("UserId") as! String
        }
        //使用NSNotificationCenter 验证消息通知
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFriendList), name: NSNotification.Name(rawValue: "OtherAcceptMeNews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateYZNewsRedDOt), name: NSNotification.Name(rawValue: "OtherRequestNews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyCenterNewMessageNotice), name: NSNotification.Name(rawValue: "MyCenterNewMessageNotice"), object: nil)
        //更新小红点状态
        updateYZNewsRedDOt()
        
        //加载Rank视图
        //let rankControlView=MyRankViewController()
        //RankView=rankControlView.view
        RankView=UIScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: Screen_Hight-64))
        RankView.showsHorizontalScrollIndicator=false
        RankView.showsVerticalScrollIndicator=false
        RankView.backgroundColor=UIColor.white
        self.RankView.contentSize=CGSize(width: 0, height: (Screen_Hight-64))
        //加载RankView
        self.getTDSRanks()
        self.view.addSubview(RankView)
        RankView.isHidden=true
        self.getTXFriends()
        
        
    }
    func updateFriendList()
    {
        self.getTXFriends()
    }
    func MyCenterNewMessageNotice()
    {
        NavTitleView.friendBadge.isHidden=false
    }
    //验证列表小红点是否显示
    func updateYZNewsRedDOt()
    {
        let countNewFriend=UserDefaults.standard.object(forKey: "OtherRequestNews")
        if countNewFriend==nil
        {
            rightBarButton.smallTongzhiView.isHidden=true
        }
        else if (countNewFriend as! Int) > 0
        {
            rightBarButton.smallTongzhiView.isHidden=false
        }
        else
        {
            rightBarButton.smallTongzhiView.isHidden=true
        }
        
    }
    func SendMess()
    {
        if chatBarView.inputTextfiled.text==""
        {
            return
        }
        let werbservice = UserInfoActionWerbService()
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.leaveMessage(friendId[currentliuyanAtIndex], message: chatBarView.inputTextfiled.text) { (data,statu) -> Void in
            self.chatBarView.inputTextfiled.text=""
            self.chatBarView.inputTextfiled.resignFirstResponder()
            self.getLiuYan(self.friendId[self.currentliuyanAtIndex])
            self.myfriendarray[self.currentliuyanAtIndex].messageCount=self.myfriendarray[self.currentliuyanAtIndex].messageCount+1
            
            self.myfriendCellArray["\(self.currentliuyanAtIndex)"]?.LiuyanLabel.text="\(self.myfriendarray[self.currentliuyanAtIndex].messageCount)" + loadLanguage("条留言")
            // MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
    }
    //实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
    func keyboardWasShown(_ aNotification:Notification)
    {
        let info = (aNotification as NSNotification).userInfo! as NSDictionary
        //kbSize即為鍵盤尺寸 (有width, height)
        let kbSize = (info.object(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue//cgRectValue.size) as CGSize//得到鍵盤的高度
        //print("hight_hitht:\(kbSize.height)")
        //print(Screen_Hight-48-kbSize.height)
        chatBarView.frame=CGRect(x: 0, y: Screen_Hight-48-(kbSize?.height ?? 0)!, width: Screen_Width, height: 48)
        
    }
    //当键盘隐藏的时候
    func keyboardWillBeHidden(_ aNotification:Notification)
    {
        chatBarView.frame=CGRect(x: 0, y: Screen_Hight-48, width: Screen_Width, height: 48)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func toYZNews(){
        UserDefaults.standard.setValue(0, forKey: "OtherRequestNews")
        updateYZNewsRedDOt()
        self.performSegue(withIdentifier: "showYZNews", sender: self)
    }
    func toAddFriends(){
        self.performSegue(withIdentifier: "showAddFriends", sender: self)
    }
    func RankAndFriendclick(_ button:UIButton){
        if currentTabel==(button.titleLabel?.text ==  loadLanguage("我的排名") ? 0 : 1)
        {
            return
        }
        currentTabel=button.titleLabel?.text==loadLanguage("我的排名") ? 0 : 1
        if currentTabel==0
        {
            //self.tableView.rowHeight = 200
            NavTitleView.bottomLeft.isHidden=false
            NavTitleView.bottomRight.isHidden=true
            NavTitleView.MyRankButton.setTitleColor(NavTitleView.color_select, for: UIControlState())
            NavTitleView.MyFriendsButton.setTitleColor(NavTitleView.color_normol, for: UIControlState())
            RankView.isHidden=false
            currentliuyanAtIndex = -1
            self.tableView.reloadData()
        }
        else
        {
            //self.tableView.rowHeight = 65
            NavTitleView.bottomLeft.isHidden=true
            NavTitleView.bottomRight.isHidden=false
            NavTitleView.MyRankButton.setTitleColor(NavTitleView.color_normol, for: UIControlState())
            NavTitleView.MyFriendsButton.setTitleColor(NavTitleView.color_select, for: UIControlState())
            RankView.isHidden=true
            self.tableView.reloadData()
        }
        
        
    }
    
    func back()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let liuyanCount=(UserDefaults.standard.object(forKey: "NewMessageCount") != nil) ? UserDefaults.standard.object(forKey: "NewMessageCount"):0
        NavTitleView.friendBadge.isHidden=(liuyanCount as! Int)>0 ? false:true
        
        currentTabel=1
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentliuyanAtIndex = -1
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return myfriendCellArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //好友列表
        return myfriendCellArray["\((indexPath as NSIndexPath).section)"]!
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentTabel==1
        {
            print(currentliuyanAtIndex)
            print((indexPath as NSIndexPath).section)
            if currentliuyanAtIndex==(indexPath as NSIndexPath).section
            {
                currentliuyanAtIndex = -1
            }
            else
            {
                currentliuyanAtIndex=(indexPath as NSIndexPath).section
                getLiuYan(friendId[(indexPath as NSIndexPath).section])
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if currentTabel==1&&currentliuyanAtIndex==section
        {
            return (liuyanCellViews[self.friendId[section]]! as UIView).frame.height
        }
        else
        {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return liuyanCellViews[self.friendId[section]]! as UIView
    }
    
    
    //取数据
    func getTXFriends(){
        let werbservice = UserInfoActionWerbService()
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.getFriendList { (data1, Status) -> Void in
            
            if Status?.networkStatus == kSuccessStatus
            {
                let data = data1 as! NSDictionary
                
                let state=data.object(forKey: "state") as! Int
                if state>0
                {
                    
                    let friendcount=data.object(forKey: "friendlist") as! NSArray
                    
                    for i in 0..<friendcount.count
                    {
                        var friendstrut=myFriend()
                        friendstrut.phone=(friendcount[i] as AnyObject).object(forKey: "FriendMobile")==nil ? "" : ((friendcount[i] as AnyObject).object(forKey: "FriendMobile") as! String)
                        
                        if friendstrut.phone==get_Phone()
                        {
                            friendstrut.phone=(friendcount[i] as AnyObject).object(forKey: "Mobile")==nil ? "" : ((friendcount[i] as AnyObject).object(forKey: "Mobile") as! String)
                        }
                        friendstrut.imgUrl=(friendcount[i] as AnyObject).object(forKey: "Icon")==nil ? "" : ((friendcount[i] as AnyObject).object(forKey: "Icon") as! String)
                        
                        friendstrut.Name=(friendcount[i] as AnyObject).object(forKey: "Nickname")==nil ? friendstrut.phone : ((friendcount[i] as AnyObject).object(forKey: "Nickname") as! String)
                        let tmpmess=(friendcount[i] as AnyObject).object(forKey: "MessageCount") as! Int
                        friendstrut.messageCount=tmpmess
                        
                        self.myfriendarray.append(friendstrut)
                        //cell load
                        let cell = Bundle.main.loadNibNamed("FriendsCell", owner: self, options: nil)?.last as! FriendsCell
                        cell.LiuyanLabel.text="\(friendstrut.messageCount)"+loadLanguage("条留言")
                        cell.Name.text=friendstrut.Name
                        if friendstrut.imgUrl != "" && friendstrut.imgUrl.contains("http://")
                        {
                            cell.headImg.image=UIImage(data: try! Data(contentsOf: URL(string: friendstrut.imgUrl)!))
                        }
                        else
                        {
                            cell.headImg.image=UIImage(named: "DefaultHeadImage")
                        }
                        
                        //---------------留言-------------
                        let tmpid=(friendcount[i] as AnyObject).object(forKey: "CreateBy") as! String
                        
                        if tmpid==self.myUserId
                        {
                            self.friendId.append((friendcount[i] as AnyObject).object(forKey: "ModifyBy") as! String)
                        }
                        else
                        {
                            self.friendId.append(tmpid)
                        }
                        
                        //
                        let tmpliuyanView=UIView()
                        tmpliuyanView.backgroundColor=UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
                        tmpliuyanView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: 40)
                        self.liuyanCellViews[self.friendId[i]]=tmpliuyanView
                        cell.selectionStyle=UITableViewCellSelectionStyle.none
                        self.myfriendCellArray["\(i)"]=cell
                        
                    }
                    self.tableView.reloadData()
                    
                }
            }
            
        }     
        
    }
    
    func getMessCellView(_ tmplength:Int,messcontent:String,messtime:String)->UIView
    {
        
        let messcellView=UIView()
        let messtextLabel=UILabel(frame: CGRect(x: 16, y: 0, width: Screen_Width-110, height: 20))
        messtextLabel.font=UIFont.systemFont(ofSize: 14)
        messtextLabel.numberOfLines=0
        let attributedString = NSMutableAttributedString(string: messcontent)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 75/255, green: 139/255, blue: 246/255, alpha: 1), range: NSMakeRange(0,tmplength))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing=3//调整行间距
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0,messcontent.characters.count))
        
        messtextLabel.attributedText = attributedString
        
        messtextLabel.frame=CGRect(x: 16, y: 0, width: messtextLabel.frame.width, height: messtextLabel.frame.height)
        //messtextLabel.backgroundColor=UIColor.redColor()
        messcellView.addSubview(messtextLabel)
        messtextLabel.sizeToFit()
        
        let tmpsize=messtextLabel.sizeThatFits(CGSize.zero)
        let lineCount=Int(tmpsize.width)/Int(Screen_Width-110)+((Int(tmpsize.width)%Int(Screen_Width-110))>0 ? 1:0)
        let tmpHeight=CGFloat(lineCount*20)>100 ? 100:CGFloat(lineCount*20)
        messtextLabel.frame=CGRect(x: 16, y: 0, width: messtextLabel.frame.width, height: tmpHeight)
        let messTimeLabel=UILabel(frame: CGRect(x: Screen_Width-86, y: 0, width: 70, height: 20))
        //messTimeLabel.backgroundColor=UIColor.redColor()
        messTimeLabel.font=UIFont.systemFont(ofSize: 11)
        messTimeLabel.text=messtime
        messTimeLabel.textAlignment=NSTextAlignment.right
        messcellView.addSubview(messTimeLabel)
        messcellView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: tmpHeight)
        return messcellView
    }
    func getLiuYan(_ otherid:String)
    {
        UserDefaults.standard.set(0, forKey: "NewMessageCount")
        NavTitleView.friendBadge.isHidden=true
        let werbservice = UserInfoActionWerbService()
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.getHistoryMessage(otherid) { (data1, Status) -> Void in
            if Status?.networkStatus == kSuccessStatus
            {
                let data = data1 as! NSDictionary
                let state=data.object(forKey: "state") as! Int
                if state>0
                {
                    let liuyanArray=data.object(forKey: "data")  as! NSArray
                    print(liuyanArray)
                    let tmpliuyanView=UIView()
                    tmpliuyanView.backgroundColor=UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
                    var tmpMess_y:CGFloat=10
                    
                    for i in 0...(liuyanArray.count-1)
                    {
                        let liuyanData = liuyanArray.object(at: i) as! NSDictionary
                        var messstring=liuyanData.object(forKey: "message") as! String
                        let sendid=liuyanData.object(forKey: "senduserid") as! String
                        var sendNameCount=0
                        if sendid==self.myUserId
                        {
                            sendNameCount=loadLanguage("我 说: ").characters.count
                            messstring=loadLanguage("我 说: ")+messstring
                        }
                        else
                        {
                            let othername=liuyanData.object(forKey: "Nickname")==nil ? "无名":(liuyanData.object(forKey: "Nickname") as! String)
                            sendNameCount=(othername+" 说: ").characters.count
                            messstring=othername+loadLanguage(" 说: ")+messstring
                        }
                        
                        //时间
                        let messtime=liuyanData.object(forKey: "stime") as! NSString
                        let needtime=dateStampToString(messtime as String, format: "dd日hh:mm")
                        //formatter.dateFormat="HHMM"

                        
                        let messcell=self.getMessCellView(sendNameCount,messcontent: messstring, messtime: needtime as String)
                        messcell.frame=CGRect(x: 0, y: tmpMess_y, width: Screen_Width, height: messcell.frame.height)
                        
                        tmpliuyanView.addSubview(messcell)
                        tmpMess_y+=messcell.frame.height
                        //messstring+="asjdalkds11312阿达阿首都\(j)"
                    }
                    tmpliuyanView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: 10+tmpMess_y)
                    self.liuyanCellViews[otherid]=tmpliuyanView
                    
                }
                self.tableView.reloadData()
            }
            
            //MBProgressHUD.hideHUDForView(self.view, animated: true)
            
        }
    }
    
    //排名
    //var TdsRankCellArray=[String:MyRankTableViewCell]()
    var myrankarray=[myRankstruct]()
    var RankDeviceType=""
    func ToTDS(_ button:UIButton)
    {
        RankDeviceType=myrankarray[button.tag].type
        self.performSegue(withIdentifier: "showTDS", sender: self)
    }
    func LookZanMe(_ button:UIButton)
    {
        RankDeviceType=myrankarray[button.tag].type
        self.performSegue(withIdentifier: "showZanMe", sender: self)
    }
    func getTDSRanks(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerDevice/GetRankNotify"
        print(url)
        let params:NSDictionary = ["usertoken":get_UserToken()]
        manager.post(url,
                     parameters: params,
                     success: { (operation,
                        response) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let responseObject = response as AnyObject
                        let state=responseObject.object(forKey: "state") as! Int
                        //var rankcount:NSMutableArray!
                        if state>0
                        {
                            let rankcount=responseObject.object(forKey: "data") as! NSArray
                            for i in 0..<rankcount.count
                            {
                                var rankstrut=myRankstruct()
                                let tmprankData=rankcount.object(at: i) as! NSDictionary
                                rankstrut.rank="\(tmprankData.object(forKey: "rank") as! Int)"
                                rankstrut.max="\(tmprankData.object(forKey: "max") as! Int)"
                                rankstrut.zanCount="\(tmprankData.object(forKey: "likenumaber") as! Int)"
                                rankstrut.type=tmprankData.object(forKey: "type") as! String
                                
                                let tmptime=tmprankData.object(forKey: "notime") as! NSString
                                
                                let tmptime1=dateStampToString(tmptime as String, format: "MM月dd日")
                                
                                rankstrut.time=tmptime1 as String
                                rankstrut.Nickname=tmprankData.object(forKey: "Nickname") == nil ? "" : (tmprankData.object(forKey: "Nickname") as! String)
                                rankstrut.Icon=tmprankData.object(forKey: "Icon")==nil ? "" : (tmprankData.object(forKey: "Icon") as! String)
                                
                                self.myrankarray.append(rankstrut)
                                let tableCell=self.getTdsRankCell(rankstrut,index: i)
                                tableCell.frame=CGRect(x: 0, y: CGFloat(i*200), width: Screen_Width, height: 200)
                                self.RankView.addSubview(tableCell)
                                
                                
                                
                            }
                            
                            self.RankView.contentSize=CGSize(width: 0, height: (CGFloat(rankcount.count*200)<(Screen_Hight-64) ? (Screen_Hight-64): CGFloat(rankcount.count*200)))
                        }
                        
            },
                     failure: { (operation,
                        error) in
                        MBProgressHUD.hide(for: self.view, animated: true)
        })
        
        
        
    }
    
    func getTdsRankCell(_ tmpRank:myRankstruct,index:Int)->MyRankTableViewCell
    {
        let TdsRankcell=Bundle.main.loadNibNamed("MyRankTableViewCell", owner: nil, options: nil)?.last as! MyRankTableViewCell
        
        TdsRankcell.ToTDSButton.addTarget(self, action: #selector(ToTDS), for: .touchUpInside)
        TdsRankcell.LookZanMeButton.addTarget(self, action: #selector(LookZanMe), for: .touchUpInside)
        TdsRankcell.ToTDSButton.tag=index
        TdsRankcell.LookZanMeButton.tag=index
        //数据加载
        TdsRankcell.RankValue.text=tmpRank.rank
        TdsRankcell.todayTDS.text=tmpRank.max
        TdsRankcell.zanCount.text=tmpRank.zanCount
        TdsRankcell.rankState.text="\(tmpRank.Nickname)"+loadLanguage("夺得")+"\(tmpRank.time)"+loadLanguage("月排行榜冠军")
        let deviceType=deviceTypezb()
        switch tmpRank.type
        {
        case deviceType.CUP:
            TdsRankcell.deviceImage.image=UIImage(named: "My_cup")
            TdsRankcell.rankTitle.text=loadLanguage("智能杯水质纯净值TDS")
            break
        case deviceType.Tap:
            TdsRankcell.deviceImage.image=UIImage(named: "My_shuiji")
            TdsRankcell.rankTitle.text=loadLanguage("水探头水质纯净值TDS")
            break
        case deviceType.WaterPre:
            TdsRankcell.deviceImage.image=UIImage(named: "My_tantou")
            TdsRankcell.rankTitle.text=loadLanguage("净水器水质纯净值TDS")
            break
        default:
            break
        }
        if tmpRank.Icon != ""
        {
            TdsRankcell.rankHead.image=UIImage(data: try! Data(contentsOf: URL(string: tmpRank.Icon)!))
            //            TdsRankcell.rankHead.sd_setImageWithURL(NSURL(string: tmpRank.Icon), placeholderImage: UIImage(named: "DefaultHeadImage"), completed: { (img:UIImage!, err:NSError!, sd:SDImageCacheType, url:NSURL!) -> Void in
            //                TdsRankcell.rankHead.image=img
            //            })         
        }
        
        TdsRankcell.selectionStyle=UITableViewCellSelectionStyle.none
        return TdsRankcell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showTDS"
        {
            let page=segue.destination as! My_TDSTableViewController
            page.deviceTypezb=RankDeviceType
            
        }
        if segue.identifier=="showZanMe"
        {
            let page=segue.destination as! ZanMeTableViewController
            page.deviceType=RankDeviceType
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
