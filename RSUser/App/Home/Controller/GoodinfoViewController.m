//
//  GoodinfoViewController.m
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodinfoViewController.h"
#import "GoodModel.h"
#import "GoodRateModel.h"

#define kHEIGHT [AppConfig adapterDeviceHeight:215]

@interface GoodinfoViewController ()
{
    UIImage *oldImg1;
    UIImage *oldImg2;
    UIView *statusBarView;
}
@property (nonatomic, strong)UIImageView *headImgeView;
@property (nonatomic, strong)UIImageView *shadowView;


@end

@implementation GoodinfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showCartBottom = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
    
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = NO;
    self.url = @"/product/info";
    
    if (!self.communityid) {
        self.communityid = [COMMUNTITYID integerValue];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    self.tableView.contentInset = UIEdgeInsetsMake(kHEIGHT, 0, 0, 0);
    [self.tableView addSubview:self.headImgeView];
    [self.headImgeView addSubview:self.shadowView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountLabel) name:@"Notification_UpadteCountLabel" object:nil];

    
    [self beginHttpRequest];
}

- (void) updateCountLabel {
    if (self.models.count <= 0) {
        return;
    }
    GoodModel *goodmodel = self.models[0];
    GoodListModel *goodListModel = [[Cart sharedCart] getGoodsCommuntityId:[COMMUNTITYID integerValue] productid:goodmodel.comproductid];
    if (goodListModel) {
        goodmodel.num = goodListModel.num;
    }else {
        goodmodel.num = 0;

    }
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    oldImg1 = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    oldImg2 = [self.navigationController.navigationBar shadowImage];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:oldImg1 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:oldImg2];
    self.navigationController.navigationBar.backgroundColor = RS_Theme_Color;
    
    [statusBarView removeFromSuperview];
}

-(UIImageView *)headImgeView{
    if (_headImgeView) {
        return _headImgeView;
    }
    _headImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kHEIGHT, SCREEN_WIDTH, kHEIGHT)];
    _headImgeView.contentMode = UIViewContentModeScaleAspectFill;
    _headImgeView.clipsToBounds  = YES;
    _headImgeView.tag = 101;
    
    return _headImgeView;
}

-(UIView *)shadowView {
    if (_shadowView) {
        return  _shadowView;
    }
    _shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT)];
    _shadowView.image = [UIImage imageNamed:@"goodImageshadow"];
    _shadowView.contentMode = UIViewContentModeScaleAspectFill;

    return _shadowView;
}

-(void)beforeHttpRequest {
    [super beforeHttpRequest];
    
    self.params = @{
                    @"communityid" : @(self.communityid),
                    @"productid" : @(self.productid)
                    };
}

-(void)afterHttpSuccess:(NSArray *)data {
    NSDictionary *dic = (NSDictionary *)data;
    NSError *error = nil;
    GoodModel *goodModel =[MTLJSONAdapter modelOfClass:[GoodModel class] fromJSONDictionary:dic error:&error];
    [self.headImgeView sd_setImageWithURL:[NSURL URLWithString:goodModel.headimg]];
    
    GoodListModel *goodListModel = [[Cart sharedCart] getGoodsCommuntityId:[COMMUNTITYID integerValue] productid:goodModel.comproductid];
    if (goodListModel) {
        goodModel.num = goodListModel.num;
    }
    
    goodModel.cellClassName = @"GoodInfoSubCell";
    for (int i=0; i<4; i++) {
         GoodModel *goodModel1 = [goodModel copy];
        switch (i) {
            case 0:{
                goodModel1.subText = [NSString stringWithFormat:@"已售%ld份", goodModel1.saled];
                goodModel1.lineHidden = YES;
                goodModel1.cellClassName = @"GoodInfoCell";
                [self.models addObject:goodModel1];
                [self.models addObject:[NSObject new]];
            }
                break;
            case 1:{
                goodModel1.name = @"商品详情";
                goodModel1.subText = goodModel1.dashinfo;
                [self.models addObject:goodModel1];
            }
                break;
            case 2:{
                goodModel1.name = @"商品描述";
                goodModel1.subText = goodModel1.desc;
                goodModel1.hiddenLine = NO;
                [self.models addObject:goodModel1];
            }
                break;
            case 3: {
                GoodRateModel *rateModel = [[GoodRateModel alloc] init];
                rateModel.title = @"商品评价";
                rateModel.tags = rateModel.tags;
                
//                NSMutableArray *array = [NSMutableArray array];
//                for (int i=0; i<10; i++) {
//                    TagModel *gM = [[TagModel alloc] init];
//                    gM.num = @(100);
//                    gM.tagfavorable = 1;
//                    gM.tagcontent = @"好极了";
//                    [array addObject:gM];
//                }
//                rateModel.tags = [array copy];
                
                rateModel.cellClassName = @"GoodRateCell";
                [self.models addObject:rateModel];
            }
                break;
            default:
                break;
        }
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.models[indexPath.row] isKindOfClass:[GoodModel class]]||
        [self.models[indexPath.row] isKindOfClass:[GoodRateModel class]]) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.models[indexPath.row] isKindOfClass:[GoodModel class]] ||
        [self.models[indexPath.row] isKindOfClass:[GoodRateModel class]]) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blankcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blankcell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    cell.backgroundColor = RS_Background_Color;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -kHEIGHT) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}

- (void)backUp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
