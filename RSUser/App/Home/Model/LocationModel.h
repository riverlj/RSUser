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

@interface LocationModel : RSModel<RSFileStorageProtocol,MTLJSONSerializing>
@property (nonatomic ,strong)NSNumber *communtityId;
@property (nonatomic ,copy)NSString *communtityName;
+ (LocationModel *)shareLocationModel;
+ (void)getSearchResultWithKey:(NSString *)searchKey Result:(void (^)(NSArray *))successArray;
- (void)setLocationModel:(NSDictionary *)dic;
- (void)setLocationModelWhithModel:(LocationModel *)model;
- (NSArray *)getCommnitysFromDocument;
@end
