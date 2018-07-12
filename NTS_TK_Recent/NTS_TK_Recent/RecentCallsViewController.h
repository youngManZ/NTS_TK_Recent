//
//  RecentCallsViewController.h
//  JiaMengNet
//
//  Created by zeng on 2017/3/9.
//  Copyright © 2017年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentCallObject.h"

@protocol RecentViewControllerDelegate <NSObject>

- (void)recentViewControllerTableViewSelectWithRcentCall: (RecentCallObject *) recentCall cellTag : (NSInteger) cellTag;

@end

@interface RecentCallsViewController : UIViewController

@property(nonatomic,assign) id<RecentViewControllerDelegate> delegate;
@property(nonatomic,copy)   NSString    *username;

- (void) refreshVerHeadViewWithIsShow : (BOOL) isShow;

@end
