//
//  OderLogModel.m
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderLogModel.h"

@implementation OrderLogModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"date" : @"date",
             @"time" : @"time",
             @"content" : @"content",
             @"changetype" : @"changetype",
             @"attr" : @"attr"
             };
}

@end
