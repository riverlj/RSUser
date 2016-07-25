//
//  GoodListModel.m
//  RSUser
//
//  Created by 李江 on 16/4/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodListModel.h"

@implementation GoodListModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"saled" : @"saled",
             @"canbuymax" : @"canbuymax",
             @"saleprice" : @"saleprice",
             @"desc" : @"desc",
             @"productid" : @"productid",
             @"comproductid" : @"id",
             @"headimg" : @"headimg",
             @"name" : @"name",
             @"price" : @"price"
             };
}

-(NSString *)headimg {
    if (!_headimg) {
        return nil;
    }
    NSString *sizestr = @"@71h_71w_0e";
    if ([_headimg isAliyImageUrlStr] && ![_headimg hasSuffix:sizestr]) {
        _headimg = [_headimg stringByAppendingString:sizestr];
    }
    return _headimg;
}
@end

