//
//  DeliverytimeModel.m
//  RSUser
//
//  Created by 李江 on 16/8/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "DeliverytimeModel.h"

@implementation DeliverytimeModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"date" : @"date",
             @"datedesc" : @"datedesc",
             @"time" : @"time"
             };
}
@end
