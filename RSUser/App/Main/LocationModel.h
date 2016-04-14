//
//  RSLocationModel.h
//  RSUser
//
//  Created by 李江 on 16/4/14.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

#define LOCATIONMODEL [LocationModel shareLocationModel]
#define COMMUNTITYID LOCATIONMODEL.communtityId
#define COMMUNITITYNAME LOCATIONMODEL.communtityName

@interface LocationModel : RSModel
@property (nonatomic ,copy)NSString *communtityId;
@property (nonatomic ,copy)NSString *communtityName;
+ (LocationModel *)shareLocationModel;
- (void)setLocationModel:(NSDictionary *)dic;
@end
