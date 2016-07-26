//
//  BrandinfoViewController.m
//  RSUser
//
//  Created by 李江 on 16/7/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BrandinfoViewController.h"
#import "SDCycleScrollView.h"
#import "BrandListModel.h"
#import "CartModel.h"

@interface BrandinfoViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic ,strong)NSMutableArray *bannerImageUrls;
@end

@implementation BrandinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url = @"/brand/info";
    self.navigationItem.title= self.navtitle;
    self.models = [[NSMutableArray alloc]init];
    self.bannerImageUrls = [[NSMutableArray alloc] init];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountLabel) name:@"Notification_UpadteCountLabel" object:nil];
    
    [self beginHttpRequest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)updateCountLabel
{
    NSMutableArray *array = [[Cart sharedCart] getCartGoods];
    
    for (int i=0; i<self.models.count; i++) {
        GoodListModel *model = self.models[i];
        model.num = 0;
        if (array.count == 0) {
            model.num = 0;
            continue;
        }
        
        for (int j=0; j<array.count; j++) {
            CartModel *cartModel = array[j];
            if (model.comproductid == cartModel.comproductid)
            {
                model.num = cartModel.num;
            }
        }
    }
    
    [self.tableView reloadData];
    
}

-(void)beforeHttpRequest {
    [super beforeHttpRequest];
    [self.params setValue:COMMUNTITYID forKey:@"communityid"];
    [self.params setValue:@(self.brandid) forKey:@"brandid"];
}

-(void)afterHttpSuccess:(NSArray *)data{
    NSDictionary *dic = (NSDictionary *)data;
    
    NSError *error = nil;
    BrandListModel *brandListModel = [MTLJSONAdapter modelOfClass:[BrandListModel class] fromJSONDictionary:dic error:&error];
    NSLog(@"%@",error);
    
    NSArray *brannerImgs = [brandListModel.detailimg copy];
    [self.bannerImageUrls removeAllObjects];
    [self.bannerImageUrls addObjectsFromArray:brannerImgs];
    [self initBannerView];
    
    NSArray *brandlistArray = [brandListModel.products copy];
    [brandlistArray enumerateObjectsUsingBlock:^(GoodListModel* goodListModel, NSUInteger idx, BOOL * _Nonnull stop) {
        goodListModel.cellClassName = @"GoodListCell";
        goodListModel.cellHeight = 93;
        
    }];
    [self.models addObjectsFromArray:brandlistArray];
    
    [self updateCountLabel];
    
}

-(SDCycleScrollView *)cycleScrollView
{
    if(_cycleScrollView)
    {
        return _cycleScrollView;
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 150) imageURLStringsGroup:nil];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageDotColor = RS_Theme_Color;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.backgroundColor = RS_Background_Color;
    return _cycleScrollView;
}

-(void)initBannerView
{
    if (_bannerImageUrls.count < 2)
    {
        self.cycleScrollView.infiniteLoop = NO;
        self.cycleScrollView.autoScroll = NO;
    }
    else
    {
        self.cycleScrollView.infiniteLoop = YES;
        self.cycleScrollView.autoScroll = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.imageURLStringsGroup = _bannerImageUrls;
    });
}

#pragma mark SDCycleScrollView广告滚动代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    return;
}

- (void)backUp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}


@end
