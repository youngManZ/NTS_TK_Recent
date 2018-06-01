//
//  RecentCallObject.m
//  XinweiPhone
//
//  Created by wjj on 14-3-11.
//  Copyright (c) 2014年 Lance. All rights reserved.
//

#import "RecentCallObject.h"
#import "AddressBookModel.h"
#import "RecentTool.h"

@implementation RecentCallObject

@synthesize type;
@synthesize identifier;
@synthesize uid;
@synthesize dirty;
@synthesize callId = _callId;
@synthesize callName = _callName;
@synthesize callNumber = _callNumber;
@synthesize callDate = _callDate;
@synthesize callCount = _callCount;

- (id)init
{
    self = [super init];
    if (self) {
        _callId = nil;
        type = Undefined;
        identifier = kABMultiValueInvalidIdentifier;
        uid = kABRecordInvalidID;
        _callName = [[NSString alloc] init];
        _callNumber = [[NSString alloc] init];
        _callDate = [[NSDate alloc] init];
        _callCount = 1;
        _callFinalData = [[NSDate alloc] init];
        _callNumberAddStr = @"未知归属地";
    }
    return self;
}
- (id)initWithPrimaryKey:(int)pk database:(sqlite3 *)db
{
    char * temp;
    self = [super init];
    if (self) {
        self.callId = [NSNumber numberWithInteger:pk];
        
        sqlite3_stmt *selectstatement;
        
        const char *sql = "SELECT date, name, number, count, type, uid, identifier,finalData,address FROM recentcalls WHERE id=?";
        if (sqlite3_prepare_v2(db, sql, -1, &selectstatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with call '%s'.", sqlite3_errmsg(db));
        }
        
        sqlite3_bind_int(selectstatement, 1, pk);
        if (sqlite3_step(selectstatement) == SQLITE_ROW)
        {
            self.callDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectstatement, 0)];
            temp = (char *)sqlite3_column_text(selectstatement, 1);
            if (temp == nil) {
                self.callName = @"未知";
            }else {
                self.callName = [NSString stringWithUTF8String:temp];
            }
            temp = (char *)sqlite3_column_text(selectstatement, 2);
            if (temp == nil) {
                self.callNumber = @"";
            }else {
                self.callNumber = [NSString stringWithUTF8String:temp];
            }
            self.callCount = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstatement, 3)] integerValue];
            self.type = sqlite3_column_int(selectstatement, 4);
            self.uid = sqlite3_column_int(selectstatement, 5);
            self.identifier = sqlite3_column_int(selectstatement, 6);
            self.callFinalData = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectstatement, 7)];
            temp = (char *)sqlite3_column_text(selectstatement, 8);
            if (temp == nil) {
                self.callNumberAddStr = @"未知归属地";
            }else {
                self.callNumberAddStr = [NSString stringWithUTF8String:temp];
            }
        }
        else{
            _callDate = nil;
            _callFinalData = nil;
            _callName = nil;
            _callNumber = nil;
            _callCount = 1;
            self.type = 0;
            self.identifier = kABMultiValueInvalidIdentifier;
            self.uid = kABRecordInvalidID;
            self.callNumberAddStr = @"未知归属地";
        }
        sqlite3_finalize(selectstatement);
    }
    return self;
}

- (void)setCallNumber:(NSString *)callNumber {

    _callNumber = callNumber;
    if (callNumber && callNumber.length > 0) {
        NSString *strAddStr = [[AddressBookModel sharedManager] attributionWithPhoneNumber:callNumber];
        if (strAddStr.length == 0) {
            _callNumberAddStr = @"未知归属地";
        }else {
            
            _callNumberAddStr = [NSString stringWithFormat:@"%@",strAddStr];
        }
    }else {
    
        _callNumberAddStr = @"未知归属地";
    }
}

- (void)changeDataBase:(sqlite3 *)db username:(NSString *)useranme{
    
    if ([self selectDatabase:db]) {
        [RecentCallObject updateCall:self Database:db username:useranme];
    }
    else [self insertIntoDatabase:db username:useranme];
}

- (BOOL)selectDatabase:(sqlite3 *)db {
    
    sqlite3_stmt *selectstatement;
    
    const char *sql = "SELECT id, date, name, number, count FROM recentcalls WHERE number=?";
    if (sqlite3_prepare_v2(db, sql, -1, &selectstatement, NULL) != SQLITE_OK)
    {
        /*
        NSAssert1(0, @"Error: failed to prepare statement with call '%s'.", sqlite3_errmsg(db));
         */
    }
    
    sqlite3_bind_text(selectstatement, 1, [self.callNumber UTF8String], -1, SQLITE_TRANSIENT);
    
    BOOL selectResult = NO;
    if (sqlite3_step(selectstatement) == SQLITE_ROW)
    {
        
        self.callId =  @(sqlite3_column_int(selectstatement, 0));
        //        self.callDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectstatement, 1)];
        //        self.callName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstatement, 2)];
        //        self.callNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstatement, 3)];
        self.callCount = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstatement, 4)] integerValue];
        selectResult = YES;
    }
    else{
        selectResult = NO;
    }
    
    sqlite3_finalize(selectstatement);
    
    return selectResult;
}

- (void)insertIntoDatabase:(sqlite3 *)db username:(NSString *)useranme{
    _callCount = 1;
    sqlite3_stmt *insertstatement;
    
    static char* sql = "INSERT INTO recentcalls(date, name, number, count, type, uid, identifier,finalData,address) VALUES (?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(db, sql, -1, &insertstatement, NULL) != SQLITE_OK) {
//        NSAssert1(0, @"Error: failed to insert into the database with call '%s'.", sqlite3_errmsg(db));
    }
    
    sqlite3_bind_double(insertstatement, 1, [_callDate timeIntervalSince1970]);
    sqlite3_bind_text(insertstatement, 2, [_callName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertstatement, 3, [_callNumber UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertstatement, 4, [[NSString stringWithFormat:@"%li", (long)_callCount] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertstatement, 5, type);
    sqlite3_bind_int(insertstatement, 6, uid);
    sqlite3_bind_int(insertstatement, 7, identifier);
    sqlite3_bind_double(insertstatement, 8, [_callFinalData timeIntervalSince1970]);
    sqlite3_bind_text(insertstatement, 9, [_callNumberAddStr UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(insertstatement);
    
    sqlite3_finalize(insertstatement);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with call '%s'.", sqlite3_errmsg(db));
    }else {
    
        RecentCallObject *object = [[RecentCallObject alloc] init];
        object.callDate = _callDate;
        object.callName = _callName;
        object.callNumber = _callNumber;
        object.callCount = _callCount;
        object.type = type;
        object.uid = uid;
        object.callId = _callId;
        object.identifier = identifier;
        object.callFinalData = _callFinalData;
        object.callNumberAddStr = _callNumberAddStr;
        [RecentCallObject addRecentCallToArrayWithRecentCall:object username:useranme];
    }
}

+ (void)updateCall:(RecentCallObject *)call Database:(sqlite3 *)db username:(NSString *)useranme{
    sqlite3_stmt *updatestatement;
    
    static char* sql = "UPDATE recentcalls set date=?, count=?, finalData=? WHERE id=?";
    if (sqlite3_prepare_v2(db, sql, -1, &updatestatement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to insert into the database with call '%s'.", sqlite3_errmsg(db));
    }
    
    sqlite3_bind_double(updatestatement, 1, [call.callDate timeIntervalSince1970]);
    sqlite3_bind_text(updatestatement, 2, [[NSString stringWithFormat:@"%li", ++call.callCount] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(updatestatement, 3, [call.callFinalData timeIntervalSince1970]);
    sqlite3_bind_int(updatestatement, 4, call.callId.intValue);
    
    int success = sqlite3_step(updatestatement);
    
    sqlite3_finalize(updatestatement);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with call '%s'.", sqlite3_errmsg(db));
    }else {
    
        [self addRecentCallToArrayWithRecentCall:call username:useranme];
    }
}

+ (void)deleteCall:(RecentCallObject *)call fromDatabase:(sqlite3 *)db{
    sqlite3_stmt *deletestatement;
    
    const char *sql = "DELETE FROM recentcalls WHERE id=?";
    if (sqlite3_prepare_v2(db, sql, -1, &deletestatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with call '%s'.",
                  sqlite3_errmsg(db));
    }
    
    sqlite3_bind_int(deletestatement, 1, call.callId.intValue);
    int success = sqlite3_step(deletestatement);
    
    sqlite3_finalize(deletestatement);
    if (success != SQLITE_DONE)
    {
        NSAssert1(0, @"Error: failed to delete from database with call '%s'.", sqlite3_errmsg(db));
    }
}

- (NSArray *)readThisIdRecentCountArrayWithUsername : (NSString *) username{

    NSString *documentsDirectory = [RecentTool defaultUserDataPathWithUsername:username];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",self.callId,self.callNumber]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSArray *resultArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mResultArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < resultArray.count; i++) {
            NSData *undata = [resultArray objectAtIndex:i];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
            RecentCallObject *object = [unarchiver decodeObjectForKey:@"recentCall"];
            [mResultArray addObject:object];
        }
        return mResultArray;
    }else {
    
        return nil;
    }
}

+ (void) addRecentCallToArrayWithRecentCall : (RecentCallObject *) call  username : (NSString *) username{

    NSString *documentsDirectory = nil;
    if ([RecentTool defaultUserDataPathWithUsername:username]) {
        documentsDirectory = [RecentTool defaultUserDataPathWithUsername:username];
    }else {
        NSLog(@"------->用户名不能为空");
        return;
    }
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",call.callId,call.callNumber]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:call forKey:@"recentCall"];
        [archiver finishEncoding];
        [array addObject:data];
        BOOL success = [[array copy] writeToFile:path atomically:YES];
        
        if (success) {
            NSLog(@"写入成功");
        }else {
        
            NSLog(@"写入失败");
        }
    }else {
    
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:call forKey:@"recentCall"];
        [archiver finishEncoding];
        [array addObject:data];
        BOOL success = [[array copy] writeToFile:path atomically:YES];
        
        if (success) {
            NSLog(@"写入成功");
        }else {
            
            NSLog(@"写入失败");
        }
    }
    NSLog(@"-------->当前的地址%@",path);
}

- (NSString *)displayName
{
    if ([_callName length])
        return _callName;
    else{
        return @"未知";
    }
}

-(void)setType:(CallType)newType
{
    if (newType == type)
        return;
    type = newType;
}

-(CallType)type
{
    return type;
}

- (void)setUid:(ABRecordID)newUid
{
    if (newUid == uid)
        return;
    uid = newUid;
}

- (ABRecordID)uid
{
    return uid;
}

- (void)setIdentifier:(ABMultiValueIdentifier)newIdentifier
{
    if (newIdentifier == identifier)
        return;
    dirty = YES;
    identifier = newIdentifier;
}

- (ABMultiValueIdentifier)identifier
{
    return identifier;
}

- (void)setCompositeName:(NSString *)newName
{
    if ((!_callName && !newName) ||
        (_callName && newName && [_callName isEqualToString:newName]))
        return;
    
    dirty = YES;
    _callName = [newName copy];
}

- (NSString *)compositeName
{
    return _callName;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.callId forKey:@"callID"];
    [aCoder encodeObject:self.callName forKey:@"callName"];
    [aCoder encodeObject:self.callNumber forKey:@"callNumber"];
    [aCoder encodeObject:self.callDate forKey:@"callDate"];
    [aCoder encodeInteger:self.callCount forKey:@"callCount"];
    [aCoder encodeObject:self.callFinalData forKey:@"callFinalData"];
    [aCoder encodeInteger:self.type forKey:@"callType"];
    [aCoder encodeBool:self.dirty forKey:@"dirty"];
    [aCoder encodeInt32:self.uid forKey:@"uid"];
    [aCoder encodeInt32:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.callNumberAddStr forKey:@"callNumberAddStr"];
}

#pragma mark 第三步：对text对象解码
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init])
    {
        self.callId = [aDecoder decodeObjectForKey:@"callID"];
        self.callName = [aDecoder decodeObjectForKey:@"callName"];
        self.callNumber = [aDecoder decodeObjectForKey:@"callNumber"];
        self.callDate = [aDecoder decodeObjectForKey:@"callDate"];
        self.callCount = [aDecoder decodeIntegerForKey:@"callCount"];
        self.callFinalData = [aDecoder decodeObjectForKey:@"callFinalData"];
        self.type = [aDecoder decodeIntegerForKey:@"callType"];
        self.dirty = [aDecoder decodeBoolForKey:@"dorty"];
        self.uid = [aDecoder decodeInt32ForKey:@"uid"];
        self.identifier = [aDecoder decodeInt32ForKey:@"identifier"];
        self.callNumberAddStr = [aDecoder decodeObjectForKey:@"callNumberAddStr"];
    }
    return self;
}


@end
