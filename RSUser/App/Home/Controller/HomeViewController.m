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
#import "RSWebViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong)NSMutableArray *bannerImageUrls;
@property (nonatomic ,strong)NSMutableArray *bannerActionUrls;
@property (nonatomic ,strong)NSMutableArray *bannerTitles;
@end

@implementation HomeViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.hasBackBtn = NO;

    
    if (![NSUserDefaults getCommuntityName])
    {
        //TODO 跳转到选择学校页
        [self.navigationController pushViewController:@"" animated:YES];
    }

    self.tableView.tableHeaderView = self.cycleScrollView;
    self.url = @"/weixin/products";
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = YES;
    self.bannerImageUrls = [NSMutableArray new];
    self.bannerActionUrls = [NSMutableArray new];
    self.bannerTitles = [NSMutableArray new];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createLocationView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    
    [self.tableView.mj_header beginRefreshing];
    
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

- (void)createLocationView
{
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateHighlighted];
    [locationBtn setTitle:[NSUserDefaults getCommuntityName] forState:UIControlStateNormal];
    locationBtn.frame = CGRectMake(0, 0, 300, 30);
    locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [locationBtn addTarget:self action:@selector(locationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = locationBtn;

}

- (void)locationBtnClicked
{
    
}

-(SDCycleScrollView *)cycleScrollView
{
    if(_cycleScrollView)
    {
        return _cycleScrollView;
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*200/750) imageURLStringsGroup:nil];
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

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *urlStr = [_bannerActionUrls objectAtIndex:index];
    urlStr = [NSString URLencode:urlStr stringEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"RSUser://bannerWeb?title=%@&urlString=%@",[_bannerTitles objectAtIndex:index],urlStr];

    UIViewController *vc = [RSRoute getViewControllerByPath:path];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)beforeHttpRequest
{
    [super beforeHttpRequest];
    
    [self.params setValue:@"2" forKey:@"communityid"];
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
        goodListModel.cellHeight = 94;
        [self.models addObject:goodListModel];
    }
    
    [self.tableView reloadData];
}

@end
