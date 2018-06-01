//
//  SQLHelper.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "SQLHelper.h"
#import "StringHelper.h"

static SQLHelper*       sqlHelper;

@interface SQLHelper (){

    sqlite3*        _database;
}

@end

@implementation SQLHelper

+ (instancetype)sharedManager
{
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        sqlHelper = [[SQLHelper alloc] init];
    });
    [sqlHelper openSQL];
    return sqlHelper;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark -- private method
- (void)openSQL
{
    if (sqlite3_open([[StringHelper getDataBasePath] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Failed to open database");
    }else {
        sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    }
}

- (void)closeSQL
{
    sqlite3_close(_database);
}

#pragma mark -- public method
- (NSString *)selectAreaWithAreaCode:(NSString *)areaCode
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT dm_area.area FROM dm_area where area_code ='%@'", areaCode];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return areaString;
}

- (NSString *)selectAreaWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT area FROM dm_area where dm_area.id ='%@'", [self selectAreaIDWithPhoneNumber:phoneNumber]];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return areaString;
}

- (NSString *)selectAreaIDWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT area_id FROM dm_mobile where dm_mobile.prefix ='%@'", phoneNumber];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    return areaString;
}

- (NSArray *)selectProvinceWithProvince:(NSString *)province{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT province FROM qr_hat_province where province like'%%%@%%'",province];
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            NSString *provinceString = [NSString stringWithUTF8String:(const char*)areaName];
            [provinceArray addObject:provinceString];
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return [provinceArray copy];
}

- (NSArray *)selectCityWithProvince:(NSString *)province
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT provinceID FROM qr_hat_province where qr_hat_province.province ='%@'", province];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    return [[self selectCityWithProvinceID:areaString] copy];
}

- (NSArray *)selectCityWithProvinceID:(NSString *)provinceID{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT city FROM qr_hat_city where father like'%%%@%%'",provinceID];
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            NSString *cityString = [NSString stringWithUTF8String:(const char*)areaName];
            [cityArray addObject:cityString];
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return [cityArray copy];
}

- (NSArray *)selectCityWithCity:(NSString *)city {

    NSString *SelectArea = [NSString stringWithFormat:@"SELECT city FROM qr_hat_city where city like'%%%@%%'",city];
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            NSString *cityString = [NSString stringWithUTF8String:(const char*)areaName];
            [cityArray addObject:cityString];
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return [cityArray copy];
}

- (NSString *)selectTypeWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT dm_mobile.v FROM dm_mobile where dm_mobile.prefix ='%@'", phoneNumber];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    if (areaString.length > 0) {
        NSInteger type = [areaString integerValue];
        switch (type) {
            case 1:
                areaString = @"移动";
                break;
            case 2:
                areaString = @"电信";
                break;
            case 3:
                areaString = @"联通";
                break;
                
            default:
                break;
        }
    }
    return areaString;
}

@end
