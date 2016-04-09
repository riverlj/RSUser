//
//  BaseTabbarViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseTabbarViewController.h"

typedef void (^TabBarTapBlock)(NSInteger index);
@interface BaseTabbarViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong)NSArray *tabbars;

@property (nonatomic, copy) TabBarTapBlock tapBlock;

//购物的按钮
@property (nonatomic, strong) UIView *cartView;
@property (nonatomic, strong) UILabel *cartLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *cartIV;

@end

@implementation BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabbars = [AppConfig tabBarConfig];
}

-(void)setTabbars:(NSArray *)tabbars{
    _tabbars = tabbars;
    [self setViewController];
}

-(void)setViewController
{
    [self createCartView];
    [self.tabBar addSubview:self.cartView];
    
    [self addChildViewController:[[UIViewController alloc]init]];
    
    
    for (int i=0; i< self.tabbars.count; i++) {
 
        NSDictionary *dic = self.tabbars[i];
        
        UIViewController *vc = [RSRoute getViewControllerByHost:[dic valueForKey:@"host"]];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        vc.title = [dic valueForKey:@"title"];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RS_TabBar_Title_Color,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RS_Theme_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        nav.tabBarItem.image = [[UIImage imageNamed:[dic valueForKey:@"normalIcon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[dic valueForKey:@"selectedIcon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        nav.navigationController.navigationBar.translucent = NO;
        [self addChildViewController:nav];
    }
    
    self.selectedIndex = 1;
}

- (void)createCartView
{
    UIView *topView = [UIView newAutoLayoutView];
    [self.tabBar addSubview:topView];
    [topView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [topView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [topView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [topView autoSetDimension:ALDimensionHeight toSize:.5];
    [topView setBackgroundColor:RS_Line_Color];
    
    CGFloat width = self.view.frame.size.width/4.f;
    UIView *cartView = [UIView newAutoLayoutView];
    [self.tabBar addSubview:cartView];
    [cartView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [cartView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [cartView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [cartView autoSetDimension:ALDimensionWidth toSize:width];
    self.cartView = cartView;
    
    UIImage *cartImage = [UIImage imageNamed:@"tab_cart"];
    UIImageView *cartIV = [UIImageView newAutoLayoutView];
    [cartView addSubview:cartIV];
    [cartIV autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [cartIV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
    [cartIV autoSetDimensionsToSize:cartImage.size];
    cartIV.image = cartImage;
    self.cartIV = cartIV;
    
    UILabel *cartLabel = [UILabel newAutoLayoutView];
    [cartView addSubview:cartLabel];
    [cartLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [cartLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2];
    [cartLabel autoSetDimensionsToSize:CGSizeMake(60, 10)];
    cartLabel.font = Font(10);
    cartLabel.textAlignment = NSTextAlignmentCenter;
    cartLabel.textColor = RS_TabBar_Title_Color;
    cartLabel.text = @"购物车";
    self.cartLabel = cartLabel;
    
    UILabel *countLabel = [UILabel newAutoLayoutView];
    [cartIV addSubview:countLabel];
    [countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [countLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [countLabel autoSetDimensionsToSize:CGSizeMake(16, 16)];
    countLabel.font = Font(12);
    countLabel.adjustsFontSizeToFitWidth = YES;
    countLabel.textColor = RS_TabBar_count_Color;
    countLabel.backgroundColor = [NSString colorFromHexString:@"ffa53a"];
    countLabel.clipsToBounds = YES;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.layer.cornerRadius = 8.f;
    self.countLabel = countLabel;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == [tabBarController.viewControllers objectAtIndex:0])
    {
        //弹出购物车视图
        if ([self.countLabel.text integerValue] == 0) {
            [RSToastView alertView:@"您还没有选择商品呢"];
        }
        return NO;
    }
    return YES;
}

@end
