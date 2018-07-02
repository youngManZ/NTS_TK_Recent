//
//  RecentCallsTableViewCell.m
//  JiaMengNet
//
//  Created by zeng on 2017/3/10.
//  Copyright © 2017年 zt. All rights reserved.
//

#import "RecentCallsTableViewCell.h"
#import "AddressBookModel.h"

@interface RecentCallsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *callNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UILabel *phoneLable;

@end

@implementation RecentCallsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setValueWithRecentCallObject:(RecentCallObject *)object{

    if (object.callCount > 1) {
        _callNumberLable.text = [NSString stringWithFormat:@"(%ld)",(long)object.callCount];
    }
    _phoneLable.text = object.callNumber;
    
    //设置归属地 地址
    if (object.callNumberAddStr) {
        [_addressLable setText:object.callNumberAddStr];
    }else {
    
        [_addressLable setText:@"未知归属地"];
    }
    switch (object.type) {
        case Undefined:
        {
            NSBundle *curBundle = [NSBundle bundleForClass:self.class];
            NSURL *url = [curBundle URLForResource:@"NTS_TK_Recent" withExtension:@"bundle"];
            NSString *normalPath = [[NSBundle bundleWithURL:url] pathForResource:@"call_appear" ofType:@"png"];
            _iconImageView.image = [UIImage imageWithContentsOfFile:normalPath];
        }
            break;
        case Dialled:
        {
            NSBundle *curBundle = [NSBundle bundleForClass:self.class];
            NSURL *url = [curBundle URLForResource:@"NTS_TK_Recent" withExtension:@"bundle"];
            NSString *normalPath = [[NSBundle bundleWithURL:url] pathForResource:@"call_appear" ofType:@"png"];
            _iconImageView.image = [UIImage imageWithContentsOfFile:normalPath];
        }
            break;
        case Received:
        {
            NSBundle *curBundle = [NSBundle bundleForClass:self.class];
            NSURL *url = [curBundle URLForResource:@"NTS_TK_Recent" withExtension:@"bundle"];
            NSString *normalPath = [[NSBundle bundleWithURL:url] pathForResource:@"call_join" ofType:@"png"];
            _iconImageView.image = [UIImage imageWithContentsOfFile:normalPath];
        }
            break;
        case Missed:
        {
            NSBundle *curBundle = [NSBundle bundleForClass:self.class];
            NSURL *url = [curBundle URLForResource:@"NTS_TK_Recent" withExtension:@"bundle"];
            NSString *normalPath = [[NSBundle bundleWithURL:url] pathForResource:@"call_noanswer" ofType:@"png"];
            _iconImageView.image = [UIImage imageWithContentsOfFile:normalPath];
        }
            break;
            
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *nowTime = [self intervalFromLastDate:object.callDate toTheDate:[NSDate date]];
    if ([nowTime intValue] == 0) {
        NSDateFormatter * formater = [[NSDateFormatter alloc]init];
        [formater setDateFormat:@"HH:mm"];
        NSString * result = [formater stringFromDate:object.callDate];
        _timeLable.text = result;
    } else if ([nowTime intValue] == 1) {
        _timeLable.text = @"昨天";
    }else{
        NSString * result = [dateFormatter stringFromDate:object.callDate];
        _timeLable.text = result;
    }
    
    
}

#pragma mark --- 计算天数
- (NSString *)intervalFromLastDate:(NSDate *)date1  toTheDate:(NSDate *)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    return [NSString stringWithFormat:@"%ld",(long)[d day]];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self.cellDelegete cellButtonPressed:self.cellTag];
}



@end
