//
//  GoodListModel.h
//  RSUser
//
//  Created by 李江 on 16/4/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface GoodListModel : RSModel<MTLJSONSerializing>
/**通用商品销量*/
@property (nonatomic ,assign)NSInteger saled;
/**还可购买份数，-1为不限制，0代表售罄，n代表还可售n份*/
@property (nonatomic ,assign)NSInteger canbuymax;
/**用户购买价*/
@property (nonatomic ,copy)NSString *saleprice;
/**描述文案*/
@property (nonatomic ,copy)NSString *desc;
/**所有商品中的id（使用优惠券的时候用到）*/
@property (nonatomic ,assign)NSInteger productid;
/**学校商品ID（comproductid）*/
@property (nonatomic ,assign)NSInteger comproductid;
/**图片链接*/
@property (nonatomic ,copy)NSString *headimg;
/**名称*/
@property (nonatomic ,copy)NSString *name;
/**原价*/
@property (nonatomic ,copy)NSString *price;


@end
