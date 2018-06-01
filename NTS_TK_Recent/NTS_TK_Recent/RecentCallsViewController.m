//
//  RecentCallsViewController.m
//  JiaMengNet
//
//  Created by zeng on 2017/3/9.
//  Copyright © 2017年 zt. All rights reserved.
//

#import "RecentCallsViewController.h"
#import "RecentCallsTableViewCell.h"
#import "RecentTool.h"
#import "RecentCallObject.h"

@interface RecentCallsViewController ()<RecentCallsTableViewCellDelegate>
{
    NSMutableArray *_datasource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecentCallsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasource = [NSMutableArray arrayWithArray:[RecentTool readRecentCallArrayWithUsername:_username]];
    [_tableView registerNib:[UINib nibWithNibName:@"RecentCallsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RecentCallsTableViewCell"];
    [self setExtraCellLineHidden:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecentCallData) name:@"recentUpdata" object:nil];
}

#pragma mark -- 公开更新通话记录的方法
- (void)reloadRecentCallData {

    _datasource = [NSMutableArray arrayWithArray:[RecentTool readRecentCallArrayWithUsername:_username]];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecentCallsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCallsTableViewCell"];
    
    if (!cell) {
        cell = [[RecentCallsTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"RecentCallsTableViewCell"];
    }
    
    cell.cellTag = indexPath.row;
    cell.cellDelegete = self;
    RecentCallObject *object = _datasource[indexPath .row];
    [cell setValueWithRecentCallObject:object];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecentCallObject *object = _datasource[indexPath .row];
    //点击拨打电话
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)cellButtonPressed:(NSInteger)cellTag{
    
    RecentCallObject *object = _datasource[cellTag];
    if ([_delegate respondsToSelector:@selector(recentViewControllerTableViewSelectWithRcentCall:cellTag:)]) {
        [_delegate recentViewControllerTableViewSelectWithRcentCall:object cellTag:cellTag];
    }else {
    
//        RecentCallsDetailMessageVC *vc = [[RecentCallsDetailMessageVC alloc]initWithNibName:@"RecentCallsDetailMessageVC" bundle:nil recentCallObject:object cellTag:cellTag];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
