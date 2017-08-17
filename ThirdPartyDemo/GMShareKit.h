//
//  GMShareKit.h
//  ThirdPartyDemo
//
//  Created by licong on 2017/8/2.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, GMSharePlatformType) {
    GMSharePlatformQQ               =  0,
    GMSharePlatformWechat           =  1,
    GMSharePlatformSina             =  2
};

/**
 *  导入原平台SDK回调处理器
 *
 *  @param platformType 需要导入原平台SDK的平台类型
 */
typedef void(^GMShareImportHandler) (GMSharePlatformType platformType);

typedef void(^GMShareConfigurationHandler) (GMSharePlatformType platformType, NSMutableDictionary *appInfo);

@interface GMShareKit : NSObject
+ (void)registerActivePlatforms:(NSArray *)activePlatforms
                       onImport:(GMShareImportHandler)importHandler
                onConfiguration:(GMShareConfigurationHandler)configurationHandler;
@end
