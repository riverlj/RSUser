//
//  ConfirmOrderViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "AddressModel.h"
#import "CouponModel.h"

@interface ConfirmOrderViewController ()

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    //获取优惠券信息
    [CouponModel getCounponList:^(NSArray *couponList) {
        
    }];
    
    //获取地址信息
    [AddressModel getAddressList:^(NSArray *addressList) {
        
    }];
}
@end
