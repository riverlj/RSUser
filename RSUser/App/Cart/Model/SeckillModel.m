//
//  SeckillModel.m
//  RSUser
//
//  Created by 李江 on 16/4/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "SeckillModel.h"

@implementation SeckillModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"seckillid" : @"seckillid",
             @"begintime" : @"begintime",
             @"endtime" : @"endtime",
             @"saleprice" : @"saleprice",
             @"canbuymax" : @"canbuymax",
             };
}
@end
