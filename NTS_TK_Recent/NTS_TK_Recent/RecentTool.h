//
//  RecentTool.h
//  NTS_TK_Recent
//
//  Created by nrh on 2018/5/31.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentTool : NSObject

//创建数据库
+ (void)createDatabaseDirectoryWithUsername : (NSString *) username;

//获取对应的用户数据地址
+ (NSString *)defaultUserDataPathWithUsername : (NSString *) username;

//读取通话记录
+ (NSArray *) readRecentCallArrayWithUsername : (NSString *) username;

@end
