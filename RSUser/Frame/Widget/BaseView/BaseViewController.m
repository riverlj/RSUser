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
        _hasBackBtn = YES;
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
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatCountLable];
    
    if([self.navigationController.viewControllers count] > 1)
    {
        self.tabBarController.tabBar.hidden = YES;
        self.hasBackBtn = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
        self.hasBackBtn = NO;
    }
    
    if ([self isKindOfClass:[HomeViewController class]]
        ||[self isKindOfClass:[OrderViewController class]]
        ||[self isKindOfClass:[ProfileViewController class]]) {
        [AppConfig getAPPDelegate].crrentNavCtl = self.navigationController;
    }
    
    [self setBackUpBtn];
}

- (void)setHasBackBtn:(Boolean)hasBackBtn
{
    _hasBackBtn = hasBackBtn;
    if (hasBackBtn == YES) {
        [self setBackUpBtn];
    }
}

- (void)setBackUpBtn
{
    if (_hasBackBtn)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        iv.image = [UIImage imageNamed:@"nav-goback"];
        [iv addTapAction:@selector(backUp) target:self];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:iv];
        self.navigationItem.leftBarButtonItem = item;
        
    }
}

- (void)backUp
{
    [self.navigationController popViewControllerAnimated:YES];
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
