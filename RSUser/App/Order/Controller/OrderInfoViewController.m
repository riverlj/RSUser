//
//  OrderInfoViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderInfoModel.h"

@interface OrderInfoViewController()

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.url = @"/order/info";
    
    self.sections = [NSMutableArray new];
    [self beginHttpRequest];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);

}

-(void)beforeHttpRequest{
    [super beforeHttpRequest];
    [self.params setValue:self.orderId forKey:@"orderid"];

}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    OrderInfoModel *model = [MTLJSONAdapter modelOfClass:[OrderInfoModel class] fromJSONDictionary:data error:nil];
    
    OrderInfoModel *addressModel = [model getUserInfoModel];
    
    NSMutableArray *tempArr1 = [NSMutableArray array];
    [tempArr1 addObject:addressModel];
    [self.models addObject:tempArr1];
    
    NSMutableArray *tempArr2 = [NSMutableArray array];
    OrderInfoModel *sendTimeModel = [model sendTimeModel];
    [tempArr2 addObject:sendTimeModel];
        OrderInfoModel *goodsDetailModel = [model getGoodsDetatil];
    [tempArr2 addObject:goodsDetailModel];
    [self.models addObject:tempArr2];
    
    NSMutableArray *tempArr3 = [NSMutableArray array];
    OrderInfoModel *otherInfoModel1 = [model getOtherInfoModel];
    otherInfoModel1.displayFlag = 1;
    OrderInfoModel *otherInfoModel2 = [model getOtherInfoModel];
    otherInfoModel2.displayFlag = 2;
    OrderInfoModel *otherInfoModel3 = [model getOtherInfoModel];
    otherInfoModel3.displayFlag = 3;
    [tempArr3 addObject:otherInfoModel1];
    [tempArr3 addObject:otherInfoModel2];
    [tempArr3 addObject:otherInfoModel3];
    [self.models addObject:tempArr3];
    
    NSMutableArray *tempArr4 = [NSMutableArray array];
    OrderInfoModel *otherInfoModel41 = [model getOtherInfoModel];
    otherInfoModel41.displayFlag = 4;
    OrderInfoModel *otherInfoModel42 = [model getOtherInfoModel];
    otherInfoModel42.displayFlag = 5;
    OrderInfoModel *otherInfoModel43 = [model getOtherInfoModel];
    otherInfoModel43.displayFlag = 6;
    [tempArr4 addObject:otherInfoModel41];
    [tempArr4 addObject:otherInfoModel42];
    if (otherInfoModel43.paymethod.length != 0) {
        [tempArr4 addObject:otherInfoModel43];
    }
    [self.models addObject:tempArr4];
    
    [self.tableView reloadData];
    
}


#pragma mark tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
@end
