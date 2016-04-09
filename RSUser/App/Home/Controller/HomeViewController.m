//
//  HomeViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.hasBackBtn = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BaseViewController *vc = [[BaseViewController alloc]init];
    vc.view.backgroundColor = RS_Background_Color;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
