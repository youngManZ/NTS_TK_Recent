//
//  RecentCallObject.h
//  XinweiPhone
//
//  Created by wjj on 14-3-11.
//  Copyright (c) 2014年 Lance. All rights reserved.
//

/**
 // 测试添加通话记录
 for (int i = 0; i < 5; i++) {
 RecentCallObject *object = [[RecentCallObject alloc] init];
 object.callName = [NSString stringWithFormat:@"测试数据%d",i];
 object.callNumber = [NSString stringWithFormat:@"%ld",18981204102 + i];
 object.callDate = [NSDate date];
 object.callFinalData = [NSDate date];
 object.callId = [NSNumber numberWithInt:i];
 sqlite3 *database;
 NSString *documentsDirectory = [JMTool defaultUserDataPath];
 NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user.sql"];
 if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
 {
 [object changeDataBase:database];
 }
 NSArray *resultArray = [object readThisIdRecentCountArray];
 NSLog(@"----->条数%lu",(unsigned long)resultArray.count);
 }
 
 // 测试读取数据
 NSArray *array = [JMTool readRecentCallArray];
 
 NSLog(@"----->通话记录的条数%lu",(unsigned long)array.count);
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <AddressBook/AddressBook.h>

typedef NS_ENUM(NSInteger, CallType) {
    Undefined = 0,
    Dialled,
    Received,
    Missed
};


@interface RecentCallObject : NSObject<NSCoding>


@property (nonatomic,strong)NSNumber *callId;
@property (nonatomic,strong)NSString *callName;
@property (nonatomic,strong)NSString *callNumber;//电话
@property (nonatomic,strong)NSDate   *callDate;//通话开始时间
@property (nonatomic,assign)NSInteger callCount;//拨打次数
@property (nonatomic,strong)NSDate   *callFinalData;//通话结束时间
@property (nonatomic,strong)NSString *callNumberAddStr;//拨打号码的归属地
@property (nonatomic,assign)  CallType   type;
@property (nonatomic,assign)  ABRecordID uid;
@property (nonatomic,assign)  ABMultiValueIdentifier identifier;
@property (nonatomic,assign)  BOOL                   dirty;

/**
 直接使用这个方法更新数据，如果没有，会直接插入数据的操作
 */
- (void)changeDataBase:(sqlite3 *)db username : (NSString *) useranme;

/**
 不用这个方法初始化，直接用init初始化
 */
- (id)initWithPrimaryKey:(int)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)db username : (NSString *) useranme;
+ (void)updateCall:(RecentCallObject *)call Database:(sqlite3 *)db username : (NSString *) useranme;
+ (void)deleteCall:(RecentCallObject *)call fromDatabase:(sqlite3 *)db;

/**
 读取当前这条通话记录下的所有通话次数信息，返回nil表示没有
 */
- (NSArray *) readThisIdRecentCountArrayWithUsername : (NSString *) username;

/**
 在执行完更新或添加通话记录成功以后，会对id_number.plist这个文件进行解析，如果有，就添加，如果没有，就创建，这个文件读取之后，是个数据，就是所有这个号码打过的记录
 */
+ (void) addRecentCallToArrayWithRecentCall : (RecentCallObject *) call username : (NSString *) username;

- (NSString *)displayName;

@end
