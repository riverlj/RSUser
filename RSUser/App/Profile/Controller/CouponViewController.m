//
//  CouponViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//
#import "CouponViewController.h"
#import "CouponModel.h"
#import "RSRadioGroup.h"
#import "RSSubTitleView.h"

@interface CouponViewController()
{
    UITextField *textField;
    RSRadioGroup *group;
    NSMutableArray *btnArr;
}

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"/weixin/coupon";
    self.useHeaderRefresh = YES;
    btnArr = [NSMutableArray array];
    NSMutableDictionary *item1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"可用优惠券", @"title", @"canuse", @"key", [NSMutableArray array], @"models", nil];
    [btnArr addObject:item1];
    NSMutableDictionary *item2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"历史代金券", @"title", @"history", @"key", [NSMutableArray array], @"models", nil];
    [btnArr addObject:item2];
    
    [self initButton];
}

-(void)initButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = RS_Line_Color.CGColor;
    view.layer.borderWidth = 1.0;
    group = [[RSRadioGroup alloc] init];
    
    NSInteger i = 0;
    for (NSDictionary *dic in btnArr) {
        RSSubTitleView *title = [[RSSubTitleView alloc] initWithFrame:CGRectMake(0, 0, view.width/[btnArr count], view.height)];
        title.left = i*title.width;
        [title setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [title addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        title.tag = i;
        [view addSubview:title];
        [group addObj:title];
        i ++;
    }
    self.searchType = 0;
    self.tableView.top = view.height ;
    self.tableView.height = SCREEN_HEIGHT - view.height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) didClickBtn:(id)sender
{
    if([sender isKindOfClass:[RSSubTitleView class]]) {
        RSSubTitleView *title = (RSSubTitleView *) sender;
        self.searchType = title.tag;
        [self.tips removeFromSuperview];
    }
}


-(void) setSearchType:(NSInteger)searchType
{
    _searchType = searchType;
    [group setSelectedIndex:searchType];
    if(searchType == 0) {
        self.tableView.tableHeaderView = self.headView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    NSDictionary *dict = [btnArr objectAtIndex:_searchType];
    self.models = [dict objectForKey:@"models"];
    if([self.models count] == 0) {
        [self beginHttpRequest];
    }
}

-(void)beforeHttpRequest{
    [super beforeHttpRequest];
    NSDictionary *dict = [btnArr objectAtIndex:self.searchType];
    [self.params setValue:[dict objectForKey:@"key"] forKey:@"type"];
}
-(void) afterHttpSuccess:(NSArray *)data
{
    NSArray *temp = [[MTLJSONAdapter modelsOfClass:[CouponModel class] fromJSONArray:data error:nil] mutableCopy];
    for(CouponModel *model in temp) {
        model.fromtype = [[btnArr objectAtIndex:_searchType] valueForKey:@"key"];
    }
    NSDictionary *dict = [btnArr objectAtIndex:_searchType];
    [dict setValue:temp forKey:@"models"];
    self.models = [dict objectForKey:@"models"];
    
}

-(UIView *)headView
{
    if(_headView) {
        return _headView;
    }
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _headView.backgroundColor = self.view.backgroundColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 10, SCREEN_WIDTH-36 , 34)];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:bgView];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView.width - 59, bgView.height)];
    textField.delegate = self;
    bgView.layer.borderColor = RS_Line_Color.CGColor;
    bgView.layer.borderWidth = 1;
    [bgView addSubview:textField];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(textField.right, textField.top, bgView.width - textField.width, textField.height)];
    btn.backgroundColor = RS_Theme_Color;
    btn.tintColor = [UIColor whiteColor];
    [btn setTitle:@"兑换" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bindCoupon) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    return _headView;
}

-(BOOL) textFieldShouldReturn:(UITextField *)tField
{
    [tField resignFirstResponder];
    return YES;
}

-(void) bindCoupon
{
    [textField resignFirstResponder];
    [CouponModel bindCoupon:textField.text success:^{
        [self beginHttpRequest];
    } failure:^{
        textField.text = @"";
        [textField becomeFirstResponder];
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponModel *model = (CouponModel *)[self getModelByIndexPath:indexPath];
    if(model) {
        if([model.fromtype isEqualToString:@"canuse"]&&self.selectReturn) {
            [NSKeyedArchiver archiveRootObject:model toFile:[RSFileStorage perferenceSavePath:@"coupon"]];
            if(self.selectReturn) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
@end
