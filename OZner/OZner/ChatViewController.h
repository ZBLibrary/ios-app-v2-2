//
//  ChatViewController.h
//  XMChatControllerExample
//
//  Created by shscce on 15/9/3.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMMessage.h"

@interface ChatViewController : UIViewController

@property (copy, nonatomic) NSString *chatterName /**< 客服名字 */;
@property (copy, nonatomic) NSString *chatterThumb /**< 客服头像 */;
@property (copy, nonatomic) NSString *sendFailThumb /**< 发送失败头像 */;




//let appid: String = "hzapi"
//let appsecret: String = "8af0134asdffe12"

- (instancetype)initWithChatType:(XMMessageChatType)messageChatType;

@end
