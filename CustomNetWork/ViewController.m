//
//  ViewController.m
//  CustomNetWork
//
//  Created by ZN on 2019/7/3.
//  Copyright © 2019年 nangnahz.nan. All rights reserved.
//

#import "ViewController.h"
#import "BreakLoadViewController.h"
#import "UpdateLoadViewController.h"
#import "sysDownLoadViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)downLoadAction:(id)sender {
    BreakLoadViewController *vc = [[BreakLoadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)updateAction:(id)sender {
    UpdateLoadViewController *vc = [[UpdateLoadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sysDownLoadAction:(id)sender {
    sysDownLoadViewController *vc = [[sysDownLoadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
