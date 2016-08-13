//
//  OrderModel.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderCategory

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"categoryimg" : @"categoryimg",
             @"categoryname" : @"categoryname",
             @"deliverydatetime" : @"deliverydatetime",
             @"productnum" : @"productnum",
             @"topcategoryid" : @"topcategoryid"
             };
}

-(NSString *)categoryimg {
    if (!_categoryimg) {
        return nil;
    }
    NSString *sizestr = [NSString stringWithFormat:@"@142h_142w_0e"];
    if ([_categoryimg isAliyImageUrlStr] && ![_categoryimg hasSuffix:sizestr]) {
        _categoryimg = [_categoryimg stringByAppendingString:sizestr];
    }
    return _categoryimg;
}

@end

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
        @"business" : @"business",
        @"categorys" : @"categorys",
        @"payed" : @"payed",
        @"reduceTime" : @"reduceTime"
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

+ (NSValueTransformer *)categorysJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:OrderCategory.class];
}

- (void)countDown {
    _reduceTime -= 1;
}

- (NSString*)currentTimeString {
    
    if (_reduceTime <= 0) {
        return @"00:00";
        
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)(_reduceTime)/60,(long)(_reduceTime)%60];
    }
}
@end
