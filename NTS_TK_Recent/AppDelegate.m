//
//  AppDelegate.m
//  NTS_TK_Recent
//
//  Created by nrh on 2018/5/31.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "AppDelegate.h"
#import "RecentCallObject.h"
#import "RecentTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 判断数据库的创建
    [RecentTool createDatabaseDirectoryWithUsername:@"18981204102"];
    
    // 测试添加通话记录
    for (int i = 0; i < 5; i++) {
        RecentCallObject *object = [[RecentCallObject alloc] init];
        object.callName = [NSString stringWithFormat:@"测试数据%d",i];
        object.callNumber = [NSString stringWithFormat:@"%ld",18981204102 + i];
        object.callDate = [NSDate date];
        object.callFinalData = [NSDate date];
        object.callId = [NSNumber numberWithInt:i];
        sqlite3 *database;
        NSString *documentsDirectory = [RecentTool defaultUserDataPathWithUsername:@"18981204102"];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user.sql"];
        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
        {
            [object changeDataBase:database username:@"18981204102"];
        }
        NSArray *resultArray = [object readThisIdRecentCountArrayWithUsername:@"18981204102"];
        NSLog(@"----->条数%lu",(unsigned long)resultArray.count);
    }
    
    // 测试读取数据
    NSArray *array = [RecentTool readRecentCallArrayWithUsername:@"18981204102"];
    
    NSLog(@"----->通话记录的条数%lu",(unsigned long)array.count);
    
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


@end
