//
//  AppDelegate.h
//  ThirdPartyDemo
//
//  Created by licong on 2017/7/31.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, TencentSessionDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) TencentOAuth * oauth;
+ (instancetype)shareInstance;

@end

