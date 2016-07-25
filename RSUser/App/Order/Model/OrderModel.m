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
        @"orderdate" : @"date",
        @"dates" : @"dates",
        @"ordertime" : @"ordertime",
        @"statusid" : @"statusid",
        @"status" : @"status",
        @"products" : @"products",
        @"imgurl" : @"imgurl",
        @"business" : @"business"
    };
}

-(NSString *)imgurl{
    if (!_imgurl) {
        return nil;
    }
    NSString *sizestr = [NSString stringWithFormat:@"@71h_71w_0e"];
    if ([_imgurl isAliyImageUrlStr] && ![_imgurl hasSuffix:sizestr]) {
        _imgurl = [_imgurl stringByAppendingString:sizestr];
    }
    return _imgurl;
}
@end
