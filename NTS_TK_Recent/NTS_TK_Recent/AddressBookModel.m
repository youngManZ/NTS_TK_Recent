//
//  AddressBookModel.m
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import "AddressBookModel.h"
#import "StringHelper.h"
#import "SQLHelper.h"
#import <UIKit/UIKit.h>

static AddressBookModel*        addresBook;

typedef NS_ENUM(NSInteger, UpdataOption) {
    UpdataOptionUpdata      = 0,
    UpdataOptionRestore     = 1,
};

@interface AddressBookModel (){
    ABAddressBookRef        _adressBookRef;
    CFArrayRef              _records;
    
    NSString*               _optionString;
    __block NSString*       _status;
    __block float           _progress;
}


@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundUpdateTask;

@end

@implementation AddressBookModel

+ (instancetype)sharedManager
{
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        addresBook = [[AddressBookModel alloc] init];
    });
    return addresBook;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_records);
}

#pragma mark -- BackgroundTask
- (void) beginBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void) endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

#pragma mark -- public method

- (NSString *)attributionWithPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length == 7) {
        phoneNumber = [phoneNumber stringByAppendingString:@"1111"];
    }else if (phoneNumber.length == 3){
        phoneNumber = [phoneNumber stringByAppendingString:@"-00000000"];
    }else if (phoneNumber.length == 4){
        phoneNumber = [phoneNumber stringByAppendingString:@"-00000000"];
    }
    return [self getLabelWithPhoneNumber:phoneNumber LabelType:NO];
}

#pragma maek -- private method

//根据电话号码获取归属地
- (NSString *)getLabelWithPhoneNumber:(NSString *)phoneNumber
{
    return [self getLabelWithPhoneNumber:phoneNumber LabelType:YES];
}

- (NSString *)getLabelWithPhoneNumber:(NSString *)phoneNumber LabelType:(BOOL)labelType
{
    @synchronized (self) {
        NSString *phone = [StringHelper getPhoneNumberWithString:phoneNumber];
        if ([phone isEqualToString:@""] || !phone) {
            return @"";
        }
        NSString *area, *type;
        if (phone.length > 4) {
            area = [[SQLHelper sharedManager] selectAreaWithPhoneNumber:phone];
//            type = [[SQLHelper sharedManager] selectTypeWithPhoneNumber:phone];
        }else{
            area = [[SQLHelper sharedManager] selectAreaWithAreaCode:phone];
            type = @"电话";
        }
        
        if (labelType) {
            NSString *city = [StringHelper getCityWithString:area];
            NSString *provice = [StringHelper getProviceWithString:area];
            area = [provice stringByAppendingString:city];
            
//            type = [StringHelper getSimpleMobileTypeWithString:type];
        }
        
        if (![area isEqualToString:@""] && area) {
            return [NSString stringWithFormat:@"%@", area];
        }
        return @"";
    }
}

@end
