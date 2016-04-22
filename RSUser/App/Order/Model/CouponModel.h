//
//  CouponModel.h
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface CouponModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,assign)NSInteger couponId;
@property (nonatomic ,assign)NSInteger orderid;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *subtitle;
@property (nonatomic ,assign)NSInteger begintime;
@property (nonatomic ,assign)NSInteger endtime;
@property (nonatomic ,assign)NSInteger minfee;
@property (nonatomic ,assign)NSInteger money;
@property (nonatomic ,assign)NSInteger discount;
@property (nonatomic, strong)NSArray *products;
@property (nonatomic, strong)NSArray *disproducts;
@property (nonatomic ,copy)NSString *descriptionstr;
@property (nonatomic ,assign)NSInteger discountmax;
@property (nonatomic ,assign)NSInteger reduce;

+ (void)getCounponList:(void(^)(NSArray *))success;
@end