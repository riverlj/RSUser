//
//  channelbrandsViewController.m
//  RSUser
//
//  Created by 李江 on 16/7/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "channelbrandsViewController.h"
#import "BrandListModel.h"
#import "CartModel.h"

@interface ChannelbrandsViewController ()

@end

@implementation ChannelbrandsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌馆";
    
    self.models = [[NSMutableArray alloc]init];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.url = @"/brand/list";
    self.useHeaderRefresh = YES;
    self.useFooterRefresh = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountLabel) name:@"Notification_UpadteCountLabel" object:nil];

    
    [self beginHttpRequest];
    
}

- (void)updateCountLabel
{
    NSMutableArray *cartArray = [[Cart sharedCart] getCartGoods];
    
    [self.models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BrandListModel class]]) {
            BrandListModel *brandListModel = (BrandListModel *)obj;
            NSArray *products = brandListModel.products;
            
            for (int i=0; i<products.count; i++) {
                GoodListModel *model = products[i];
                model.num = 0;
                if (cartArray.count == 0) {
                    model.num = 0;
                    continue;
                }
                
                for (int j=0; j<cartArray.count; j++) {
                    CartModel *cartModel = cartArray[j];
                    if (model.comproductid == cartModel.comproductid)
                    {
                        model.num = cartModel.num;
                    }
                }
            }
        }
    }];
    
    
    [self.tableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)beforeHttpRequest {
    [super beforeHttpRequest];
    self.params = @{
                    @"communityid" : COMMUNTITYID
                    };
}

-(void)afterHttpSuccess:(NSArray *)data {
    [data enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        BrandListModel *brandListModel =[MTLJSONAdapter modelOfClass:[BrandListModel class] fromJSONDictionary:dic error:&error];
        __weak ChannelbrandsViewController *selfB = self;
        brandListModel.clickMoreBtnBlock = ^void(BrandListModel *brandListModel){
            UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://brandinfo?title=%@&brandid=%ld", brandListModel.name, brandListModel.brandId]];
            [selfB.navigationController pushViewController:vc animated:YES];
        };
        [self.models addObject:brandListModel];
        [self.models addObject:[NSObject new]];
    }];
    
    [self updateCountLabel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.models[indexPath.row] isKindOfClass:[BrandListModel class]]) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.models[indexPath.row] isKindOfClass:[BrandListModel class]]) {
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

- (void)backUp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_UpadteCountLabel" object:nil];
}
@end