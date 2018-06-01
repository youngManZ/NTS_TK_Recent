//
//  RecentTool.m
//  NTS_TK_Recent
//
//  Created by nrh on 2018/5/31.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "RecentTool.h"
#import <sqlite3.h>
#import "RecentCallObject.h"

@implementation RecentTool

+ (void)createDatabaseDirectoryWithUsername:(NSString *)username {
    if (!username || username.length == 0) {
        return;
    }
    //创建信息数据库表
    sqlite3 *database;
    NSString *documentsDirectory = [self defaultUserDataPathWithUsername:username];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user.sql"];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        char *errmsg;
        const char *createtable = "CREATE TABLE IF NOT EXISTS recentcalls (id INTEGER PRIMARY KEY AUTOINCREMENT,date double, name varchar(50), number varchar(50), count varchar(50), type varchar(50), uid varchar(50), identifier varchar(50), finalData double, address varchar(50))";
        if (sqlite3_exec(database, createtable, NULL, NULL, &errmsg) == SQLITE_OK) {
            NSLog(@"创建数据库成功");
        }
    }
    sqlite3_close(database);
}

+ (NSString *)defaultUserDataPathWithUsername:(NSString *)username{
    
    if (!username || username.length == 0) {
        return NSTemporaryDirectory();
    }
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, username];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filepath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES)) {
        [fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filepath;
}

+ (NSArray *)readRecentCallArrayWithUsername:(NSString *)username {
    sqlite3 *database;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *documentsDirectory = [self defaultUserDataPathWithUsername:username];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user.sql"];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        //获取通话记录数据
        const char *callSql = "SELECT id FROM recentcalls ORDER BY date DESC";
        sqlite3_stmt *callStatement;
        if (sqlite3_prepare_v2(database, callSql, -1, &callStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(callStatement) == SQLITE_ROW)
            {
                int primaryKey = sqlite3_column_int(callStatement, 0);
                RecentCallObject *call = [[RecentCallObject alloc] initWithPrimaryKey:primaryKey database:database];
                [array addObject:call];
            }
        }else {
            NSLog(@"-----打开数据库失败");
        }
        sqlite3_finalize(callStatement);
    }
    else{
        sqlite3_close(database);
    }
    return [array copy];
}

@end
