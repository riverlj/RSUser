//
//  DeliverytimeModel.h
//  RSUser
//
//  Created by 李江 on 16/8/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface DeliverytimeModel : RSModel <MTLJSONSerializing>
@property (nonatomic ,strong)NSString *date;
@property (nonatomic ,strong)NSString *datedesc;
@property (nonatomic ,strong)NSArray *time;
@end
