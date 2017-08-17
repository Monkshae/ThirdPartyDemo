//
//  ViewController.m
//  ThirdPartyDemo
//
//  Created by licong on 2017/7/31.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ViewController.h"
#import "WeiboSDK.h"
#import "GMKey.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "AppDelegate.h"
#import "UIAlertView+WX.h"


@interface ViewController ()<WBMediaTransferProtocol>
@property (nonatomic, strong) WBMessageObject *messageObject;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sinaButtonClicked:(UIButton *)sender {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINAWEIBO_REDIRECTURI;
    //http://open.weibo.com/wiki/Scope
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (IBAction)qqButtonClicked:(UIButton *)sender {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    
    [[AppDelegate shareInstance].oauth setAuthShareType: AuthShareType_QQ];
    [[AppDelegate shareInstance].oauth authorize:permissions inSafari:NO];
}


- (IBAction)wechatButtonClicked:(UIButton *)sender {

   // 构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)messageShare{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SINAWEIBO_REDIRECTURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:_messageObject authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


- (IBAction)sinaShareButtonClicked:(UIButton *)sender {
    _messageObject = [self messageToShare];
    [self messageShare];
}


- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"测试通过WeiboSDK发送文字到微博!@%d",arc4random()];
    return message;
}

#pragma mark -- WBMediaTransferProtocol
-(void)wbsdk_TransferDidReceiveObject:(id)object
{
    [self messageShare];
}

-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error
{

}


@end
