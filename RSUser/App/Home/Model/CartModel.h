//
//  CartModel.h
//  RSUser
//
//  Created by 李江 on 16/4/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@class SeckillModel;

@interface CartModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,assign)NSInteger comproductid; //学校商品ID
@property (nonatomic ,assign)NSInteger num; //购物车数量
@property (nonatomic ,assign)NSInteger productid; //商品ID（使用优惠券的时候用到）
@property (nonatomic ,copy)NSString *name; //名字
@property (nonatomic ,copy)NSString *price; //原价
@property (nonatomic ,copy)NSString *saleprice; //售价
@property (nonatomic ,copy)NSString *desc;  //描述文案
@property (nonatomic ,copy)NSString *headimg; //图片链接
@property (nonatomic ,assign)NSInteger saled; //商品销量
@property (nonatomic, assign)NSInteger canbuymax; //还可以购买份数
@property (nonatomic, strong) SeckillModel *seckillModel;// 秒杀信息

@end
