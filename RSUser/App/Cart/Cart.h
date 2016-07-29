//
//  Cart.h
//  RSUser
//
//  Created by 李江 on 16/4/23.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodListModel.h"

@interface Cart : NSObject
+ (id)sharedCart;
- (void)clearDataSource;
- (NSMutableDictionary *)getCartByCommuntityId:(NSInteger)communtityId;
- (NSMutableArray *)getCartGoodsByCommuntityId:(NSInteger)communtityId;
- (GoodListModel *)getGoodsCommuntityId:(NSInteger)communtityId productid:(NSInteger)productid;
- (NSMutableDictionary *)getCart;
- (NSMutableArray *)getCartGoods;

- (NSInteger)getCartMerge;
- (NSInteger)getCartMergeByCommuntityId:(NSInteger)communtityId;

- (void)addGoods:(GoodListModel *)good;
- (void)deleteGoods:(GoodListModel *)good;
- (void)mergeCartGoods:(NSArray *)goods;
- (NSArray *)filterLocalCartData;

-(NSMutableArray *)getCartCellGoods;

- (NSInteger)getCartCountLabelText;
- (void)clearAllCartGoods;

- (NSMutableArray *)getCartDetail;
@end
