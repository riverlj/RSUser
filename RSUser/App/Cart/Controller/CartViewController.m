//
//  CartViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CartViewController.h"
#import "CartModel.h"

@interface CartViewController()
{
    UIView *conView;
    UIView *view;
    UIView *bottomView;
    RSLabel *totalPriceLabel;
}
@end
@implementation CartViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    conView.backgroundColor = RS_Background_Color;
    conView.alpha = 1.0;
    [self.view addSubview:conView];
    
    view = [[UIView alloc]init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [view addTapAction:@selector(disappearView) target:self];
    [self.view addSubview:view];
    
    RSLabel *textLabel = [RSLabel lableViewWithFrame:CGRectMake(18, 0, 100, 32) bgColor:[UIColor clearColor] textColor:RS_Theme_Color FontSize:12];
    textLabel.text = @"美味早餐";
    textLabel.textAlignment = NSTextAlignmentLeft;
    [conView addSubview:textLabel];
    
    RSButton *button = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH -110, 0, 110, 32) ImageName:@"icon_clearcar" Text:@"全部清空" TextColor:RS_SubMain_Text_Color];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    button.titleLabel.font = RS_SubLable_Font;
    [conView addSubview:button];
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [[AppConfig getAPPDelegate].localCartData removeAllObjects];
        [self initCarData];
        CartNumberLabel *label = [CartNumberLabel shareCartNumberLabel];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];
        label.text = @"0";
        
        [self disappearView];
    }];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    bottomView.backgroundColor = RS_TabBar_count_Color;
    [self.view addSubview:bottomView];
    totalPriceLabel = [RSLabel lableViewWithFrame:CGRectMake(20, 0, 100, 49) bgColor:[UIColor clearColor] textColor:RS_Theme_Color];
    [bottomView addSubview:totalPriceLabel];
    
    RSButton *okbutton = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-85, 10, 67, 30) ImageName:nil Text:@"选好了" TextColor:RS_TabBar_count_Color];
    [okbutton setBackgroundColor:RS_Button_Bg_Color];
    okbutton.titleLabel.font = RS_SubButton_Font;
    okbutton.layer.cornerRadius = 5;
    [bottomView addSubview:okbutton];
    [okbutton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartCountLabel) name:@"Notification_UpadteCartCountLabel" object:nil];
}

- (void)updateCartCountLabel
{
    [self initCarData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initCarData];
}


- (void)initCarData
{
    self.models = [AppConfig getAPPDelegate].localCartData;
    [self.models enumerateObjectsUsingBlock:^(CartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.num == 0)
        {
            [self.models removeObjectAtIndex:idx];
        }
    }];

    CartNumberLabel *numberLabel = [CartNumberLabel shareCartNumberLabel];

    if (self.models.count == 0)
    {
        numberLabel.text = [NSString stringWithFormat:@"%zd", 0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];
        [self disappearView];
        return;
    }
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.models.count*49);
    conView.y = SCREEN_HEIGHT - (32 + self.tableView.height + 49);
    self.tableView.y = conView.y + 32;
    [self.tableView reloadData];
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, conView.y);
    
    __block CGFloat price = 0.00;
    __block NSInteger cartNum = 0;
    [self.models enumerateObjectsUsingBlock:^(CartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += ([obj.price floatValue] * obj.num);
        cartNum += obj.num;
        
    }];
    numberLabel.text = [NSString stringWithFormat:@"%zd", cartNum];
    NSString *priceStr = [NSString stringWithFormat:@"共¥%.2f", price];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attStr addAttribute:NSFontAttributeName value:RS_SubButton_Font range:NSMakeRange(0, 2)];
    [attStr addAttribute:NSFontAttributeName value:RS_Price_FontSize range:NSMakeRange(2, priceStr.length-2)];
    totalPriceLabel.attributedText = attStr;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];

}



- (void)okButtonClicked
{
    //去下单
}

- (void)disappearView
{
    [self.view removeFromSuperview];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}
@end