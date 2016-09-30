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
        self.showCartBottom = NO;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.tabBarItem.title;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = RS_Background_Color;
    
    if (self.navigationController.viewControllers.count > 1 && self.showCartBottom) {
        self.bottomCartView = [[BottomCartView alloc]initWithFrame:CGRectMake(0, self.view.height-49, SCREEN_WIDTH, 49)];
        [self.view addSubview:self.bottomCartView];
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        self.hasBackBtn = YES;
    }else {
        self.hasBackBtn = NO;
    }
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
        UIImage *buttonImage = [UIImage imageNamed:@"tab_cart"];
        UIImage *buttonImage_no = [UIImage imageNamed:@"tab_cart_noselected"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_BOTTOM_CAR_TDATE object:nil];
        
        if ([text integerValue] == 0) {
            _countLabel.hidden = YES;
            [button setImage:buttonImage_no forState:UIControlStateNormal];
            [button setImage:buttonImage_no forState:UIControlStateHighlighted];
        }else{
            _countLabel.hidden = NO;
            [button setImage:buttonImage forState:UIControlStateNormal];
            [button setImage:buttonImage forState:UIControlStateHighlighted];
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
    
    if (self.bottomCartView) {
        NSArray *subViews = self.view.subviews;
        
         NSInteger index=0;
        for (int i=0; i<subViews.count; i++) {
            if (self.bottomCartView == subViews[i]) {
                index = i;
            }
        }
        
        [self.view exchangeSubviewAtIndex:index withSubviewAtIndex:subViews.count-1];
    }
    
    [self setBackUpBtn];
    
}


- (void)setBackUpBtn
{
    if (self.hasBackBtn)
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
