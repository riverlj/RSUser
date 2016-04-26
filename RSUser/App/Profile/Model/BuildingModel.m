//
//  BuildingModel.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "BuildingModel.h"

@implementation BuildingModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"buildingid" : @"id",
        @"name" : @"name",
    };
}

@end
