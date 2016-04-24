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
    if ([[Cart sharedCart] getCartMerge] == 1) {    //已经合并过
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
        [[Cart sharedCart] mergeCartGoods:array];
        //TODO 报错，合并报错
        NSMutableArray *cartArray = [[Cart sharedCart] getCartGoods];
        successArray(cartArray);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView  shareRSAlertView]showToast:errmsg];
    }];
}

+ (void)pushLocatCart
{
    NSMutableArray *pramaArray = [[NSMutableArray alloc]init];
    NSMutableArray *localArray = [[Cart sharedCart] getCartGoods];
    
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

//+ (void)mergeCartWithDownLoadCart:(NSArray *)downCartArray
//{
//    NSMutableArray * localCartArray = [AppConfig getLocalCartData];
//    if (localCartArray.count == 0) {
//        [localCartArray addObjectsFromArray: downCartArray];
//    }
//    
//    for (int i=0; i<downCartArray.count; i++) {
//        CartModel *downCartModel = downCartArray[i];
//        BOOL isfind = false;
//        for (int j=0; j<localCartArray.count; j++) {
//            CartModel *localCartModel = localCartArray[j];
//            if (downCartModel.comproductid == localCartModel.comproductid) {
//                localCartModel.num += downCartModel.num;
//                isfind = true;
//                break;
//            }
//        }
//        if (isfind) {
//            continue;
//        }else{
//            [localCartArray addObject:downCartModel];
//        }
//    }
//    
//    [AppConfig saveLocalCartData];
//    [AppConfig saveCartMerge];
//
//    //合并后更新购物车中的数量
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
//
//}

@end
