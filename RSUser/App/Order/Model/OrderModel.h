//
//  OrderModel.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSModel.h"

@interface OrderCategory: RSModel <MTLJSONSerializing>
@property (nonatomic, strong)NSString *categoryimg;
@property (nonatomic, strong)NSString *categoryname;
@property (nonatomic, strong)NSString *deliverydatetime;
@property (nonatomic, assign)NSInteger productnum;
@property (nonatomic ,assign)NSInteger topcategoryid;
@property (nonatomic ,strong)NSString *ordertime;
@property (nonatomic) NSInteger statusid;

@property (nonatomic, strong)NSString *lastTimeStr;
@end

@interface OrderModel : RSModel<MTLJSONSerializing, NSCoding, NSCopying>
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderdate;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSString *ordertime;
@property (nonatomic) NSInteger statusid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong)NSString *payed;
@property (nonatomic, assign)NSInteger reduceTime;

@property (nonatomic ,assign)NSInteger business;

@property (nonatomic, strong)NSArray *categorys;

- (NSString*)currentTimeString;
- (void)countDown;
@end
