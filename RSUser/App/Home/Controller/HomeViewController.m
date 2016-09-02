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
#import "CartModel.h"
#import "SchoolModel.h"
#import "ChannelbrandsViewController.h"
#import "RSJSWebViewController.h"
#import "DeliverytimeManager.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong)NSMutableArray *bannerImageUrls;
@property (nonatomic ,strong)NSMutableArray *bannerActionUrls;
@property (nonatomic ,strong)NSMutableArray *bannerTitles;

@property (nonatomic, strong)UIButton *locationBtn;

@end

@interface HomeViewController()
{
    UIView *_naviView;
    
    NSArray *_goodsArray;
    
    NSMutableArray *_channelArray;
    NSMutableArray *_goodListArray;
    Boolean canRefrash;
    
    NSNumber *preCommutityId;
    UIView *_goodTypeContentView;
    UIView *_categoryView;
    
    RSRadioGroup *group;
    NSInteger groupSelectedIndex;
    NSInteger selectedCategoryId;
}
@end
@implementation HomeViewController

#pragma mark 生命周期
-(instancetype)init {
    self = [super init];
    if (self) {
        self.tableStyle = UITableViewStylePlain;
    }
    return self;
}

-(void)initSourceDate {
    self.models = [[NSMutableArray alloc]init];
    
    _channelArray = [[NSMutableArray alloc]init];
    [self.models addObject:_channelArray];
    
    _goodListArray = [[NSMutableArray alloc]init];
    [self.models addObject:_goodListArray];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.sections = [NSMutableArray new];
    [self initSourceDate];
    
    canRefrash = YES;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    self.url = @"/product/list";
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = YES;
    
    self.bannerImageUrls = [NSMutableArray new];
    self.bannerActionUrls = [NSMutableArray new];
    self.bannerTitles = [NSMutableArray new];
    
    [self createNaviView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeVC) name:@"Notification_UpadteCountLabel" object:nil];
    
}

- (void)updateHomeVC {
    [self refeshTableWithType:@(selectedCategoryId)];
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
    
    self.navigationController.navigationBar.hidden = YES;

}

- (void)requestBanner{
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
}

- (void)createNaviView
{
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = RS_Theme_Color;
    _naviView.alpha = 1;
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
            if (cmodel.channelId == 4 || cmodel.channelId == 5) {
                [[RSToastView shareRSToastView] showToast:@"敬请期待...."];
                return;
            }
            if ([cmodel.appurl hasPrefix:@"RSUser://"]) {
                UIViewController *vc = [RSRoute getViewControllerByPath:cmodel.appurl];
                [selfB.navigationController pushViewController:vc animated:YES];
                return;
            }
            if ([cmodel.appurl hasPrefix:@"/"]) {
                if (!cmodel.needlogin || (cmodel.needlogin && [AppConfig getAPPDelegate].userValid)) {
                    RSJSWebViewController *vc = [[RSJSWebViewController alloc] init];
                    NSString* urlStr = [NSString URLencode:[cmodel.appurl urlWithHost:APP_CHANNEL_BASE_URL] stringEncoding:NSUTF8StringEncoding];
                    vc.urlString = urlStr;
                    [selfB.navigationController pushViewController:vc animated:YES];
                }else {
                    UIViewController *vc = [RSRoute getViewControllerByPath:@"RSUser://login"];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [[AppConfig getAPPDelegate].window.rootViewController presentViewController:nav animated:YES completion:nil];
                }
            }
        };
    }];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"channelId" ascending:YES];
    [array sortUsingDescriptors:@[sortDesc]];
    
    ChannelViewModel *channelViewModel = [[ChannelViewModel alloc]init];
    channelViewModel.cellClassName = @"ChannelCell";
    channelViewModel.channelsArray = array;
    
    [_channelArray addObject:channelViewModel];
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
}

#pragma mark 创建View

-(SDCycleScrollView *)cycleScrollView
{
    if(_cycleScrollView)
    {
        return _cycleScrollView;
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 128*(SCREEN_WIDTH/320)) imageURLStringsGroup:nil];
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
    [self initSourceDate];
    [self requestBanner];
    
    [self.params setValue:COMMUNTITYID forKey:@"communityid"];
    [self.params setValue:@"" forKey:@"channelid"];
    [self.params setValue:@"" forKey:@"brandid"];
}

-(void) beforeProcessHttpData {
    [[RSToastView shareRSToastView]  hidHUD];
}


- (void)afterHttpSuccess:(NSArray *)data
{
    _goodsArray = [data copy];
    NSError *error = nil;
        
    for (int i=0; i<data.count; i++) {
        NSDictionary *dic = data[i];
        GoodListModel *goodListModel =[MTLJSONAdapter modelOfClass:[GoodListModel class] fromJSONDictionary:dic error:&error];
        goodListModel.cellClassName = @"GoodListCell";
        [_goodListArray addObject:goodListModel];
    }
    
    __weak HomeViewController *selfB = self;
    [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
        [AppConfig getAPPDelegate].schoolModel = schoolModel;
        _categoryView = [selfB creatTypeGroupView];
        [selfB initChannelData];
        [selfB refeshTableWithType:@(selectedCategoryId)];
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
    if (section == 1) {
        if ([AppConfig getAPPDelegate].schoolModel.categorys.count > 1) {
            return 42;
        }else{
            return 0;
        }
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==0) {
         return [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        NSArray *array = [AppConfig getAPPDelegate].schoolModel.categorys;
        if (array.count <= 1) {
            return nil;
        }else{
            return  _categoryView;
        }
    }
    return nil;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *view = [self.tableView headerViewForSection:1];
    CGFloat header = view.frame.origin.y;
    
    if (scrollView == self.tableView) {
        CGFloat naviAlpha = scrollView.contentOffset.y/(SCREEN_HEIGHT*0.25-64);
        _naviView.alpha = naviAlpha;
        
        self.locationBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4-naviAlpha/0.4];
        
        CGFloat naviAlpha1 = scrollView.contentOffset.y/64+1;
        self.locationBtn.alpha = naviAlpha1;
        
        if (scrollView.contentOffset.y <= 64) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else if(scrollView.contentOffset.y>header)  {
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    RSModel *model = [self getModelByIndexPath:indexPath];
    
    if ([model isKindOfClass:[GoodListModel class]]) {
        GoodListModel *goodListModel = (GoodListModel*)model;
        NSString *path = [NSString stringWithFormat:@"RSUser://goodinfo?communityid=%@&productid=%ld",COMMUNTITYID, goodListModel.comproductid];
        UIViewController *vc = [RSRoute getViewControllerByPath:path];
        [self.navigationController pushViewController:vc animated:YES];
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
        _locationBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _locationBtn.layer.cornerRadius = 15;
        
        @weakify(self)
        [[_locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self locationBtnClicked];
        }];
    }
    return _locationBtn;
}


- (UIView *)creatTypeGroupView {
    NSArray *categorysArr = [AppConfig getAPPDelegate].schoolModel.categorys;
    if (categorysArr.count <=1) {
        return nil;
    }
    
    NSMutableArray *groupArray = [[NSMutableArray alloc]init];
    NSDictionary *btn1 = @{
                           @"title":@"全部",
                           @"key":@"0",
                           @"models":[NSMutableArray array],
                           @"index" : @"0"
                           };
    [groupArray addObject:btn1];
    
    for (int i=0; i<categorysArr.count; i++) {
        Categorys *category = categorysArr[i];
        NSDictionary *dic = @{
                              @"title" : category.name,
                              @"key" : @(category.categoryid),
                               @"models":[NSMutableArray array],
                              @"index" : @(i+1)
                              };
        [groupArray addObject:dic];
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view setBorderWithView:view top:NO left:NO bottom:YES right:NO borderColor:RS_Line_Color borderWidth:1];
    
    group = [[RSRadioGroup alloc] init];
    
    for (int i=0; i<groupArray.count; i++) {
        NSDictionary *dic = groupArray[i];
        RSSubButtonView *title = [[RSSubButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.width/[groupArray count], view.height)];;
        
        title.left = i*title.width;
        title.tag = [[dic valueForKey:@"key"] integerValue];
        title.nameLabel.text = [dic valueForKey:@"title"] ;
        title.index = [[dic valueForKey:@"index"] integerValue];
        [title addTapAction:@selector(didClickBtn:) target:self];
        [view addSubview:title];
        [group addObj:title];
    }
    
    [group setSelectedIndex:groupSelectedIndex];
    return view;
}

- (void)didClickBtn:(UITapGestureRecognizer *)sender {
    RSSubButtonView *title = (RSSubButtonView *)sender.view;
    groupSelectedIndex = title.index;
    selectedCategoryId = sender.view.tag;
    [self refeshTableWithType:@(selectedCategoryId)];

}

- (void)refeshTableWithType:(id)obj{
    NSArray *categroys = [AppConfig getAPPDelegate].schoolModel.categorys;
    NSMutableArray *allCategoryId = [[NSMutableArray alloc]init];
    for (int i=0; i<categroys.count; i++) {
        Categorys *category = categroys[i];
        [allCategoryId addObject:@(category.categoryid)];
    }
    
    NSMutableSet *set=[NSMutableSet set];
    [_goodsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [set addObject:obj[@"topcategoryid"]];
    }];
    
    NSPredicate *predicate ;
    NSArray *tempArray;
    if ([obj integerValue] == 0) {
        tempArray = _goodsArray;
    }else {
        predicate = [NSPredicate predicateWithFormat:@"topcategoryid = %@", obj];
        tempArray = [_goodsArray filteredArrayUsingPredicate:predicate];
    }
    
    [_goodListArray removeAllObjects];
    for (int i=0; i<tempArray.count; i++) {
        NSDictionary *dic = tempArray[i];
        GoodListModel *goodListModel =[MTLJSONAdapter modelOfClass:[GoodListModel class] fromJSONDictionary:dic error:nil];
        goodListModel.cellClassName = @"GoodListCell";
        [_goodListArray addObject:goodListModel];
        if (i==tempArray.count-1) {
            goodListModel.hiddenLine = YES;
        }
    }
    
    [self updateCountLabel];
    
    [self.tableView reloadData];
    [group setSelectedIndex:groupSelectedIndex];

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}

@end
