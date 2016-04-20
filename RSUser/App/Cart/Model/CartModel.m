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


+ (void)downLoadCartsWithSuccess:(void (^)(NSArray *))successArray
{
    if (![NSUserDefaults getValue:@"token"]) { //未登录
        return;
    }
    if ([AppConfig getCartMerge] == 1) {    //已经合并过
        return;
    }
    NSDictionary *param = @{
                          @"communityid" : COMMUNTITYID
                          };
    [RSHttp requestWithURL:@"/weixin/downloadcart" params:param httpMethod:@"GET" success:^(id data) {
        NSArray *dataArray = (NSArray *)data;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error = nil;
            CartModel *model = [MTLJSONAdapter modelOfClass:[CartModel class] fromJSONDictionary:dic error:&error];
            if (error) {
                NSLog(@"%@", error);
            }
            [array addObject:model];
        }];
        [CartModel mergeCartWithDownLoadCart:array AndLocalArray:[AppConfig getLocalCartData]];
        successArray([AppConfig getLocalCartData]);
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}

+ (void)pushLocatCart
{
    NSMutableArray *pramaArray = [[NSMutableArray alloc]init];
    NSMutableArray *localArray = [AppConfig getLocalCartData];
    
    [localArray enumerateObjectsUsingBlock:^(CartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *goodsDic = [[NSMutableDictionary alloc]init];
        [goodsDic setValue:[NSNumber numberWithInteger:obj.num] forKey:@"num"];
        [goodsDic setValue:[NSNumber numberWithInteger:obj.comproductid] forKey:@"id"];
        [pramaArray addObject:goodsDic];
    }];
    
    NSString *urlStr = [NSString stringWithFormat:@"/weixin/uploadcart?communityid=%@", COMMUNTITYID];
    [RSHttp requestWithURL:urlStr params:pramaArray httpMethod:@"PUSH" success:^(id data) {
        
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}

+ (void)mergeCartWithDownLoadCart:(NSArray *)downCartArray AndLocalArray:(NSMutableArray *)localCartArray
{
    for (int i=0; i<downCartArray.count; i++) {
        CartModel *downCartModel = downCartArray[i];
        for (int j=0; j<localCartArray.count; j++) {
            CartModel *localCartModel = localCartArray[j];
            if (downCartModel.comproductid == localCartModel.comproductid) {
                localCartModel.num += downCartModel.num;
                break;
            }
        }
    }
    
    [AppConfig saveLocalCartData];
    [AppConfig saveCartMerge];
    
    //合并后更新购物车中的数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

@end
