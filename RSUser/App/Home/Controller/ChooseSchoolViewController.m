//
//  ChooseSchoolViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/14.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ChooseSchoolViewController.h"

@implementation ChooseSchoolViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择学校";
}

-(void)backUp
{
    if (!COMMUNTITYID)
    {
        RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"请选择所在学校" leftButtonTitle:@"我知道了" AndLeftBlock:^{
        }];
        
        [alertView show];
        return;
    }
    
    [super backUp];
}
@end
