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

    let NavTitleView=NSBundle.mainBundle().loadNibNamed("FriendsNav", owner: nil, options: nil).last as! FriendsNav
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
        NavTitleView.bottomLeft.hidden=true
        NavTitleView.bottomRight.hidden=false
        NavTitleView.MyRankButton.setTitleColor(NavTitleView.color_normol, forState: .Normal)
        NavTitleView.MyFriendsButton.setTitleColor(NavTitleView.color_select, forState: .Normal)
        NavTitleView.MyRankButton.addTarget(self, action: #selector(RankAndFriendclick), forControlEvents: .TouchUpInside)
        NavTitleView.MyFriendsButton.addTarget(self, action: #selector(RankAndFriendclick), forControlEvents: .TouchUpInside)
        //验证消息
        
        //showYZNews
        
       rightBarButton=NSBundle.mainBundle().loadNibNamed("FriendsNavRight", owner: nil, options: nil).last as! FriendsNavRight
        rightBarButton.TongzhiButton.addTarget(self, action: #selector(toYZNews), forControlEvents: .TouchUpInside)
        rightBarButton.AddFriend.addTarget(self, action: #selector(toAddFriends), forControlEvents: .TouchUpInside)
        
       // FriendsNavRight.
        self.navigationItem.titleView=NavTitleView
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: rightBarButton)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationController?.navigationBarHidden=false
        self.tableView.rowHeight = 65
        self.refreshControl=nil
        //chatbarView
        chatBarView=NSBundle.mainBundle().loadNibNamed("chatBarViewLiuyan", owner: self, options: nil).last as! chatBarViewLiuyan
        chatBarView.inputTextfiled.delegate=self
        chatBarView.sendButton.layer.borderColor=UIColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 1).CGColor
        chatBarView.sendButton.layer.borderWidth=1
        chatBarView.sendButton.layer.cornerRadius=8
        chatBarView.sendButton.addTarget(self, action: #selector(SendMess), forControlEvents: .TouchUpInside)
        chatBarView.frame=CGRect(x: 0, y: Screen_Hight-48, width: Screen_Width, height: 48)

        /*-------------键盘监听事件---------------------*/
        //使用NSNotificationCenter 鍵盤出現時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWasShown), name: UIKeyboardDidShowNotification, object: nil)
        
        //使用NSNotificationCenter 鍵盤隐藏時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIKeyboardWillHideNotification, object: nil)
        //加载数据
        let userinfo_local=getPlistData("userinfoURL")
        if userinfo_local.count != 0
        {
            myUserId=userinfo_local.objectForKey("UserId") as! String
            //myUserName=userinfo_local.objectForKey("UserId") as! String
        }
        //使用NSNotificationCenter 验证消息通知
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateFriendList), name: "OtherAcceptMeNews", object: nil)
       NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateYZNewsRedDOt), name: "OtherRequestNews", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyCenterNewMessageNotice), name: "MyCenterNewMessageNotice", object: nil)
        //更新小红点状态
        updateYZNewsRedDOt()
 
        //加载Rank视图
        //let rankControlView=MyRankViewController()
        //RankView=rankControlView.view
        RankView=UIScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: Screen_Hight-64))
        RankView.showsHorizontalScrollIndicator=false
        RankView.showsVerticalScrollIndicator=false
        RankView.backgroundColor=UIColor.whiteColor()
        self.RankView.contentSize=CGSize(width: 0, height: (Screen_Hight-64))
        //加载RankView
        self.getTDSRanks()
        self.view.addSubview(RankView)
        RankView.hidden=true
        self.getTXFriends()
        
        
    }
    func updateFriendList()
    {
        self.getTXFriends()
    }
    func MyCenterNewMessageNotice()
    {
        NavTitleView.friendBadge.hidden=false
    }
    //验证列表小红点是否显示
    func updateYZNewsRedDOt()
    {
        let countNewFriend=NSUserDefaults.standardUserDefaults().objectForKey("OtherRequestNews")
        if countNewFriend==nil
        {
            rightBarButton.smallTongzhiView.hidden=true
        }
        else if (countNewFriend as! Int) > 0
        {
            rightBarButton.smallTongzhiView.hidden=false
        }
        else
        {
            rightBarButton.smallTongzhiView.hidden=true
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
        werbservice.LeaveMessage(friendId[currentliuyanAtIndex], message: chatBarView.inputTextfiled.text) { (data:AnyObject!,statu:StatusManager!) -> Void in
            self.chatBarView.inputTextfiled.text=""
            self.chatBarView.inputTextfiled.resignFirstResponder()
            self.getLiuYan(self.friendId[self.currentliuyanAtIndex])
            self.myfriendarray[self.currentliuyanAtIndex].messageCount=self.myfriendarray[self.currentliuyanAtIndex].messageCount+1
            
            self.myfriendCellArray["\(self.currentliuyanAtIndex)"]?.LiuyanLabel.text="\(self.myfriendarray[self.currentliuyanAtIndex].messageCount)条留言"
           // MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
    }
    //实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
    func keyboardWasShown(aNotification:NSNotification)
    {
        let info = aNotification.userInfo! as NSDictionary
        //kbSize即為鍵盤尺寸 (有width, height)
        let kbSize = (info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue.size)!  as CGSize//得到鍵盤的高度
        print("hight_hitht:\(kbSize.height)")
        print(Screen_Hight-48-kbSize.height)
        chatBarView.frame=CGRect(x: 0, y: Screen_Hight-48-kbSize.height, width: Screen_Width, height: 48)

    }
    //当键盘隐藏的时候
    func keyboardWillBeHidden(aNotification:NSNotification)
    {
        chatBarView.frame=CGRect(x: 0, y: Screen_Hight-48, width: Screen_Width, height: 48)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func toYZNews(){
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "OtherRequestNews")
        updateYZNewsRedDOt()
        self.performSegueWithIdentifier("showYZNews", sender: self)
    }
    func toAddFriends(){
        self.performSegueWithIdentifier("showAddFriends", sender: self)
    }
    func RankAndFriendclick(button:UIButton){
        if currentTabel==(button.titleLabel?.text=="我的排名" ? 0 : 1)
        {
            return
        }
        currentTabel=button.titleLabel?.text=="我的排名" ? 0 : 1
        if currentTabel==0
        {
            //self.tableView.rowHeight = 200
            NavTitleView.bottomLeft.hidden=false
            NavTitleView.bottomRight.hidden=true
            NavTitleView.MyRankButton.setTitleColor(NavTitleView.color_select, forState: .Normal)
            NavTitleView.MyFriendsButton.setTitleColor(NavTitleView.color_normol, forState: .Normal)
            RankView.hidden=false
            currentliuyanAtIndex = -1
            self.tableView.reloadData()
        }
        else
        {
            //self.tableView.rowHeight = 65
            NavTitleView.bottomLeft.hidden=true
            NavTitleView.bottomRight.hidden=false
            NavTitleView.MyRankButton.setTitleColor(NavTitleView.color_normol, forState: .Normal)
            NavTitleView.MyFriendsButton.setTitleColor(NavTitleView.color_select, forState: .Normal)
            RankView.hidden=true
            self.tableView.reloadData()
        }
        
        
    }
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let liuyanCount=(NSUserDefaults.standardUserDefaults().objectForKey("NewMessageCount") != nil) ? NSUserDefaults.standardUserDefaults().objectForKey("NewMessageCount"):0
        NavTitleView.friendBadge.hidden=(liuyanCount as! Int)>0 ? false:true
    
        currentTabel==1
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        currentliuyanAtIndex = -1
    }
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 65
            
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return myfriendCellArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //好友列表
        return myfriendCellArray["\(indexPath.section)"]!
        
        
    }
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentTabel==1
        {
            print(currentliuyanAtIndex)
            print(indexPath.section)
            if currentliuyanAtIndex==indexPath.section
            {
                currentliuyanAtIndex = -1
            }
            else
            {
                currentliuyanAtIndex=indexPath.section
                getLiuYan(friendId[indexPath.section])
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if currentTabel==1&&currentliuyanAtIndex==section
        {
            return (liuyanCellViews[self.friendId[section]]! as UIView).frame.height
        }
        else
        {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return liuyanCellViews[self.friendId[section]]! as UIView
    }

    
    //取数据
    func getTXFriends(){
        let werbservice = UserInfoActionWerbService()
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.getFriendList { (data:AnyObject!, state:StatusManager!) -> Void in
            
            if state.networkStatus == kSuccessStatus
            {
                let state=data.objectForKey("state") as! Int
                if state>0
                {
                    
                    let friendcount=data.objectForKey("friendlist") as! NSMutableArray
                    print(friendcount)
                    for i in 0...(friendcount.count-1)
                    {
                        var friendstrut=myFriend()
                        friendstrut.phone=friendcount[i].objectForKey("FriendMobile")?.isKindOfClass(NSNull)==true ? "" : (friendcount[i].objectForKey("FriendMobile") as! String)
                        
                        if friendstrut.phone==get_Phone()
                        {
                            friendstrut.phone=friendcount[i].objectForKey("Mobile")?.isKindOfClass(NSNull)==true ? "" : (friendcount[i].objectForKey("Mobile") as! String)
                        }
                        friendstrut.imgUrl=friendcount[i].objectForKey("Icon")?.isKindOfClass(NSNull)==true ? "" : (friendcount[i].objectForKey("Icon") as! String)
                        friendstrut.Name=friendcount[i].objectForKey("Nickname")?.isKindOfClass(NSNull)==true ? friendstrut.phone : (friendcount[i].objectForKey("Nickname") as! String)
                        let tmpmess=friendcount[i].objectForKey("MessageCount") as! Int
                        friendstrut.messageCount=tmpmess
                        
                        self.myfriendarray.append(friendstrut)
                        //cell load
                        let cell = NSBundle.mainBundle().loadNibNamed("FriendsCell", owner: self, options: nil).last as! FriendsCell
                        cell.LiuyanLabel.text="\(friendstrut.messageCount)"+loadLanguage("条留言")
                        cell.Name.text=friendstrut.Name
                        if friendstrut.imgUrl != ""
                        {
                            cell.headImg.image=UIImage(data: NSData(contentsOfURL: NSURL(string: friendstrut.imgUrl)!)!)
                        }
                        else
                        {
                            cell.headImg.image=UIImage(named: "DefaultHeadImage")
                        }
            
                        //---------------留言-------------
                        let tmpid=friendcount[i].objectForKey("CreateBy") as! String
            
                        if tmpid==self.myUserId
                        {
                          self.friendId.append(friendcount[i].objectForKey("ModifyBy") as! String)
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
                        cell.selectionStyle=UITableViewCellSelectionStyle.None
                        self.myfriendCellArray["\(i)"]=cell
                       
                    }
                    self.tableView.reloadData()

                }
            }
            
        }     
        
    }
    
    func getMessCellView(tmplength:Int,messcontent:String,messtime:String)->UIView
    {
        
        let messcellView=UIView()
        let messtextLabel=UILabel(frame: CGRect(x: 16, y: 0, width: Screen_Width-110, height: 20))
        messtextLabel.font=UIFont.systemFontOfSize(14)
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

        let tmpsize=messtextLabel.sizeThatFits(CGSizeZero)
        let lineCount=Int(tmpsize.width)/Int(Screen_Width-110)+((Int(tmpsize.width)%Int(Screen_Width-110))>0 ? 1:0)
        let tmpHeight=CGFloat(lineCount*20)>100 ? 100:CGFloat(lineCount*20)
        messtextLabel.frame=CGRect(x: 16, y: 0, width: messtextLabel.frame.width, height: tmpHeight)
        let messTimeLabel=UILabel(frame: CGRect(x: Screen_Width-86, y: 0, width: 70, height: 20))
        //messTimeLabel.backgroundColor=UIColor.redColor()
        messTimeLabel.font=UIFont.systemFontOfSize(11)
        messTimeLabel.text=messtime
        messTimeLabel.textAlignment=NSTextAlignment.Right
        messcellView.addSubview(messTimeLabel)
        messcellView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: tmpHeight)
        return messcellView
    }
    func getLiuYan(otherid:String)
    {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "NewMessageCount")
        NavTitleView.friendBadge.hidden=true
        let werbservice = UserInfoActionWerbService()
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.GetHistoryMessage(otherid) { (data:AnyObject!, state:StatusManager!) -> Void in
            if state.networkStatus == kSuccessStatus
            {
                if data==nil
                {
                    return
                }
                let state=data.objectForKey("state") as! Int
                if state>0
                {
                    let liuyanArray=data.objectForKey("data")  as! NSMutableArray
                    print(liuyanArray)
                    let tmpliuyanView=UIView()
                    tmpliuyanView.backgroundColor=UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
                    var tmpMess_y:CGFloat=10
                    
                    for i in 0...(liuyanArray.count-1)
                    {
                        let liuyanData = liuyanArray.objectAtIndex(i) as! NSDictionary
                        var messstring=liuyanData.objectForKey("message") as! String
                        let sendid=liuyanData.objectForKey("senduserid") as! String
                        var sendNameCount=0
                        if sendid==self.myUserId
                        {
                            sendNameCount="我 说: ".characters.count
                            messstring=loadLanguage("我 说: ")+messstring
                        }
                        else
                        {
                            let othername=liuyanData.objectForKey("Nickname")!.isKindOfClass(NSNull) ? "无名":(liuyanData.objectForKey("Nickname") as! String)
                            sendNameCount=(othername+" 说: ").characters.count
                            messstring=othername+loadLanguage(" 说: ")+messstring
                        }
                        
                        //时间
                        let messtime=liuyanData.objectForKey("stime") as! NSString
                        let needtime=dateStampToString(messtime, format: "dd日hh:mm")
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
    func ToTDS(button:UIButton)
    {
        RankDeviceType=myrankarray[button.tag].type
        self.performSegueWithIdentifier("showTDS", sender: self)
    }
    func LookZanMe(button:UIButton)
    {
        RankDeviceType=myrankarray[button.tag].type
        self.performSegueWithIdentifier("showZanMe", sender: self)
    }
    func getTDSRanks(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerDevice/GetRankNotify"
        print(url)
        let params:NSDictionary = ["usertoken":get_UserToken()]
        manager.POST(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                print(responseObject)
                let state=responseObject.objectForKey("state") as! Int
                //var rankcount:NSMutableArray!
                if state>0
                {
                    let rankcount=responseObject.objectForKey("data") as! NSMutableArray
                    for i in 0..<rankcount.count
                    {
                        var rankstrut=myRankstruct()
                        let tmprankData=rankcount.objectAtIndex(i) as! NSDictionary
                        rankstrut.rank="\(tmprankData.objectForKey("rank") as! Int)"
                        rankstrut.max="\(tmprankData.objectForKey("max") as! Int)"
                        rankstrut.zanCount="\(tmprankData.objectForKey("likenumaber") as! Int)"
                        rankstrut.type=tmprankData.objectForKey("type") as! String
                        
                        let tmptime=tmprankData.objectForKey("notime") as! NSString
                        
                        let tmptime1=dateStampToString(tmptime, format: "MM月dd日")
                        
                        rankstrut.time=tmptime1 as String
                        rankstrut.Nickname=tmprankData.objectForKey("Nickname")?.isKindOfClass(NSNull)==true ? "" : (tmprankData.objectForKey("Nickname") as! String)
                        rankstrut.Icon=tmprankData.objectForKey("Icon")?.isKindOfClass(NSNull)==true ? "" : (tmprankData.objectForKey("Icon") as! String)
                        print(rankstrut.Icon)
                        self.myrankarray.append(rankstrut)
                        let tableCell=self.getTdsRankCell(rankstrut,index: i)
                        tableCell.frame=CGRect(x: 0, y: CGFloat(i*200), width: Screen_Width, height: 200)
                        self.RankView.addSubview(tableCell)
                        
                        
                        
                    }
                    
                    self.RankView.contentSize=CGSize(width: 0, height: (CGFloat(rankcount.count*200)<(Screen_Hight-64) ? (Screen_Hight-64): CGFloat(rankcount.count*200)))
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        
        
        
    }
    
    func getTdsRankCell(tmpRank:myRankstruct,index:Int)->MyRankTableViewCell
    {
        let TdsRankcell=NSBundle.mainBundle().loadNibNamed("MyRankTableViewCell", owner: nil, options: nil).last as! MyRankTableViewCell
        
        TdsRankcell.ToTDSButton.addTarget(self, action: #selector(ToTDS), forControlEvents: .TouchUpInside)
        TdsRankcell.LookZanMeButton.addTarget(self, action: #selector(LookZanMe), forControlEvents: .TouchUpInside)
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
           
            TdsRankcell.rankHead.sd_setImageWithURL(NSURL(string: tmpRank.Icon), placeholderImage: UIImage(named: "DefaultHeadImage"), completed: { (img:UIImage!, err:NSError!, sd:SDImageCacheType, url:NSURL!) -> Void in
                TdsRankcell.rankHead.image=img
            })         }
        
        TdsRankcell.selectionStyle=UITableViewCellSelectionStyle.None
        return TdsRankcell
    }

    
   
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="showTDS"
        {
            let page=segue.destinationViewController as! My_TDSTableViewController
            page.deviceTypezb=RankDeviceType
            
        }
        if segue.identifier=="showZanMe"
        {
            let page=segue.destinationViewController as! ZanMeTableViewController
            page.deviceType=RankDeviceType
        }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

    
}
