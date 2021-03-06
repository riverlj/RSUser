//
//  CartViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CartViewController.h"
#import "CartModel.h"
#import "SchoolModel.h"
#import "DeliverytimeManager.h"
#import "DeliverytimeModel.h"
#import "SimulateActionSheet.h"

@interface CartViewController()
{
    UIView *conView;
    UIView *shadowView;
    UIView *bottomView;
    RSLabel *totalPriceLabel;
    UIImageView *cartImageView;
    CGFloat totalPrice;
    
    NSArray *categorys;
    NSMutableDictionary *categoryDic;
    
    NSMutableArray *keysArray;
    NSMutableArray *valuesArray;
    NSInteger selectedPickerRow;
    
    UILabel *taptimeLabel;
}
@end

@implementation CartViewController

#pragma mark life cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    conView.backgroundColor = RS_COLOR_WHITE;
    conView.alpha = 1.0;
    [self.view addSubview:conView];
    
    shadowView = [[UIView alloc]init];
    shadowView.backgroundColor = RGBA(0, 0, 0, 0.5);
    [shadowView addTapAction:@selector(disappearView) target:self];
    [self.view addSubview:shadowView];
    
    RSLabel *textLabel = [RSLabel lableViewWithFrame:CGRectMake(18, 0, 100, 32) bgColor:[UIColor clearColor] textColor:RS_COLOR_C2 FontSize:12];
    textLabel.text = @"购物车";
    textLabel.textAlignment = NSTextAlignmentLeft;
    [conView addSubview:textLabel];
    
    RSButton *button = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH -110, 0, 110, 32) ImageName:@"icon_clearcar" Text:@"全部清空" TextColor:RS_COLOR_C2];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    button.titleLabel.font = RS_FONT_F4;
    [conView addSubview:button];
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [[Cart sharedCart] clearAllCartGoods];
        [self initCarData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];
        
        [self disappearView];
    }];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    bottomView.backgroundColor = [NSString colorFromHexString:@"454545"];
    [self.view addSubview:bottomView];
    totalPriceLabel = [RSLabel lableViewWithFrame:CGRectMake(20, 0, 100, 49) bgColor:[UIColor clearColor] textColor:RS_COLOR_WHITE];
    [bottomView addSubview:totalPriceLabel];
    
    RSButton *okbutton = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, 49) ImageName:nil Text:@"去下单" TextColor:RS_COLOR_C7];
    [okbutton setBackgroundColor:[NSString colorFromHexString:@"ffa628"]];
    okbutton.titleLabel.font = RS_FONT_F1;
    [bottomView addSubview:okbutton];
    [okbutton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    cartImageView = [RSImageView imageViewWithFrame:CGRectMake(18, 0, 44, 44) ImageName:@"tab_cart"];
    [shadowView addSubview:cartImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartCountLabel) name:@"Notification_UpadteCartCountLabel" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initCarData];
}

#pragma mark 逻辑
- (void)updateCartCountLabel
{
    [self initCarData];
}

- (void)initCarData
{
    self.models = [NSMutableArray array];
    // 所有的品类
    categorys = [AppConfig getAPPDelegate].schoolModel.categorys;

    //需要展示的分类ID
    NSMutableArray *sectionsArray = [NSMutableArray array];
    
    // 分类好的购物车商品
    NSDictionary *dic = [[Cart sharedCart] getCartsOrderByCategoryid];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
        [self.models addObject:obj];
        [sectionsArray addObject:key];
    }];
    
    //{id : {name:早餐， times : 配送时间}}
    categoryDic = [NSMutableDictionary dictionary];
    for (int i=0; i<categorys.count; i++) {
        Categorys *category = categorys [i];
        if ([sectionsArray containsObject:@(category.categoryid)]) {
            NSDictionary *dic = @{
                                  @"name" : category.name
                                  };
            [categoryDic setValue:dic forKey:[NSString stringFromNumber:@(category.categoryid)]];
        }
    }

    if (self.models.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];
        [self disappearView];
        return;
    }
    
    self.sections = [NSMutableArray array];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.models.count*49);
    self.tableView.height = sectionsArray.count * 30 + [[Cart sharedCart] getCartGoods].count * 49;
    if (self.tableView.height > SCREEN_HEIGHT - 100) {
        self.tableView.height = SCREEN_HEIGHT - 200;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    conView.y = SCREEN_HEIGHT - (32 + self.tableView.height + 49);
    self.tableView.y = conView.y + 32;
    [self.tableView reloadData];
    
    shadowView.frame = CGRectMake(0, 0, SCREEN_WIDTH, conView.y);
    
    __block CGFloat price = 0.00;
    __block NSInteger cartNum = 0;
    NSArray *array = [[Cart sharedCart] getCartGoods];
    [array enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += ([obj.saleprice floatValue] * obj.num);
        cartNum += obj.num;
        
    }];
    
    NSString *priceStr = [NSString stringWithFormat:@"共¥%.2f", price];
    totalPrice = price;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attStr addAttribute:NSFontAttributeName value:RS_FONT_F3 range:NSMakeRange(0, 2)];
    [attStr addAttribute:NSFontAttributeName value:BoldFont(20) range:NSMakeRange(2, priceStr.length-2)];
    totalPriceLabel.attributedText = attStr;
    
    cartImageView.y = shadowView.bottom - 44;
    cartImageView.alpha = 1.0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];

}

#pragma mark talbleViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = RS_COLOR_C6;
    GoodListModel *model = self.models[section][0];
    NSDictionary *dic = [categoryDic valueForKey:[NSString stringFromNumber:@(model.topcategoryid)]];
    NSString *name = [dic valueForKey:@"name"];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 60, 30)];
    namelabel.text = name;
    namelabel.font = RS_FONT_F4;
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.textColor = RS_Theme_Color;
    [view addSubview:namelabel];
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


#pragma mark 事件响应
- (void)okButtonClicked
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
            [RSRoute skipToViewController:@"rsuser://login" model:RSRouteSkipViewControllerNavPresent];
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
    [self.view removeFromSuperview];
    RSCartButtion *button = (RSCartButtion *)CYLExternPlusButton;
    CartNumberLabel *label = [CartNumberLabel shareCartNumberLabel];
    if ([label.text integerValue] > 0) {
        button.highlighted = YES;
    }
}


#pragma mark dealloc
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCartCountLabel" object:nil];
}
@end
