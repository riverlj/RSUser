//
//  BannerWebViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BannerwebViewController.h"

@implementation BannerwebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-64);
    self.bannerView.backgroundColor = RS_Background_Color;
}

@end
