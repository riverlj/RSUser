//
//  GoodModel.m
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodModel.h"
#import "SeckillModel.h"

#define kHEIGHT [AppConfig adapterDeviceHeight:215]
@implementation GoodModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"canbuymax" : @"canbuymax",
             @"saled" : @"saled",
             @"seckill" : @"seckill",
             @"comproductid" : @"id",
             @"price" : @"price",
             @"topcategoryid" : @"topcategoryid",
             @"dashinfo" : @"dashinfo",
             @"headimg" : @"headimg",
             @"saleprice" : @"saleprice",
             @"name" : @"name",
             @"desc" : @"desc",
             @"ishot" : @"ishot",
             @"isnew" : @"isnew",
             @"promotions" : @"promotions"
             };
}


+ (NSValueTransformer *)seckillJSONTransformer {
   return [MTLJSONAdapter dictionaryTransformerWithModelClass:SeckillModel.class];
}

-(NSString *)headimg {
    if (!_headimg) {
        return nil;
    }

    NSString *sizestr = [NSString stringWithFormat:@"@%dw_%.0lfh_1e_1c", (int)SCREEN_WIDTH,kHEIGHT];
    if ([_headimg isAliyImageUrlStr] && ![_headimg hasSuffix:sizestr]) {
        _headimg = [_headimg stringByAppendingString:sizestr];
    }
    return _headimg;
}

+ (NSValueTransformer *)promotionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GoodListpromotion.class];
}
@end