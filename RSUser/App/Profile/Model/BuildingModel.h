//
//  BuildingModel.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSModel.h"

@interface BuildingModel : RSModel<MTLJSONSerializing>
@property (nonatomic) NSInteger buildingid;
@property (nonatomic, strong) NSString *name;
@end
