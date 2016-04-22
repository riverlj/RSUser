//
//  CouponModel.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"couponId" : @"id",
             @"orderid" : @"orderid",
             @"status" : @"status",
             @"type" : @"type",
             @"title" : @"title",
             @"subtitle" : @"subtitle",
             @"begintime" : @"begintime",
             @"endtime" : @"endtime",
             @"minfee" : @"minfee",
             @"money" : @"money",
             @"discount" : @"discount",
             @"products" : @"products",
             @"disproducts" : @"disproducts",
             @"description" : @"descriptionstr",
             @"discountmax" : @"discountmax",
             @"reduce" : @"reduce"
             };
}

+ (void)getCounponList:(void(^)(NSArray *))success
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:COMMUNTITYID forKey:@"communityid"];
    [dic setValue:@"1" forKey:@"business"];
    [dic setValue:@"true" forKey:@"coupon"];
    [dic setValue:@"false" forKey:@"giftpromotion"];
    [dic setValue:@"false" forKey:@"moneypromotion"];
    [dic setValue:@"false" forKey:@"paypromotion"];
    [dic setValue:@"false" forKey:@"seckill"];
    [dic setValue:[AppConfig filterLocalCartData] forKey:@"products"];

    [RSHttp requestWithURL:@"/weixin/orderpromotion" params:dic httpMethod:@"POST" success:^(NSDictionary *data) {
        NSArray *array = [data valueForKey:@"coupons"];
        success(array);
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}
@end
