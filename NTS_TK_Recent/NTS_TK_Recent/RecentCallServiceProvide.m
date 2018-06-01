//
//  RecentCallServiceProvide.m
//  NTS_TK_Recent
//
//  Created by nrh on 2018/5/31.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "RecentCallServiceProvide.h"
#import "RecentCallsViewController.h"
#import <ProvideManager/ProvideManager.h>
#import <ProvideManager/NTS_TK_RecentProtocol.h>

@implementation RecentCallServiceProvide

+ (void)load
{
    [ProvideManager registServiceProvide:[[self alloc] init] forProtocol:@protocol(NTS_TK_RecentProtocol)];
}

- (UIViewController *)recentCallsViewControllerWithUsername : (NSString *) username
{
    RecentCallsViewController *vc = [[RecentCallsViewController alloc] initWithNibName:@"RecentCallsViewController" bundle:[NSBundle mainBundle]];
    vc.username = username;
    return vc;
}

@end
