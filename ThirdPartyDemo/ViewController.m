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
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "AppDelegate.h"
#import "UIAlertView+WX.h"
#import <WXApiObject.h>

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

- (IBAction)sinaShareButtonClicked:(UIButton *)sender {
    _messageObject = [self messageToShare];
    [self messageShare];
}

- (IBAction)QQShareButtonClicked:(UIButton *)sender {
    NSURL *previewURL = [NSURL URLWithString:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
    NSURL* url = [NSURL URLWithString:@"http://sports.qq.com/a/20120510/000650.htm"];
    NSString *title = @"天公作美伦敦奥运圣火点燃成功 火炬传递开启";
    NSString *description = @"腾讯体育讯 当地时间5月10日中午，阳光和全世界的目光聚焦于希腊最高女祭司手中的火炬上，5秒钟内世界屏住呼吸。火焰骤然升腾的瞬间，古老的号角声随之从赫拉神庙传出——第30届伦敦夏季奥运会圣火在古奥林匹亚遗址点燃。取火仪式前，国际奥委会主席罗格、希腊奥委会主席卡普拉洛斯和伦敦奥组委主席塞巴斯蒂安-科互赠礼物，男祭司继北京奥运会后，再度出现在采火仪式中。";
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:description previewImageURL:previewURL];
    
    
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
//    NSData* data = [NSData dataWithContentsOfFile:path];
//    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:description previewImageData:data];

//    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:description];
//    txtObj.shareDestType = ShareDestTypeQQ;
//    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];

    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    img.shareDestType = ShareDestTypeQQ;
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
}


- (IBAction)wechatShareButtonClicked:(UIButton *)sender {
    NSString *urlString = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    NSString *tagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    NSString *title = @"专访张小龙：产品之上的世界观";
    NSString *description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    UIImage *thumbImage = [UIImage imageNamed:@"res2.png"];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:kLinkTitle
//                                                   Description:kLinkDescription
//                                                        Object:ext
//                                                    MessageExt:nil
//                                                 MessageAction:nil
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:kLinkTagName];
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneSession;
    if (req.bText)
        req.text = nil;
    else
        req.message = message;
    [WXApi sendReq:req];
}



- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        case EQQAPITIMNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
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
