//
//  ChooseCouponViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/16.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ChooseCouponViewController.h"
#import "CouponModel.h"

@interface ChooseCouponViewController ()

@end

@implementation ChooseCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择优惠券";
    
    [self.couponArray enumerateObjectsUsingBlock:^(CouponModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cellClassName = @"CouponCell";
        obj.fromtype = @"canuse";
    }];
    self.models = [[NSMutableArray alloc]init];
    [self.models addObjectsFromArray:self.couponArray];
    [self.tableView reloadData];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponModel *model = (CouponModel *)[self getModelByIndexPath:indexPath];
    [NSKeyedArchiver archiveRootObject:model toFile:[RSFileStorage perferenceSavePath:@"coupon"]];
    self.selectedCouponBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

@end
