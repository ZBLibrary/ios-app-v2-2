//
//  ChatViewController.m
//  XMChatControllerExample
//
//  Created by shscce on 15/9/3.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "ChatViewController.h"

#import "XMSystemMessageCell.h"
#import "XMTextMessageCell.h"
#import "XMImageMessageCell.h"
#import "XMLocationMessageCell.h"
#import "XMVoiceMessageCell.h"
#import "XMChatBar.h"
#import "OZner-swift.h"
#import "XMAVAudioPlayer.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "BPush.h"
#import "AFNetworking.h"
#import "NSStringAdditions.h"
#import "UIImageView+WebCache.h"

//UITabBar *NewTabBar;
@interface ChatViewController ()<XMMessageDelegate,XMChatBarDelegate,XMAVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource>
//zb
//咨询
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) XMChatBar *chatBar;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (weak, nonatomic) NSIndexPath *voicePlayingIndexPath; /**< 正在播放的列表,用来标注正在播放的语音cell,修复复用产生的状态不正确问题 */

@property (assign, nonatomic) XMMessageChatType messageChatType;
@end
NSString *appid_News=@"hzapi"; /**< app 的ID */
NSString *appsecret_News =@"8af0134asdffe12";
/**idsecret*/
NSString *appidandsecret=@"&appid=hzapi&appsecret=8af0134asdffe12";
NSString *NEWS_URL=@"http://dkf.ozner.net/api";//接口头地址
NSString *acsstoken_News;// 接口 token
NSString *sign_News;// 签名

int customerid_News = 0;//会员id
int ChannelID_News = 4;//4 ===>ios
NSString * deviceid_News;//百度推送设备号
int ct_id=0;//咨询类别 0
NSString * kSelfName ;//会员名字
NSString * kSelfThumb  ;//会员头像



@implementation ChatViewController


- (instancetype)initWithChatType:(XMMessageChatType)messageChatType{
    if ([super init]) {
        self.messageChatType = 0;
        
    }
    return self;
}
//获取聊天token
-(void) GetAccesstoken{
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* getpar = [@"appid=" stringByAppendingString:appid_News];
    getpar=[getpar stringByAppendingString:@"&appsecret="];
    getpar=[getpar stringByAppendingString:appsecret_News];
    sign_News = [getpar stringFromMD5];
    
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/token.ashx"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appid_News,@"appid", appsecret_News,@"appsecret",sign_News,@"sign", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Token: %@", responseObject);
        acsstoken_News = [[responseObject objectForKey:@"result"] objectForKey:@"access_token"];
        [self GetUserInfoFunc];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        NSLog(@"Error: %@", error);
    }];
}
//获取用户信息接口 获取custom_ID
-(void) GetUserInfoFunc{

    id tmpphone=[[NSUserDefaults standardUserDefaults] objectForKey:@"Phone"];
    if (tmpphone==nil||[tmpphone isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"ok", nil];
        [alert show];
        return;
    }
    sign_News=[@"access_token=" stringByAppendingString:acsstoken_News];
    sign_News=[sign_News stringByAppendingString:appidandsecret];
    
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/member.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:tmpphone,@"mobile", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"UserInfo: %@", responseObject);
        if ([[responseObject objectForKey:@"result"] objectForKey:@"count"]==0) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }
        else
        {
        NSDictionary* asd = [[[responseObject objectForKey:@"result"] objectForKey:@"list"] objectAtIndex:0];
        customerid_News=[[asd objectForKey:@"customer_id"] intValue];
        kSelfName=[asd objectForKey:@"customer_name"];
        [self userLoginFunc];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}
//用户上线
-(void) userLoginFunc{
    if (deviceid_News==nil) {
        NSLog(@"设备号为空：%@",deviceid_News);
        return;
    }
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/customerlogin.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:customerid_News], @"customer_id",deviceid_News,@"device_id",[NSNumber numberWithInt:4],@"channel_id",[NSNumber numberWithInt:1],@"ct_id", nil];//
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSLog(@"params参数: %@", params);
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Login反回: %@", responseObject);
        self.chatterName=[[responseObject objectForKey:@"result"] objectForKey:@"kfname"];
        [self GetHistoryRecordfunc];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}
//获取历史信息接口
-(void) GetHistoryRecordfunc{
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/historyrecord.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:customerid_News], @"customer_id", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"历史消息: %@", responseObject);
        NSMutableArray* responsearray=[[responseObject objectForKey:@"result"] objectForKey:@"list"];
        [self loadData:responsearray];
        [MBProgressHUD hideHUDForView:self.view animated:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

//坐席主动发起
-(void) autoLaunchFunc{
    //sign_News=[@"appid=hzapi&appsecret=8af0134asdffe12&access_token=" stringByAppendingString:acsstoken_News];
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/kfsend.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:getUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"JSON: %@", responseObject);
        //acsstoken_News = [responseObject objectForKey:@"result"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



//用户结束会话
-(void) cuskillqueuefunc{
    
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/cuskillqueue.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:customerid_News], @"customer_id", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager POST:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"=======================");//self.acsstoken_News = [responseObject objectForKey:@"access_token"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)initparams{
    
    deviceid_News = [BPush getChannelId];
    //获取用户头像
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"userinfoImg.plist"];
    //获取完整路径
   
    NSMutableDictionary* tmpData=[[NSMutableDictionary alloc] initWithContentsOfFile:filename];// (contentsOfFile: filename)
    if (tmpData!=nil&&tmpData.count>0) {
        //用户头像
        kSelfThumb=([[tmpData objectForKey:@"headimg"] containsString:@"http://"]) ? [tmpData objectForKey:@"headimg"]:@"http://img0w.pconline.com.cn/pconline/1401/15/4172339_touxiang/spcgroup/width_640,qua_30/25.jpg";;
    }else
    {
        kSelfThumb=@"http://img0w.pconline.com.cn/pconline/1401/15/4172339_touxiang/spcgroup/width_640,qua_30/25.jpg";
    }
    
    self.chatterThumb=@"HaoZeKeFuImage";//客服头像
    self.sendFailThumb=@"MessSendFail";//发送失败图标
    [self GetAccesstoken];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getKFMessAge:) name:@"receiveMessageFromKF" object:nil];
    // 敲击手势
    UITapGestureRecognizer *tapGestureRecognizer;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapzb:)];
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    self.tableView.userInteractionEnabled = YES;
}
- (void)handleTapzb:(UITapGestureRecognizer *)sender {
    //if (self.dataArray.count==0) {
        [self.chatBar endInputing];
    //}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"咨询";
    self.view.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:247/255.0f blue:254/255.f alpha:1.0f];
    //电话
    UIBarButtonItem* rightitem=[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"CallPhoneImage"]style:UIBarButtonItemStylePlain  target:self action:@selector(callKFPhone)];
    [self.navigationItem setRightBarButtonItem:rightitem];
    [[XMAVAudioPlayer sharedInstance] setDelegate:self];
    
    [self.view addSubview:self.tableView];
    self.chatBar = [[XMChatBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kMinHeight-65, self.view.frame.size.width, kMinHeight)];
    self.chatBar.delegate = self;
    [self.view addSubview:self.chatBar];
    
    self.dataArray = [NSMutableArray array];

    [self initparams];
    
  
}
- (void) callKFPhone
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008202667"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void) getKFMessAge:(NSNotification*) notification
{
    
    NSMutableDictionary* obj = [self getChatMessage1]; //获取到传递的对象
    NSLog(@"收到的消息：%@",obj);
    for (int i=0; i<obj.count; i++) {
        
         NSString* tmpmessage=[obj objectForKey:[NSString stringWithFormat:@"%d",i]];
         NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        XMTextMessage *textMessage = [XMMessage textMessage:@{@"messageTime":@(time),@"messageOwner":@(XMMessageOwnerTypeOther),@"messageText":tmpmessage}];
    
         textMessage.senderNickName = self.chatterName;
         textMessage.senderAvatarThumb = self.chatterThumb;
    
         textMessage.messageChatType = 0;
         [self.dataArray addObject:textMessage];
         
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        [self scrollToBottom];
        
    }
    
        
   


}

-(NSMutableDictionary*)getChatMessage1
{
    //NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString* tmppath = [documentsDirectory stringByAppendingPathComponent:@"ChatMessagePlist.plist"];  //
    
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithContentsOfFile:tmppath];//
    NSFileManager* fileManager = [NSFileManager defaultManager];
       if ([fileManager fileExistsAtPath:tmppath])
        {
            
            @try {
                [fileManager removeItemAtPath:tmppath error:nil];
            }
            @catch (NSException *exception) {
                
            }
            
        }else
        {
            return [NSMutableDictionary dictionaryWithCapacity:0];
        }
    return dictionary;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1];
    [[CustomTabBarView sharedCustomTabBar] showAllMyTabBar];
    [self.chatBar endInputing];
    //[[[[CustomTabBarView sharedCustomTabBar] btnMuArr] objectAtIndex:2] setBadgeValue:@"1"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XMAVAudioPlayer sharedInstance] stopSound];
    //[[[[CustomTabBarView sharedCustomTabBar] btnMuArr] objectAtIndex:2] setBadgeValue:@"2"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:[XMMessageCell cellIndetifyForMessage:self.dataArray[indexPath.row]]];
    //[self.dataArray count]
    NSLog(@"%@",self.dataArray[indexPath.row]);
    
    messageCell.backgroundColor = tableView.backgroundColor;
    messageCell.messageDelegate = self;
    [self configureCell:messageCell atIndex:indexPath];
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:[XMMessageCell cellIndetifyForMessage:self.dataArray[indexPath.row]] cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndex:indexPath];
    }];
}

- (void)configureCell:(XMMessageCell *)cell atIndex:(NSIndexPath *)indexPath{
    [cell setMessage:self.dataArray[indexPath.row]];
    if ([cell isKindOfClass:[XMVoiceMessageCell class]] && self.voicePlayingIndexPath && self.voicePlayingIndexPath.row == indexPath.row) {
        [(XMVoiceMessageCell *)cell startPlaying];
    }
}


#pragma mark - XMMessageDelegate

- (void)XMMessageBankTapped:(XMMessage *)message{
    NSLog(@"点击了空白区域");
    [self.chatBar endInputing];
}

- (void)XMMessageAvatarTapped:(XMMessage *)message{
    NSLog(@"点击了头像");
}

- (void)XMImageMessageTapped:(XMImageMessage *)imageMessage{
    NSLog(@"you tap imageMessage you can show imageBrowser");
}

//!!!修复语音播放复用问题,使用voicePlayIndexPath来
- (void)XMVoiceMessageTapped:(XMVoiceMessage *)voiceMessage voiceStatus:(id<XMVoiceMessageStatus>)voiceStatus{

    NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:(XMVoiceMessageCell *)voiceStatus];
    XMVoiceMessageCell *lastVoiceMessageCell = [self.tableView cellForRowAtIndexPath:self.voicePlayingIndexPath];
    if (lastVoiceMessageCell) {
        [lastVoiceMessageCell stopPlaying];
        [[XMAVAudioPlayer sharedInstance] stopSound];
    }
    //第一条信息为语音时导致无法播放,增加[voiceStatus isPlaying]判断
    if (currentIndexPath.row == self.voicePlayingIndexPath.row && self.voicePlayingIndexPath) {
        self.voicePlayingIndexPath = nil;
        return;
    }
    self.voicePlayingIndexPath = nil;
    [voiceStatus startPlaying];
    if (voiceMessage.voiceData) {
        [[XMAVAudioPlayer sharedInstance] playSongWithData:voiceMessage.voiceData];
    }else{
        [[XMAVAudioPlayer sharedInstance] playSongWithUrl:voiceMessage.voiceUrlString];
    }
    self.voicePlayingIndexPath = currentIndexPath;
}


#pragma mark - XMChatBarDelegate
//发送消息
- (void)chatBar:(XMChatBar *)chatBar sendMessage:(NSString *)message{
    
    XMTextMessage *textMessage = [XMMessage textMessage:@{@"messageOwner":@(XMMessageOwnerTypeSelf),@"messageTime":@([[NSDate date] timeIntervalSince1970]),@"messageText":message}];
    textMessage.senderAvatarThumb = kSelfThumb;
    textMessage.senderNickName = kSelfName;
    textMessage.messageChatType = 0;
    [self.dataArray addObject:textMessage];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self scrollToBottom];
    if (acsstoken_News==nil) {
        return;
    }
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/customermsg.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:customerid_News], @"customer_id",deviceid_News,@"device_id",[NSNumber numberWithInt:4],@"channel_id",message,@"msg", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送信息: %@", responseObject);
        if(![[responseObject objectForKey:@"msg"] isEqual:@"success"])
        {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
       
        XMTextMessage *textMessage = [XMMessage textMessage:@{@"messageOwner":@(XMMessageOwnerTypeSystem),@"messageTime":@([[NSDate date] timeIntervalSince1970]),@"messageText":@"信息发送失败!请确保网络通畅并已关注浩泽微信公众号"}];
        textMessage.senderAvatarThumb = self.sendFailThumb;
        textMessage.senderNickName = self.chatterName;
        textMessage.messageChatType = 1;
        [self.dataArray addObject:textMessage];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        [self scrollToBottom];
    }];
    
}

- (void)chatBar:(XMChatBar *)chatBar sendPictures:(NSArray *)pictures{
    if (acsstoken_News==nil) {
        return;
    }
        NSData* imgdata=UIImageJPEGRepresentation(pictures[0], 0.75);//压缩系数
        if(imgdata==nil)
        {
            imgdata=UIImagePNGRepresentation(pictures[0]);
        }
    NSString* getUrl = [NEWS_URL stringByAppendingString:@"/uploadpic.ashx?access_token="];
    getUrl=[getUrl stringByAppendingString:acsstoken_News];
    getUrl=[getUrl stringByAppendingString:@"&sign="];
    getUrl=[getUrl stringByAppendingString:[sign_News stringFromMD5]];
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:getUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgdata name:str fileName:fileName mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
         NSLog(@"responseObject: %@", responseObject);
        if ([[responseObject objectForKey:@"msg"] isEqualToString:@"success"]) {
            //图片地址转成html以消息形势发过去
            NSString *imagePathtmp=[@"<img height=\"260px\" src=\"" stringByAppendingString:[[responseObject objectForKey:@"result"] objectForKey:@"picpath"]];
            imagePathtmp=[imagePathtmp stringByAppendingString:@"\"/>"];
            [self chatBar:chatBar sendMessage:imagePathtmp];
            
        } else {
            
            NSLog(@"%@", error);
        }
    }];
    
    [uploadTask resume];
}


- (void)chatBarFrameDidChange:(XMChatBar *)chatBar frame:(CGRect)frame{
    if (frame.origin.y == self.tableView.frame.size.height) {
        return;
    }
    [UIView animateWithDuration:.3f animations:^{
        [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, frame.origin.y)];
        [self scrollToBottom];
    } completion:nil];
}

#pragma mark - XMAVAudioPlayerDelegate

- (void)audioPlayerBeginLoadVoice{
    NSLog(@"正在从网络加载录音文件");
}

- (void)audioPlayerBeginPlay{

}

- (void)audioPlayerDidFinishPlay{
    XMVoiceMessageCell *voicePlayingCell = [self.tableView cellForRowAtIndexPath:self.voicePlayingIndexPath];
    [voicePlayingCell stopPlaying];
    self.voicePlayingIndexPath = nil;
}

#pragma mark - Private Methods

- (void)loadData:(NSMutableArray *)responseMessage{

    if (acsstoken_News==nil) {
        return;
    }

    for (int i = 0 ; i < responseMessage.count; i ++) {
        NSDictionary* ItemDic =  [responseMessage objectAtIndex:i];
        NSUInteger firstMessageTime = [[ItemDic objectForKey:@"_add_timestamp"] intValue];
        int whoIssender = [[ItemDic objectForKey:@"_oper"] intValue];
        NSString* _message = [ItemDic objectForKey:@"_message"];
        switch (0) {
                //文字表情
            case 0:
            {
                XMTextMessage *textMessage = [XMMessage textMessage:@{@"messageTime":@(firstMessageTime),@"messageOwner":@(whoIssender==1 ? XMMessageOwnerTypeSelf : XMMessageOwnerTypeOther),@"messageText":_message}];
                if (textMessage.messageOwner == XMMessageOwnerTypeSelf) {
                    textMessage.senderNickName = kSelfName;
                    textMessage.senderAvatarThumb = kSelfThumb;
                }else if (textMessage.messageOwner == XMMessageOwnerTypeOther){
                    textMessage.senderNickName = self.chatterName;
                    textMessage.senderAvatarThumb = self.chatterThumb;
                }
                textMessage.messageChatType = 0;
                [self.dataArray addObject:textMessage];
            }
                break;
                //图片
            case 1:
            {
                XMImageMessage *imageMessage = [XMMessage imageMessage:@{@"messageTime":@(firstMessageTime),@"messageOwner":@(i%2==0 ? XMMessageOwnerTypeSelf : XMMessageOwnerTypeOther),@"image":[UIImage imageNamed:@"test_send"]}];
                if (imageMessage.messageOwner == XMMessageOwnerTypeSelf) {
                    imageMessage.senderNickName = kSelfName;
                    imageMessage.senderAvatarThumb = kSelfThumb;
                }else if (imageMessage.messageOwner == XMMessageOwnerTypeOther){
                    imageMessage.senderNickName = self.chatterName;
                    imageMessage.senderAvatarThumb = self.chatterThumb;
                }
                imageMessage.messageChatType = 0;
                [self.dataArray addObject:imageMessage];
            }
                break;
            
            default:
                break;
        }
    }
    
    //进行时间排序
    [self.dataArray sortUsingComparator:^NSComparisonResult(XMMessage *obj1, XMMessage  *obj2) {
        if (obj1.messageTime < obj2.messageTime) {
            return NSOrderedAscending;
        }else if (obj1.messageTime == obj2.messageTime){
            return NSOrderedSame;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    [self.tableView reloadData];
    [self scrollToBottom];
}


- (void)scrollToBottom {
    
    if (self.dataArray.count >= 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}

#pragma mark - Getters

+ (NSString *)generateRandomStr:(NSUInteger)length{
    
    NSString *sourceStr = @"0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kMinHeight-65) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:[XMSystemMessageCell class] forCellReuseIdentifier:@"XMSystemMessageCell"];
        [_tableView registerClass:[XMTextMessageCell class] forCellReuseIdentifier:@"XMTextMessageCell"];
        [_tableView registerClass:[XMImageMessageCell class] forCellReuseIdentifier:@"XMImageMessageCell"];
        //[_tableView registerClass:[XMLocationMessageCell class] forCellReuseIdentifier:@"XMLocationMessageCell"];
        //[_tableView registerClass:[XMVoiceMessageCell class] forCellReuseIdentifier:@"XMVoiceMessageCell"];
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

@end
