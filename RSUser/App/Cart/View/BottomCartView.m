//
//  BottomCartView.m
//  RSUser
//
//  Created by 李江 on 16/8/31.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BottomCartView.h"

#define BOTTOMVIIEW_HEIGHT 49

@implementation BottomCartView
{
    CGFloat totalPrice;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0, SCREEN_HEIGHT-BOTTOMVIIEW_HEIGHT, SCREEN_WIDTH, BOTTOMVIIEW_HEIGHT);
        [self addSubview:self.totalPriceLabel];
        [self addSubview:self.goCreatOrder];
        [self addSubview:self.cartImageView];
        [self initData];
        [self.cartImageView addSubview:self.cartNumberLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:UPDATE_BOTTOM_CAR_TDATE object:nil];
    }
    return self;
}

-(void)initData {
    __block CGFloat price = 0.00;
    __block NSInteger cartNum = 0;
    NSArray *array = [[Cart sharedCart] getCartGoods];
    [array enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += ([obj.saleprice floatValue] * obj.num);
        cartNum += obj.num;
        
    }];
    
    totalPrice = price;
    NSString *priceStr = [NSString stringWithFormat:@"¥%.2f", price];
    
    if (array.count == 0) {
        priceStr = @"费用以订单为准";
        self.totalPriceLabel.font = RS_FONT_F5;
        self.totalPriceLabel.textColor = RS_COLOR_C4;
        self.totalPriceLabel.text = priceStr;
    }else{
        self.totalPriceLabel.font = RS_FONT_F1;
        self.totalPriceLabel.textColor = [UIColor whiteColor];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
        [attrStr addAttribute:NSFontAttributeName value:RS_FONT_F4 range:NSMakeRange(0, 1)];
        self.totalPriceLabel.attributedText = attrStr;
    }
    
    if (array.count == 0) {
        self.cartNumberLabel.text = @"";
        self.cartImageView.image = [UIImage imageNamed:@"tab_cart_noselected"];
        self.cartNumberLabel.hidden = YES;
    }else {
        self.cartNumberLabel.text = [NSString stringWithFormat:@"%ld",cartNum];
        self.cartImageView.image = [UIImage imageNamed:@"tab_cart"];
        self.cartNumberLabel.hidden = NO;
    }
}

-(UILabel *)goCreatOrder {
    if (_goCreatOrder) {
        return _goCreatOrder;
    }
    
    _goCreatOrder = [RSLabel labellWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, BOTTOMVIIEW_HEIGHT) Text:@"去下单" Font:RS_FONT_F1 TextColor:[UIColor whiteColor]];
    _goCreatOrder.backgroundColor = [NSString colorFromHexString:@"ffa53a"];
    
    _goCreatOrder.textAlignment = NSTextAlignmentCenter;
    [_goCreatOrder addTapAction:@selector(goCreatOrderClicked) target:self];
    return _goCreatOrder;
    
}

-(UIImageView *)cartImageView {
    if (_cartImageView) {
        return _cartImageView;
    }
    _cartImageView = [[UIImageView alloc]init];
    _cartImageView.image = [UIImage imageNamed:@"tab_cart"];
    _cartImageView.frame = CGRectMake(15, -22, 44, 44);
    [_cartImageView addTapAction:@selector(showCarts) target:self];
    return _cartImageView;
}

- (void)showCarts {
    if ([[Cart sharedCart] getCartCountLabelText] == 0)
    {
        [[RSToastView shareRSToastView] showToast:@"您还没有选择商品呢"];
    }
    else
    {
        UIView *view = [AppConfig getAPPDelegate].cartViewVc.view;
        [self.window addSubview : view];
    }
}

-(UILabel *)cartNumberLabel {
    if (_cartNumberLabel) {
        return _cartNumberLabel;
    }
    
    _cartNumberLabel = [[UILabel alloc] init];
    _cartNumberLabel.frame = CGRectMake(28, -2, 16, 16);
    _cartNumberLabel.backgroundColor = [NSString colorFromHexString:@"ffa53a"];
    _cartNumberLabel.textColor = [UIColor whiteColor];
    _cartNumberLabel.font = Font(12);
    _cartNumberLabel.clipsToBounds = YES;
    _cartNumberLabel.textAlignment = NSTextAlignmentCenter;
    _cartNumberLabel.layer.cornerRadius = 8.f;
    
    return _cartNumberLabel;
    
}

- (void)goCreatOrderClicked
{
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (![AppConfig getAPPDelegate].schoolModel) {
            [SchoolModel getSchoolMsg:^(SchoolModel *model) {
                [AppConfig getAPPDelegate].schoolModel = model;
                
                [subscriber sendCompleted];
            }];
        }else{
            [subscriber sendCompleted];
        }
        
        return nil;
    }];
    
    @weakify(self)
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        SchoolModel *schoolModel = [AppConfig getAPPDelegate].schoolModel;
        
        NSNumber *totalPriceNumber = [NSNumber numberWithFloat:totalPrice];
        NSNumber *minPriceNumber = [NSNumber numberWithFloat:schoolModel.minprice];
        
        if ([totalPriceNumber compare:minPriceNumber] == -1) {
            @strongify(self)
            [self disappearView];
            
            [[RSToastView shareRSToastView] showToast:[NSString stringWithFormat:@"最低%.2f元起送",schoolModel.minprice]];
            return nil;
        }
        
        [subscriber sendNext:@""];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[RACSignal concat:@[signalA, signalB]]subscribeNext:^(id x) {
        
        @strongify(self)
        [self disappearView];
        if(![AppConfig getAPPDelegate].userValid){
            UIViewController *vc = [RSRoute getViewControllerByPath:@"RSUser://login"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [[AppConfig getAPPDelegate].window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else {
            NSString *path = [NSString stringWithFormat:@"RSUser://confirmOrder?totalprice=%.2f",totalPrice];
            UIViewController *vc = [RSRoute getViewControllerByPath:path];
            
            //去下单
            [[AppConfig getAPPDelegate].crrentNavCtl pushViewController:vc animated:YES];
        }
    }];
}

- (void)disappearView
{
    
}

- (UILabel *)totalPriceLabel {
    if (_totalPriceLabel) {
        return _totalPriceLabel;
    }
    
    _totalPriceLabel = [RSLabel labellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3*2, BOTTOMVIIEW_HEIGHT) Text:@"" Font:RS_FONT_F1 TextColor:[UIColor whiteColor]];
    _totalPriceLabel.backgroundColor=[NSString colorFromHexString:@"454545"];
    _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    return _totalPriceLabel;
}
@end
