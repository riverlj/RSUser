//
//  OrderInfoModel.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderInfoModel.h"
#import "OrderLogModel.h"

@implementation OrderInfoModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"orderId" : @"id",
        @"username" : @"username",
        @"mobile" : @"mobile",
        @"address" : @"address",
        @"business" : @"business",
        @"communityid" : @"communityid",
        @"payed" : @"payed",
        @"ordertime" : @"ordertime",
        @"subscribetime" : @"subscribetime",
        @"fastesttime" : @"fastesttime",
        @"lastesttime" : @"lastesttime",
        @"status" : @"status",
        @"statusDesc" : @"statusDesc",
        @"totalprice" : @"totalprice",
        @"paymethod" : @"paymethod",
        @"products" : @"products",
        @"deliverys" : @"deliverys",
        @"orderlog" : @"orderlog",
        @"couponid" : @"couponid",
        @"couponmoney" : @"couponmoney",
        @"coupontitle" : @"coupontitle",
        @"notify" : @"notify",
        @"notifymsg" : @"notifymsg",
        @"notifytime" : @"notifytime",
        @"promotions" : @"promotions",
        @"amount" : @"amount",
        
        @"canpay" : @"canpay",
        @"canreorder" : @"canreorder",
        @"cancancel" : @"cancancel",
        @"canrefund" : @"canrefund",
        @"canrate" : @"canrate",
        @"canticket" : @"canticket",
        @"deliverytime" : @"deliverytime",
        @"canbonus" : @"canbonus",
    };
}

- (OrderInfoModel *)getUserInfoModel
{
    OrderInfoModel *addressModel = [[OrderInfoModel alloc]init];
    addressModel = [self copy];
    addressModel.cellClassName = @"OrderInfoAddressCell";
    addressModel.cellHeight = 60;
    return addressModel;
}

- (OrderInfoModel *)sendTimeModel
{
    OrderInfoModel *sendTimeModel = [self copy];
    sendTimeModel.cellClassName = @"TitleCell";
    sendTimeModel.cellHeight = 49;
    return sendTimeModel;
}

- (OrderInfoModel *)getGoodsDetatil
{
    OrderInfoModel *goodsDetailModel = [self copy];
    goodsDetailModel.cellClassName = @"OrderInfoDetailCell";
    return goodsDetailModel;
}

- (OrderInfoModel *)getOtherInfoModel
{
    OrderInfoModel *otherInfoModel = [self copy];
    otherInfoModel.cellClassName = @"LeftRightLabelCell";
    return otherInfoModel;
}


+ (NSValueTransformer *)orderlogJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSArray * jsonArray = value;
        NSMutableArray * logsArray = [NSMutableArray array];
        
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             OrderLogModel * logItem = [MTLJSONAdapter modelOfClass:[OrderLogModel class] fromJSONDictionary:obj error:nil];
            [logsArray addObject:logItem];
        }];
        
        return logsArray;
    }];
}

- (void)orderPaySuccess:(void(^)(NSString*))success
{
    NSDictionary *params = @{
                             @"orderid" : self.orderId
                             };
    [[RSToastView shareRSToastView]showHUD:@""];
    [RSHttp requestWithURL:@"/order/pay" params:params httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView] hidHUD];
        NSString *url = [data objectForKey:@"url"];
        success(url);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

+ (void)getReOrderInfo:(void(^)(NSArray*))success Orderid:(NSString *)orderid{
    NSDictionary *params = @{
                          @"orderid" : orderid
                          };
    [RSHttp requestWithURL:@"/cart/reorder" params:params httpMethod:@"POSTJSON" success:^(NSArray *data) {
        NSError *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:GoodListModel.class fromJSONArray:data error:&error];
        success(array);
        if (error) {
            [[RSToastView shareRSToastView] showToast:@"再来一单数据解析失败"];
        }
        
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];

    }];
}

+ (void)getOrderInfo:(void(^)(OrderInfoModel*))success Orderid:(NSString *)orderid{
    NSDictionary *params = @{
                             @"orderid" : orderid
                             };
    [RSHttp requestWithURL:@"/order/info" params:params httpMethod:@"GET" success:^(id data) {
        NSError *error = nil;
        OrderInfoModel *orderInfoModel  = [MTLJSONAdapter modelOfClass:[OrderInfoModel class] fromJSONDictionary:data error:&error];
        [[RSToastView shareRSToastView]hidHUD];
        if (error) {
            NSLog(@"%@",error);
        }
        success(orderInfoModel);
    }failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]hidHUD];
        [[RSToastView shareRSToastView]showToast:errmsg];
    }];

}


@end
