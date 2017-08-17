//
//  AppDelegate.m
//  ThirdPartyDemo
//
//  Created by licong on 2017/7/31.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "AppDelegate.h"
#import "GMKey.h"
#import "UIAlertView+WX.h"
@interface AppDelegate ()

@end

@implementation AppDelegate



+ (instancetype)shareInstance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SINAWEIBO_APPID];
    
    _oauth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
    
    [WXApi registerApp:WEIXIN_APPID enableMTA:YES];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *string = url.absoluteString;
    if ([string hasPrefix:[NSString stringWithFormat:@"wb%@",SINAWEIBO_APPID]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if([string hasPrefix:[NSString stringWithFormat:@"tencent%@",QQ_APPID]]) {
        return [TencentOAuth HandleOpenURL:url];
    } else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *string = url.absoluteString;
    if ([string hasPrefix:[NSString stringWithFormat:@"wb%@",SINAWEIBO_APPID]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if([string hasPrefix:[NSString stringWithFormat:@"tencent%@",QQ_APPID]]) {
        return [TencentOAuth HandleOpenURL:url];
    } else{
        return  [WXApi handleOpenURL:url delegate:self];;
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *string = url.absoluteString;
    if ([string hasPrefix:[NSString stringWithFormat:@"wb%@",SINAWEIBO_APPID]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if([string hasPrefix:[NSString stringWithFormat:@"tencent%@",QQ_APPID]]) {
        return [TencentOAuth HandleOpenURL:url];
    } else{
        return  [WXApi handleOpenURL:url delegate:self];;
    }
}


#pragma mark -- WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [alert show];
    }
}


#pragma mark --  TencentSessionDelegate

- (void)tencentDidLogin {
    if (![_oauth getUserInfo]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [_oauth RequestUnionId];
}


- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

- (void)tencentDidNotNetWork{
    
}


- (void)didGetUnionID{
    NSLog(@"unionId = %@",_oauth.unionid);
}


- (void)getUserInfoResponse:(APIResponse *)response {
    NSLog(@"jsonResponse = %@",response.jsonResponse);
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions
{
    return YES;
}


- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth
{
    return YES;
}


- (void) onResp:(BaseResp *)resp {
    
    if([resp isKindOfClass:[SendAuthResp class]])
    {

    }


}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[SendAuthResp class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
        [UIAlertView showWithTitle:strTitle message:strMsg sure:^(UIAlertView *alertView, NSString *text) {
       
        }];
    }
}

@end
