//
//  OrderModel.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"orderId" : @"id",
        @"oderdate" : @"date",
        @"dates" : @"dates",
        @"ordertime" : @"ordertime",
        @"statusid" : @"statusid",
        @"status" : @"status",
        @"products" : @"products",
        @"imgurl" : @"imgurl",
    };
}

@end
