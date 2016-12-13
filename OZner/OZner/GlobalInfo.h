//
//  GlobalInfo.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-13.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

/****************************************正式服务器*****************************************************/
//外网服务器
#define HTTP_ADDRESS       @"https://app.joyro.com.cn/"//"http://ozner.bynear.cn/"

//登录 - 手机号
#define WERB_URL_LOGIN                          @"OznerServer/Login"
//登录 - 邮箱
#define EMAIL_URL_LOGIN                         @"/OznerServer/MailLogin"

//  当前登陆方式
#define CURRENT_LOGIN_STYLE                     @"currentLoginStyle"
#define LoginByPhone                            @"LoginByPhone"
#define LoginByEmail                            @"LoginByEmail"

//添加设备
#define WERB_URL_ADD_DEVICE                     @"OznerServer/AddDevice"
//获取设备列表
#define WERB_URL_GET_DEVICE_LIST                @"OznerServer/GetDeviceList"
//更新设备
#define WERB_URL_UPDATE_DEVICE                  @"OznerServer/UpdateDevice"
//删除设备
#define WERB_URL_DELETE_DEVICE                  @"OznerServer/DeleteDevice"
//获取饮水量传感器的值
#define WERB_URL_VOLUME_SENSOR                  @"OznerDevice/VolumeSensor"
//获取传感器的值
#define WERB_URL_TDS_SENSOR                     @"OznerDevice/TDSSensor"
//滤芯设备使用时间
#define WERB_URL_FILTER_SERVICE                 @"OznerDevice/FilterService"
//更新滤芯服务时间
#define WERB_URL_Renew_Filter_Time              @"OznerDevice/RenewFilterTime"
//获取好友当天的排名详情
#define WERB_URL_VOLUME_FRIEND_RANK             @"OznerDevice/VolumeFriendRank"
//获取城市天气
#define WERB_URL_GET_WHEATHER                   @"OznerServer/GetWeather"
//获取用户信息
#define WERB_URL_GET_USER_INFO                  @"OznerServer/GetUserInfo"
//更新用户信息
#define WERB_URL_UPDATE_USERINFO                @"OznerServer/UpdateUserInfo"
//获取用户昵称图片信息
#define WERB_URL_NICK_IMG_INFO                  @"OznerServer/GetUserNickImage"
//获取语音验证码
#define Get_Voice_Phone_Code                    @"OznerServer/GetVoicePhoneCode"
//百度推送
#define WERB_URL_BAI_DU_PUSH                    @"OznerServer/BaiduPush"
//提交意见
#define WERB_URL_SUBMIT_OPTION                  @"OznerServer/SubmitOpinion"
//搜索好友
#define WERB_URL_SEARCH_FRIEND                  @"OznerServer/SearchFriend"
//添加好友
#define WERB_URL_ADD_FRIEND                     @"OznerServer/AddFriend"
//获取用户验证信息
#define WERB_URL_GET_USER_VERIF_MESSAGE         @"OznerServer/GetUserVerifMessage"
//接受验证请求
#define WERB_URL_ACCEPT_USER_VERIFY             @"OznerServer/AcceptUserVerif"
//获取好友列表
#define WERB_URL_FRIEND_LIST                    @"OznerServer/GetFriendList"

//朋友圈内的饮水量实时排名
#define WERB_URL_Volume_Friend_Rank             @"OznerDevice/VolumeFriendRank"
//对其他用户点赞
#define WERB_URL_Like_Other_User                @"OznerDevice/LikeOtherUser"
//获取未读排名通知
#define WERB_URL_Get_Rank_Notify                @"OznerDevice/GetRankNotify"
//朋友圈内的TDS实时排名
#define WERB_URL_Tds_Friend_Rank                @"OznerDevice/TdsFriendRank"

//获取留言历史纪录
#define WERB_URL_Get_History_Message            @"OznerDevice/GetHistoryMessage"
//发送留言消息
#define WERB_URL_Leave_Message                  @"OznerDevice/LeaveMessage"
//赞我的人
#define WERB_URL_Who_Like_Me                    @"OznerDevice/WhoLikeMe"
//获取水机周月TDS分布
#define Get_Device_Tds_FenBu                    @"OznerServer/GetDeviceTdsFenBu"
//获取水机滤芯服务到期时间
#define Get_Machine_LifeOut_Time                @"OznerDevice/GetMachineLifeOutTime"
//检查水机的功能种类
#define Get_Machine_Type                        @"OznerServer/GetMachineType"
//更新补水仪的数值
#define Update_BuShuiYi_Number                  @"/OznerDevice/UpdateBuShuiYiNumber"
//获取周月补水仪器数值分布
#define Get_BuShui_FenBu                        @"/OznerServer/GetBuShuiFenBu"
////GetPost/OznerDevice/GetTimesCountBuShui获取补水仪检测次数
#define Get_TimesCount_BuShui                        @"/OznerDevice/GetTimesCountBuShui"

//商城
#define MALL_URL                                @"http://www.oznerwater.com/lktnew/wap/mall/mallHomePage.aspx"

#define MY_HUI_YUAN       @"6201507a981afb4ZZ6ac698ed3dd86e1a76a3bb051703"

