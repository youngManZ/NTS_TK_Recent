//
//  ViewController.m
//  NTS_TK_Recent
//
//  Created by nrh on 2018/5/31.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "ViewController.h"
#import "RecentCallsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    RecentCallsViewController *vc = [[RecentCallsViewController alloc] initWithNibName:@"RecentCallsViewController" bundle:[NSBundle mainBundle]];
    vc.username = @"18981204102";
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
