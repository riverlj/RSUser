//
//  BaseViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+ViewController.h"
#import "RSCartButtion.h"
#import "HomeViewController.h"
#import "OrderViewController.h"
#import "ProfileViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.tabBarItem.title;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = RS_Background_Color;
    
}

- (void)creatCountLable
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    _countLabel = [CartNumberLabel shareCartNumberLabel];
    
    for (UIView *view in tabBar.subviews)
    {
        if ([view isKindOfClass:[RSCartButtion class]] && ![view.subviews containsObject:[CartNumberLabel shareCartNumberLabel]])
        {
            _countLabel.right = view.bounds.size.width - 12;
            [view addSubview:_countLabel];
        }
    }
    
    [RACObserve(_countLabel, text) subscribeNext:^(NSString *text) {
        RSCartButtion *button = (RSCartButtion *)CYLExternPlusButton;
        if ([text integerValue] == 0) {
            _countLabel.hidden = YES;
            button.highlighted = NO;
        }else{
            _countLabel.hidden = NO;
            button.highlighted = YES;
        }
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatCountLable];
    
    if ([self isKindOfClass:[HomeViewController class]]
        ||[self isKindOfClass:[OrderViewController class]]
        ||[self isKindOfClass:[ProfileViewController class]]) {
        [AppConfig getAPPDelegate].crrentNavCtl = self.navigationController;
    }
    
}

-(RSTipsView *) tips
{
    if(_tips)
    {
        return _tips;
    }
    _tips = [[RSTipsView alloc] initWithFrame:self.view.bounds];
    [_tips setTitle:@"暂时没有数据哦" withImg:@"kongrenwu"];
    return _tips;
}

@end
