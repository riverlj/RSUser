//
//  PromotionModel.m
//  RSUser
//
//  Created by 李江 on 16/8/9.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "PromotionModel.h"
#import "CouponModel.h"

@implementation PromotionModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"coupons" : @"coupons",
             @"moneypromotions" : @"moneypromotions",
             @"giftpromotions" : @"giftpromotions",
             };
}

+ (NSValueTransformer *)couponsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CouponModel.class];
}

+ (NSValueTransformer *)moneypromotionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:MoneypromotionModel.class];
}

+ (void)getPromotion:(void(^)(PromotionModel *))success
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:COMMUNTITYID forKey:@"communityid"];
    [dic setValue:@"1" forKey:@"business"];
    [dic setValue:@(true) forKey:@"coupon"];
    [dic setValue:@(true) forKey:@"giftpromotion"];
    [dic setValue:@(true) forKey:@"moneypromotion"];
    [dic setValue:@(true) forKey:@"paypromotion"];
    [dic setValue:@(false) forKey:@"seckill"];
    
    [dic setValue:@"2" forKey:@"platform"];
    [dic setValue:[[Cart sharedCart]filterLocalCartData] forKey:@"products"];
    
    [RSHttp requestWithURL:@"/order/promotion" params:dic httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        // Could not convert JSON array to model array, Could not convert JSON array to model array, NSLocalizedFailureReason=Expected an NSDictionary or an NSNull, got: []
        NSError *error = nil;
        NSArray *paypromotionsArray = [data valueForKey:@"paypromotions"];
        NSArray *giftpromotionsArray = [data valueForKey:@"giftpromotions"];
        NSArray *moneypromotionsArray = [data valueForKey:@"moneypromotions"];
        NSArray *couponsArray = [data valueForKey:@"coupons"];
        couponsArray = couponsArray[0];
        PromotionModel *promotionModel = [[PromotionModel alloc]init];
        if (couponsArray.count != 0) {
            NSArray *array = [MTLJSONAdapter modelsOfClass:CouponModel.class fromJSONArray:couponsArray error:nil];
            NSLog(@"%@",array);
            promotionModel.coupons = array;
        }else {
            promotionModel.coupons = nil;
        }
        if (moneypromotionsArray.count != 0) {
            NSArray *array = [MTLJSONAdapter modelsOfClass:MoneypromotionModel.class fromJSONArray:moneypromotionsArray error:nil];
            promotionModel.moneypromotions = array;
        }else {
            promotionModel.moneypromotions = nil;
        }
        
        if (giftpromotionsArray.count > 0) {
            NSArray *array = [MTLJSONAdapter modelsOfClass:GiftPromotionModel.class fromJSONArray:giftpromotionsArray error:nil];
            promotionModel.giftpromotions = array;
        }else {
            promotionModel.giftpromotions = nil;
        }
        
        success(promotionModel);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

@end


@implementation GiftModel
+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"masterid" : @"master",
             @"master_name" : @"master_name",
             @"master_amount" : @"master_amount",
             @"giftid" : @"gift",
             @"gift_name" : @"gift_name",
             @"gift_amount" : @"gift_amount",
             };
}
@end

@implementation GiftPromotionModel
+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"giftpromotionid" : @"id",
             @"type" : @"type",
             @"gift" : @"gift",
             };
}
@end


@implementation MoneypromotionModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"desc" : @"desc",
             @"reduce" : @"reduce",
             @"moneypromotionid" : @"id",
             @"type" : @"type"
             };
}

- (void)setType:(NSInteger)type {
    _type = type;
    switch (_type) {
        case 1:
            _imageName = @"icon_jian";
            break;
        case 2:
            _imageName = @"icon_zhe";
            break;
        case 3:
            _imageName = @"icon_jian";
            break;
        case 4:
            _imageName = @"icon_zhe";
            break;
        case 5:
            _imageName = @"icon_zeng";
            break;
            
        default:
            break;
    }
}

@end

@implementation ConfirmOrderDetailViewModel

@end

@implementation MoneypromotionViewModel

@end
