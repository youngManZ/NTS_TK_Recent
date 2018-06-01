//
//  NTS_TK_RecentProtocol.h
//  ProvideManager
//
//  Created by nrh on 2018/5/31.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NTS_TK_RecentProtocol <NSObject>

@required;

- (UIViewController *)recentCallsViewControllerWithUsername : (NSString *) username;

@end
