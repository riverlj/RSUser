//
//  CouponModel.h
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"
typedef NS_ENUM(NSUInteger, CouponModelStatus) {
    CouponModelStatusNew = 0,
    CouponModelStatusHistory = 1,
};

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
@property (nonatomic ,strong)NSNumber *money;
@property (nonatomic ,strong)NSNumber *discount;
@property (nonatomic, strong)NSArray *products;
@property (nonatomic, strong)NSArray *disproducts;
@property (nonatomic ,copy)NSString *descriptionstr;
@property (nonatomic ,assign)NSInteger discountmax;
@property (nonatomic ,strong)NSString *reduce;

@property (nonatomic, strong) NSString *fromtype;
@property (nonatomic, assign)BOOL selected;

@property (nonatomic ,copy)NSString *subTitle;
@property (nonatomic ,assign)Boolean hiddenLine;

@property (nonatomic, strong)UIColor *subtextColor;
@property (nonatomic, strong)UIFont *subtextFont;


+ (void)getCounponList:(void(^)(NSArray *))success;
+ (void)bindCoupon:(NSString *)couponcode success:(void(^)())success failure:(void(^)())failure;
-(NSString *) getBeginDate;
-(NSString *) getEndDate;
-(NSMutableAttributedString *)getMoneyStr;
-(NSString *) getRemainStr;
@end