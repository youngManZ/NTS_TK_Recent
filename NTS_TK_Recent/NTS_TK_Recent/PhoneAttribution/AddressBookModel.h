//
//  AddressBookModel.h
//  phoneNumberAttribution
//
//  Created by 赵嘉诚 on 15/8/6.
//  Copyright (c) 2015年 赵嘉诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface AddressBookModel : NSObject

+ (instancetype)sharedManager;

- (NSString *)attributionWithPhoneNumber:(NSString *)phoneNumber;

@end