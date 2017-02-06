//
//  RootViewController.m
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import "SYPasswordView.h"

@interface RootViewController ()

@property (nonatomic, strong) SYPasswordView *pasView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码设置";
    self.view.backgroundColor = [UIColor colorWithRed:230 / 250.0 green:230 / 250.0 blue:230 / 250.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, 45)];
    [self.view addSubview:_pasView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor brownColor];
    button.frame = CGRectMake(100, 180, self.view.frame.size.width - 200, 50);
    [button addTarget:self action:@selector(clearPaw) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"清空密码" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)clearPaw
{
    [self.pasView clearUpPassword];
}

@end
