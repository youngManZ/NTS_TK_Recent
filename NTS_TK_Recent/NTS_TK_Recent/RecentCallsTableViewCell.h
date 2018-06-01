//
//  RecentCallsTableViewCell.h
//  JiaMengNet
//
//  Created by zeng on 2017/3/10.
//  Copyright © 2017年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentCallObject.h"

@protocol RecentCallsTableViewCellDelegate <NSObject>

- (void)cellButtonPressed:(NSInteger)cellTag;

@end

@interface RecentCallsTableViewCell : UITableViewCell

@property (assign, nonatomic) NSInteger cellTag;
@property (nonatomic,retain)id<RecentCallsTableViewCellDelegate> cellDelegete;

- (void)setValueWithRecentCallObject:(RecentCallObject *)object;

@end
