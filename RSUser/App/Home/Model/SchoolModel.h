//
//  SchoolModel.h
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface SchoolModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,assign)NSInteger communtityId;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *closedesc;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,copy)NSString *fastesttime;
@property (nonatomic ,copy)NSString *lastesttime;
@property (nonatomic ,strong)NSArray *subscribedates;
@property (nonatomic ,strong)NSDictionary *deliverytime;
@property (nonatomic ,assign)CGFloat minprice;
@property (nonatomic ,strong)NSArray *channels;
@property (nonatomic, strong) NSString *contactMobile;

+ (void)getSchoolMsg:(void (^)(SchoolModel *))successArray;
@end