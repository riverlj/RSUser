//
//  GoodinfoViewController.m
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodinfoViewController.h"
#import "GoodModel.h"

#define kHEIGHT 250

@interface GoodinfoViewController ()
@property (nonatomic, strong)UIImageView *headImgeView;

@end

@implementation GoodinfoViewController

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
    self.tableView.contentInset = UIEdgeInsetsMake(kHEIGHT, 0, 0, 0);
    [self.tableView addSubview:self.headImgeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountLabel) name:@"Notification_UpadteCountLabel" object:nil];

    
    [self beginHttpRequest];
}

- (void) updateCountLabel {
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
    self.tabBarController.tabBar.hidden = NO;
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
    for (int i=0; i<3; i++) {
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
                goodModel1.name = @"商品详情:";
                goodModel1.subText = goodModel1.dashinfo;
                [self.models addObject:goodModel1];
            }
                break;
            case 2:{
                goodModel1.name = @"商品描述:";
                goodModel1.subText = goodModel1.desc;
                [self.models addObject:goodModel1];
            }
                break;
            default:
                break;
        }
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.models[indexPath.row] isKindOfClass:[GoodModel class]]) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.models[indexPath.row] isKindOfClass:[GoodModel class]]) {
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

@end
