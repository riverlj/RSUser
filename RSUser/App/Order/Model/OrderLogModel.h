//
//  OderLogModel.h
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface OrderLogModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,strong)NSString *date;
@property (nonatomic ,strong)NSString *time;
@property (nonatomic ,strong)NSString *content;
@property (nonatomic ,assign)NSInteger changetype;
@property (nonatomic ,strong)NSArray *attr;
@end
