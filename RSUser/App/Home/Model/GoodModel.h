//
//  GoodModel.h
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"
#import "AssessmentModel.h"

@class SeckillModel;
@interface GoodModel : RSModel<MTLJSONSerializing>

@property (nonatomic ,assign)NSInteger canbuymax;
@property (nonatomic ,assign)NSInteger saled;
@property (nonatomic, strong)SeckillModel *seckill;
@property (nonatomic ,assign)NSInteger comproductid;
@property (nonatomic ,copy)NSString *price;
@property (nonatomic ,assign)NSInteger topcategoryid;
@property (nonatomic ,copy)NSString *dashinfo;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *saleprice;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *desc;
@property (nonatomic ,assign)Boolean ishot;
@property (nonatomic ,assign)Boolean ishighrated;
@property (nonatomic, strong)NSString *ratescore;
@property (nonatomic, strong)NSArray *ratetag;
@property (nonatomic ,assign)Boolean isnew;
@property (nonatomic, strong)NSArray *promotions;

@property (nonatomic ,assign)Boolean lineHidden;
@property (nonatomic, strong)NSString *subText;

/*选中数量*/
@property (nonatomic ,assign)NSInteger num;

@end
