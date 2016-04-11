//
//  HomeViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "HomeViewController.h"
#import "RSAlertView.h"
#import "RSCartButtion.h"

@implementation HomeViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.hasBackBtn = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"确认删除此条地址" leftButtonTitle:@"确认" rightButtonTitle:@"再想想" AndLeftBlock:^{
        NSLog(@"确认");
    } RightBlock:^{
        NSLog(@"再想想");
    }];
    [alertView show];
    
}
@end
