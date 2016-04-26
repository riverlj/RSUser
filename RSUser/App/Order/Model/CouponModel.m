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
             @"descriptionstr" : @"description",
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
    [dic setValue:@"true" forKey:@"giftpromotion"];
    [dic setValue:@"true" forKey:@"moneypromotion"];
    [dic setValue:@"1" forKey:@"platform"];
    [dic setValue:@"true" forKey:@"paypromotion"];
    [dic setValue:@"true" forKey:@"seckill"];
    [dic setValue:[[Cart sharedCart]filterLocalCartData] forKey:@"products"];

    [RSHttp requestWithURL:@"/weixin/orderpromotion" params:dic httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        NSArray *array = [[data valueForKey:@"coupons"] firstObject];
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error = nil;
            CouponModel *model = [MTLJSONAdapter modelOfClass:[CouponModel class] fromJSONDictionary:obj error:&error];
            [returnArray addObject:model];
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        success(returnArray);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView] showToast:errmsg];
    }];
}
@end
