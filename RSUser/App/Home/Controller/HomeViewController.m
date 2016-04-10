//
//  HomeViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "HomeViewController.h"
#import "RSAlertView.h"

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
//    RSAlertView *alerView = [[RSAlertView alloc]initWithTile:@"消息" msg:@"XXXXXXX" leftButtonTitle:@"左边" rightButtonTitle:@"右边"];
//    alerView.leftBlock = ^(){
//        NSLog(@"leftBlock");
//    };
//    
//    alerView.rightBlock = ^(){
//        NSLog(@"XXXXXXXX");
//    };
    RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"提示" msg:@"请选择你的订单～" leftButtonTitle:@"确定" rightButtonTitle:@"取消" AndLeftBlock:^{
        NSLog(@"left");
    } RightBlock:^{
        NSLog(@"right");
    }];
    
    [alertView show];
}
@end
