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
             @"price" : @"price",
             @"topcategoryid" : @"topcategoryid"
             };
}

-(NSString *)headimg {
    if (!_headimg) {
        return nil;
    }
    NSString *sizestr = @"@140w_140h_1e_1c";
    if ([_headimg isAliyImageUrlStr] && ![_headimg hasSuffix:sizestr]) {
        _headimg = [_headimg stringByAppendingString:sizestr];
    }
    return _headimg;
}
@end

