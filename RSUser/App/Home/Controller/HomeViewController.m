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
#import "ChannelbrandsViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong)NSMutableArray *bannerImageUrls;
@property (nonatomic ,strong)NSMutableArray *bannerActionUrls;
@property (nonatomic ,strong)NSMutableArray *bannerTitles;

@property (nonatomic, strong)UIButton *locationBtn;

@end

@interface HomeViewController()
{
    UIView *_naviView;
    
    NSMutableArray *_cartArray;
    NSMutableArray *_channelArray;
    NSMutableArray *_goodListArray;
    Boolean canRefrash;
    
    NSNumber *preCommutityId;
}
@end
@implementation HomeViewController

#pragma mark 生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sections = [NSMutableArray new];
    self.models = [[NSMutableArray alloc]init];
    _channelArray = [[NSMutableArray alloc]init];
    [self.models addObject:_channelArray];
    _goodListArray = [[NSMutableArray alloc]init];
    [self.models addObject:_goodListArray];
    
    _cartArray = [[NSMutableArray alloc]init];
    
    canRefrash = YES;
    
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    
    self.tableView.tableHeaderView = self.cycleScrollView;
    self.url = @"/product/list";
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = YES;
    self.bannerImageUrls = [NSMutableArray new];
    self.bannerActionUrls = [NSMutableArray new];
    self.bannerTitles = [NSMutableArray new];
    
    [self createNaviView];
    
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
    
    [self.locationBtn removeFromSuperview];
    [self.view addSubview:self.locationBtn];
    
    if (![preCommutityId isEqual:COMMUNTITYID]) {
        canRefrash = YES;
    }
    preCommutityId = COMMUNTITYID;
    
    
    if (canRefrash) {
        [self.tableView.mj_header beginRefreshing];
    }

    [self.locationBtn setTitle:COMMUNITITYNAME forState:UIControlStateNormal];
    CGSize size = [COMMUNITITYNAME sizeWithFont:RS_FONT_F1 byHeight:30.0];
    self.locationBtn.frame = CGRectMake((SCREEN_WIDTH-(size.width+50))/2, 25, size.width+50, 30);
    
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
        
    }];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)createNaviView
{
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = RS_Theme_Color;
    _naviView.alpha = 0;
    _naviView.userInteractionEnabled = YES;
}

#pragma mark 逻辑处理
- (void)initChannelData {
    canRefrash = NO;
    
    SchoolModel *schoolModel = [AppConfig getAPPDelegate].schoolModel;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [schoolModel.channels mutableCopy];
    __weak HomeViewController *selfB = self;
    [array enumerateObjectsUsingBlock:^(ChannelModel *channelModel, NSUInteger idx, BOOL * _Nonnull stop) {
        channelModel.clickChennelBlock = ^void(ChannelModel *cmodel){
            ChannelbrandsViewController *vc = [[ChannelbrandsViewController alloc] init];
            [selfB.navigationController pushViewController:vc animated:YES];
        };
    }];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"channelId" ascending:YES];
    [array sortUsingDescriptors:@[sortDesc]];
    
    ChannelViewModel *channelViewModel = [[ChannelViewModel alloc]init];
    channelViewModel.cellClassName = @"ChannelCell";
    channelViewModel.channelsArray = array;
    
    [_channelArray addObject:channelViewModel];
    [self.tableView reloadData];
    
}


- (void)updateCountLabel
{
    NSMutableArray *array = [[Cart sharedCart] getCartGoods];
    
    for (int i=0; i<_goodListArray.count; i++) {
        GoodListModel *model = _goodListArray[i];
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
    
    [_channelArray removeAllObjects];
    [_goodListArray removeAllObjects];
    
    [self.params setValue:COMMUNTITYID forKey:@"communityid"];
    [self.params setValue:@"" forKey:@"channelid"];
    [self.params setValue:@"" forKey:@"brandid"];
}

-(void) beforeProcessHttpData
{
    [[RSToastView shareRSToastView]  hidHUD];
}


- (void)afterHttpSuccess:(NSArray *)data
{
    NSError *error = nil;
    for (int i=0; i<data.count; i++) {
        NSDictionary *dic = data[i];
        GoodListModel *goodListModel =[MTLJSONAdapter modelOfClass:[GoodListModel class] fromJSONDictionary:dic error:&error];
        goodListModel.cellClassName = @"GoodListCell";
        goodListModel.cellHeight = 93;
        [_goodListArray addObject:goodListModel];
    }
    
    [self updateCountLabel];
    
    [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
        [AppConfig getAPPDelegate].schoolModel = schoolModel;
        [self initChannelData];
    }];


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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat naviAlpha = scrollView.contentOffset.y/(SCREEN_HEIGHT*0.25-64);
        _naviView.alpha = naviAlpha;
        
        self.locationBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4-naviAlpha/0.4];
        
        CGFloat naviAlpha1 = scrollView.contentOffset.y/64+1;
        self.locationBtn.alpha = naviAlpha1;
        

    }
}

#pragma mark getter setter
-(UIButton *)locationBtn
{
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateHighlighted];
        _locationBtn.frame = CGRectMake(0, 25, SCREEN_WIDTH, 30);
        _locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        _locationBtn.backgroundColor = [UIColor clearColor];
        _locationBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _locationBtn.layer.cornerRadius = 15;
        
        @weakify(self)
        [[_locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self locationBtnClicked];
        }];
    }
    return _locationBtn;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}

@end
