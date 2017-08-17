//
//  GMShareKit.m
//  ThirdPartyDemo
//
//  Created by licong on 2017/8/2.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "GMShareKit.h"

@implementation GMShareKit

+ (void)registerActivePlatforms:(NSArray *)activePlatforms
                       onImport:(GMShareImportHandler)importHandler
                onConfiguration:(GMShareConfigurationHandler)configurationHandler{
    for (NSNumber * platform in activePlatforms) {
        GMSharePlatformType type = (GMSharePlatformType)platform.integerValue;
        importHandler(type);
        configurationHandler(type,[@{@"":@""} mutableCopy]);
    }
}

@end
