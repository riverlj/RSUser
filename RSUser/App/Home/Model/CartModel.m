//
//  CartModel.m
//  RSUser
//
//  Created by 李江 on 16/4/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"comproductid" : @"id",
             @"num" : @"num",
             @"productid" : @"productid",
             @"name" : @"name",
             @"saleprice" : @"saleprice",
             @"desc" : @"desc",
             @"headimg" : @"headimg",
             @"saled" : @"saled",
             @"canbuymax" : @"canbuymax",
             @"seckillModel" : @"seckill",
             
             };
}

-(void)setSeckillModel:(SeckillModel *)seckillModel
{
    
}

@end
