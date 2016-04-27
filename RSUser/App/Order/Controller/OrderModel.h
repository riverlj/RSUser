//
//  OrderModel.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSModel.h"

@interface OrderModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *oderdate;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSString *ordertime;
@property (nonatomic) NSInteger statusid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *imgurl;
@end
