//
//  ProfileViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.hasBackBtn = NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.countLabel.text = @"14";
}
@end
