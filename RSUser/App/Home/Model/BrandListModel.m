//
//  brandListModel.m
//  RSUser
//
//  Created by 李江 on 16/7/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "brandListModel.h"
#import "GoodListModel.h"

@implementation BrandListModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"brandId" : @"id",
             @"name" : @"name",
             @"logoimg" : @"logoimg",
             @"detailimg" : @"detailimg",
             @"hasmore" : @"hasmore",
             @"products" : @"products"
             };
}

+ (NSValueTransformer *)productsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GoodListModel.class];
}

@end
