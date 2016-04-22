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
    
    [CouponModel getCounponList:^(NSArray *couponList) {
        
    }];
    
    [AddressModel getAddressList:^(NSArray *addressList) {
        
    }];
}
@end
