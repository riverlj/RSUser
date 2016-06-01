//
//  HomeViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "HomeViewController.h"
#import "GoodListModel.h"
#import "BannerModel.h"
#import "RSAlertView.h"
#import "RSCartButtion.h"
#import "CartModel.h"
#import "SchoolModel.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong)NSMutableArray *bannerImageUrls;
@property (nonatomic ,strong)NSMutableArray *bannerActionUrls;
@property (nonatomic ,strong)NSMutableArray *bannerTitles;

@end

@interface HomeViewController()
{
    UIButton *locationBtn;
    NSMutableArray *_cartArray;
}
@end
@implementation HomeViewController

#pragma mark 生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    _cartArray = [[NSMutableArray alloc]init];

    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.url = @"/product/list";
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = YES;
    self.bannerImageUrls = [NSMutableArray new];
    self.bannerActionUrls = [NSMutableArray new];
    self.bannerTitles = [NSMutableArray new];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountLabel) name:@"Notification_UpadteCountLabel" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (!COMMUNTITYID)
    {
        [self locationBtnClicked];
        return;
    }

    
    [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
        [AppConfig getAPPDelegate].schoolModel = schoolModel;
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self createLocationView];
    [locationBtn setTitle:COMMUNITITYNAME forState:UIControlStateNormal];
    
    [BannerModel getBannerArraySuccess:^(NSArray *array) {
        [self.bannerActionUrls removeAllObjects];
        [self.bannerImageUrls removeAllObjects];
        [self.bannerTitles removeAllObjects];
        for (int i=0; i<array.count; i++)
        {
            BannerModel *model = array[i];
            [self.bannerImageUrls addObject:model.path];
            [self.bannerActionUrls addObject:model.url];
            [self.bannerTitles addObject:model.title];
        }
        [self initBannerView];
        [self.tableView reloadData];
        
    }];
    
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

#pragma mark 创建View


- (void)createLocationView
{
    locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateHighlighted];
    locationBtn.frame = CGRectMake(0, 25, SCREEN_WIDTH, 30);
    locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    @weakify(self)
    [[locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self locationBtnClicked];
    }];
    self.navigationItem.titleView = locationBtn;
}

-(SDCycleScrollView *)cycleScrollView
{
    if(_cycleScrollView)
    {
        return _cycleScrollView;
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 100) imageURLStringsGroup:nil];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageDotColor = RS_Theme_Color;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.backgroundColor = RS_Background_Color;
    return _cycleScrollView;
}

#pragma View响应方法
- (void)locationBtnClicked
{
    UIViewController *vc = [RSRoute getViewControllerByPath:@"RSUser://chooseSchool"];
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark 网络请求处理
-(void)beforeHttpRequest
{
    [super beforeHttpRequest];
    
    [self.params setValue:COMMUNTITYID forKey:@"communityid"];
    [self.params setValue:@"" forKey:@"channelid"];
    [self.params setValue:@"" forKey:@"brandid"];
}

- (void)afterHttpSuccess:(NSArray *)data
{
    NSError *error = nil;
    for (int i=0; i<data.count; i++) {
        NSDictionary *dic = data[i];
        GoodListModel *goodListModel =[MTLJSONAdapter modelOfClass:[GoodListModel class] fromJSONDictionary:dic error:&error];
        goodListModel.cellClassName = @"GoodListCell";
        goodListModel.cellHeight = 93;
        [self.models addObject:goodListModel];
    }
    
    [self updateCountLabel];
}

#pragma mark SDCycleScrollView广告滚动代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *urlStr = [_bannerActionUrls objectAtIndex:index];
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [NSString URLencode:urlStr stringEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"RSUser://bannerweb?title=%@&urlString=%@",[_bannerTitles objectAtIndex:index],urlStr];

    UIViewController *vc = [RSRoute getViewControllerByPath:path];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScrollViewDelegate

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}

@end
