//
//  Cart.m
//  RSUser
//
//  Created by 李江 on 16/4/23.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "Cart.h"
#import "LocationModel.h"
#import "DeliverytimeManager.h"
/**
 购物车结构：
 {
    学校ID : {
                carts : []      // 商品列表
                isMerge : 1/0   // 当前学校的购物车是否合并了
                类别ID : {
                            date : 日期
                            time : 时间
                        }
            }
 }
 */
static Cart *shareCart = nil;
@interface Cart()
@property (nonatomic, strong)NSMutableDictionary *cartDataSource;

@end

@implementation Cart

+ (id)sharedCart {
    if (shareCart) {
        return shareCart;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCart = [[self alloc] init];
    });
    return shareCart;
}

- (void)clearDataSource
{
    [self.cartDataSource removeAllObjects];
    [self updateCartCountLabelText];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil];

}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.cartDataSource = [[NSMutableDictionary alloc]init];
    }
    return self;
}

/**
 *  根据学校ID返回购物车
 *
 *  @param communtityId 学校ID
 *
 *  @return 购物车
 */
- (NSMutableDictionary *)getCartByCommuntityId:(NSInteger)communtityId
{
    NSMutableDictionary *cartDic = [self.cartDataSource valueForKey:[NSString stringWithFormat:@"%zd", communtityId]];
    if(cartDic == nil){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [self.cartDataSource setValue:dic forKey:[NSString stringWithFormat:@"%ld", communtityId]];
        return dic;
    }
    
    return cartDic;
}

/**
 *  根据学校ID，产品ID返回当前商品
 *
 *  @param communtityId 学校ID
 *  @param productid    产品ID
 *
 *  @return 商品
 */
- (GoodListModel *)getGoodsCommuntityId:(NSInteger)communtityId productid:(NSInteger)productid
{
    if (productid<=0) {
        return nil;
    }
    
    NSMutableDictionary *dic = [self getCartByCommuntityId:communtityId];
    if (dic) {
         NSArray *array = [dic valueForKey:@"carts"];
        for (int i=0; i<array.count; i++) {
            GoodListModel *model = array[i];
            if (model.comproductid == productid) {
                return model;
            }
        }
    }
    
    return nil;
}

/**
 *  返回当前学校的购物车
 *
 *
 *  @return 购物车
 */
- (NSMutableDictionary *)getCart
{
    NSInteger communtityId = [[LocationModel shareLocationModel].communtityId integerValue];
    NSMutableDictionary *cartDic = [self getCartByCommuntityId:communtityId];
    
    return cartDic;
}

/**
 *  根据学校ID返回购物车中的所有商品
 *
 *  @param communtityId 学校ID
 *
 *  @return 购物车中所有的商品
 */
- (NSMutableArray *)getCartGoodsByCommuntityId:(NSInteger)communtityId
{
    NSMutableDictionary *cartDic = [self.cartDataSource valueForKey:[NSString stringWithFormat:@"%zd", communtityId]];
    if(cartDic == nil){
        return [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *carts = [cartDic valueForKey:@"carts"];
    if (carts == nil) {
        return [[NSMutableArray alloc]init];
    }
    return carts;
}

/**
 *  返回当前学校的购物车中的数据
 */
- (NSMutableArray *)getCartGoods
{
    NSNumber *communtityId = [LocationModel shareLocationModel].communtityId;
    NSMutableArray *carts = [self getCartGoodsByCommuntityId:communtityId.integerValue];
    return carts;
}

/**
 *  根据学校ID返回该学校的购物车是否合并过
 *
 *  @param communtityId
 *
 *  @return
 */
- (NSInteger)getCartMergeByCommuntityId:(NSInteger)communtityId
{
    NSMutableDictionary *cartDic = [self getCartByCommuntityId:communtityId];
    
    NSInteger isMerge = [[cartDic valueForKey:@"isMerge"] integerValue];
    
    return isMerge;
}

/**
 *  返回当前学校的购物车是否和合并过标志
 *
 *  @param communtityId
 *
 *  @return
 */
- (NSInteger)getCartMerge
{
    NSInteger communtityId = [[LocationModel shareLocationModel].communtityId integerValue];
    return [self getCartMergeByCommuntityId:communtityId];
}

/**
 *  添加商品到本地购物车
 *
 *  @param good 商品
 */
- (void)addGoods:(GoodListModel *)good
{
    //当前学校ID
    NSNumber *commutitiyId = [LocationModel shareLocationModel].communtityId;
    
    //当前学校对应的购物车{mg:0, carts=[good1, good2]
    NSMutableDictionary *commutityCart = [self.cartDataSource valueForKey:[NSString stringWithFormat:@"%@",commutitiyId]];
    
    if(commutityCart==nil){
        commutityCart = [[NSMutableDictionary alloc]init];
        [self.cartDataSource setValue:commutityCart forKey:[NSString stringWithFormat:@"%@",commutitiyId]];
    }
    
    //当前学校购物车里面的商品
    NSMutableArray *goodsArray = [commutityCart valueForKey:@"carts"];
    if (goodsArray == nil) {
        goodsArray = [[NSMutableArray alloc]init];
        [commutityCart setValue:goodsArray forKey:@"carts"];
    }
    
    BOOL flag = false;
    for (int i=0; i<goodsArray.count; i++)
    {
        GoodListModel *model = goodsArray[i];
        if (good.comproductid == model.comproductid) {
            model.num ++;
            flag = true;
        }
    }
    if (!flag) {
        good.num = 1;
        GoodListModel *model = [good copy];
        [goodsArray addObject:model];
    }
    
    [self updateCartCountLabelText];
}

/**
 *  减商品
 *
 *  @param good 要减的商品
 */
- (void)deleteGoods:(GoodListModel *)good
{
    NSMutableArray *goods = [self getCartGoods];
    BOOL flag = false;
    NSInteger index = -1;
    for (int i=0; i<goods.count; i++)
    {
        GoodListModel *model = goods[i];
        if (good.comproductid == model.comproductid) {
            model.num --;
            if (model.num == 0) {
                flag = YES;
                index = i;
            }
        }
    }
    if (flag) {
        [goods removeObjectAtIndex:index];
    }
    
    [self updateCartCountLabelText];
}

- (void)clearAllCartGoods
{
    [[self getCartGoods] removeAllObjects];
    [self updateCartCountLabelText];
}

/**
 *  合并购物车
 *
 *  @param goods 要合并的数据
 */
- (void)mergeCartGoods:(NSArray *)goods
{
    NSMutableArray *carts = [self getCartGoods];
    if (carts.count == 0) {
        [goods enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addGoods:obj];
        }];
        return;
    }
    for (int i=0; i<goods.count; i++) {
        GoodListModel *modeli = goods[i];
        BOOL isFindFlag = NO;
        for (int j=0; j<carts.count; j++) {
            GoodListModel *modelj = carts[j];
            if (modelj.comproductid == modeli.comproductid) {
                isFindFlag = YES;
                modelj.num += modeli.num;
            }
        }
        
        if (!isFindFlag) {
            [carts addObject:modeli];
        }
    }
}

/**
 * 返回购物车中的商品数据[{@"id":123, @"num":@"2"},{@"id":234, @"num":@"3"}]
 */
- (NSArray *)filterLocalCartData
{
    NSMutableArray *array = [self getCartGoods];
    NSMutableArray *filterArray = [[NSMutableArray alloc]init];
    [array enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = @{
                              @"id" : @(obj.comproductid),
                              @"num" : @(obj.num)
                              };
        [filterArray addObject:dic];
    }];
    return [filterArray copy];
}

/**
 *  返回购物车视图里返回的数据
 *
 *  @return
 */
-(NSMutableArray *)getCartCellGoods
{
    NSMutableArray *array = [self getCartGoods];
    NSMutableArray *cellArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<array.count; i++) {
        GoodListModel *obj = array[i];
        GoodListModel *model = [[GoodListModel alloc]init];
        model.comproductid = obj.comproductid;
        model.cellHeight = 49;
        model.cellClassName = @"CartCell";
        model.name = obj.name;
        model.num = obj.num;
        model.saleprice = obj.saleprice;
        [cellArray addObject:model];
    }
    
    return cellArray;
}

/**
 *  更新购物车显示的数字
 */
- (void)updateCartCountLabelText
{
    CartNumberLabel *textLabel = [CartNumberLabel shareCartNumberLabel];
    NSMutableArray *goodArray = [self getCartGoods];
    NSInteger num = 0;
    for (int i=0; i<goodArray.count; i++) {
        GoodListModel *model = goodArray[i];
        num += model.num;
    }
    if (num>99) {
        textLabel.text = [NSString stringWithFormat:@"99+"];
    }else{
        textLabel.text = [NSString stringWithFormat:@"%zd", num];
    }
    
    if (num==0) {
        textLabel.text = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil];
}

- (NSInteger)getCartCountLabelText
{
    CartNumberLabel *textLabel = [CartNumberLabel shareCartNumberLabel];
    return [textLabel.text integerValue];
}

- (NSMutableArray *)getCartDetail
{
    NSMutableArray *array = [self getCartGoods];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    [array enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GoodListModel *model = [obj copy];
        model.cellHeight = 30;
        
        [returnArray addObject:model];
    }];
    
    return returnArray;
    
}

/**
 *  根据类别进行分类
 *
 *  @return {id : goods, id:goods}
 */
- (NSDictionary *)getCartsOrderByCategoryid {
    NSArray *array = [self getCartGoodsByCommuntityId:[COMMUNTITYID integerValue]];
    [array enumerateObjectsUsingBlock:^(GoodListModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cellClassName = @"CartCell";
        obj.cellHeight = 49;
    }];
    NSMutableDictionary *groupdic = [self groupAction:array];
    return [groupdic copy];
}

- (NSArray *)getGoodsByCategoryid:(NSInteger)categoryid {
    
    NSDictionary *dic = [self getCartsOrderByCategoryid];
    NSArray *array = dic[@(categoryid)];
    
    NSDictionary *timedic = [[DeliverytimeManager shareDelivertimeManger]getSelectedTimeWithCategoryid:categoryid];
    
    NSMutableArray *filterArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = @{
                              @"id" : @(obj.comproductid),
                              @"num" : @(obj.num),
                              @"deliverytime" : timedic[@"time"]
                              };
        [filterArray addObject:dic];
    }];

    
    return [filterArray copy];
}

- (NSMutableDictionary *)groupAction:(NSArray *)arr {
    NSMutableSet *set = [NSMutableSet set];
    [arr enumerateObjectsUsingBlock:^(GoodListModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:@(model.topcategoryid)];
    }];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [set enumerateObjectsUsingBlock:^(NSString * _Nonnull topcategoryid, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topcategoryid = %@", topcategoryid];
        NSArray *tempArr = [NSArray arrayWithArray:[arr filteredArrayUsingPredicate:predicate]];
        [dic setValue:tempArr forKey:topcategoryid];
    }];
    
    return dic;
}

/**
 *  设置当前购物车的品类对应的配送时间
 *
 *  @param time       配送时间
 *  @param categoryid 品类ID
// */
//- (void)setDeliveryTime:(NSDictionary *)time categoryid:(NSInteger)categoryid {
//    NSMutableDictionary *dic = [self getCart];
//    [dic setValue:time forKey:[NSString stringFromNumber:@(categoryid)]];
//}

/**
 *  根据品类ID 获取对应的配送时间
 *
 *  @param categoryid 品类ID
 *
 *  @return 配送时间
 */
//- (NSDictionary *)getDeliveryTimeByCategoryid:(NSInteger)categoryid {
//    NSMutableDictionary *dic = [self getCart];
//    NSDictionary *resultDic = [dic valueForKey:[NSString stringWithFormat:@"%ld", categoryid]];
//    return resultDic;
//}
@end
