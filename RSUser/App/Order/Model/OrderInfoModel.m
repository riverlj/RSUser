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
        @"canfeedback" : @"canfeedback",
        @"canpay" : @"canpay",
        @"canreorder" : @"canreorder",
        @"cancancel" : @"cancancel",
        @"deliverytime" : @"deliverytime",
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
@end
