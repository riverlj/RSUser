//
//  SeckillModel.h
//  RSUser
//
//  Created by 李江 on 16/4/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface SeckillModel : RSModel<MTLJSONSerializing>

@property (nonatomic ,assign)NSInteger seckillid;
@property (nonatomic ,assign)NSInteger begintime;
@property (nonatomic ,assign)NSInteger endtime;
@property (nonatomic ,copy)NSString *saleprice;
@property (nonatomic ,assign)NSInteger canbuymax;

@end
