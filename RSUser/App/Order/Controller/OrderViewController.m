//
//  OrderViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderViewController.h"
#import "LoginViewController.h"

@implementation OrderViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.hasBackBtn = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    loginVc.type  = 1;
    [self.navigationController pushViewController:loginVc animated:YES];
    
}
@end
