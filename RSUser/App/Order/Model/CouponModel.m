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

-(int)cellHeightWithWidth:(int)width
{
    return SCREEN_WIDTH * 100 / 340 + 10;
}

+ (void)getCounponList:(void(^)(NSArray *))success
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:COMMUNTITYID forKey:@"communityid"];
    [dic setValue:@"1" forKey:@"business"];
    [dic setValue:@(true) forKey:@"coupon"];
    [dic setValue:false forKey:@"giftpromotion"];
    [dic setValue:false forKey:@"moneypromotion"];
    [dic setValue:@"2" forKey:@"platform"];
    [dic setValue:false forKey:@"paypromotion"];
    [dic setValue:false forKey:@"seckill"];
    [dic setValue:[[Cart sharedCart]filterLocalCartData] forKey:@"products"];

    [RSHttp requestWithURL:@"/order/promotion" params:dic httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        NSArray *array = [[data valueForKey:@"coupons"] firstObject];
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error = nil;
            CouponModel *model = [MTLJSONAdapter modelOfClass:[CouponModel class] fromJSONDictionary:obj error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            [returnArray addObject:model];
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        success(returnArray);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

+ (void)bindCoupon:(NSString *)couponcode success:(void(^)())success failure:(void(^)())failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"" forKey:@"couponcode"];
    [[RSToastView shareRSToastView] showHUD:@"加载中..."];
    [RSHttp requestWithURL:@"/weixin/bindcoupon" params:params httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:@"兑换成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}

-(NSString *)getBeginDate
{
    return [NSDate formatTimestamp:self.begintime format:@"yyyy-MM-dd"];
}

-(NSString *)getEndDate
{
    return [NSDate formatTimestamp:self.endtime format:@"yyyy-MM-dd"];
}

-(NSMutableAttributedString *)getMoneyStr
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%zd", self.money] attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(18), NSFontAttributeName, RS_Theme_Color, NSForegroundColorAttributeName,nil]];
    [attrStr addAttribute:NSFontAttributeName value:Font(30) range:NSMakeRange(1, attrStr.length-1)];
    return attrStr;
}

-(NSString *) getRemainStr
{
    int days = [NSDate getDayNumbertoDay:[NSDate date] beforDay:[NSDate dateWithTimeIntervalSince1970:self.endtime]];
    if(days < 0) {
        return @"";
    } else if(days == 0) {
        return @"今天将会过期";
    }
    NSString *str = [NSString stringWithFormat:@"还有%d天过期", days];
    return str;
}
@end
