//
//  DeliverytimeManager.h
//  RSUser
//
//  Created by 李江 on 16/8/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DeliverytimeModel;

@interface DeliverytimeManager : NSObject
+ (id)shareDelivertimeManger;
- (NSArray *)getTimesByCategoryid:(NSInteger)categoryid;
- (void)addDeliveryTimes:(NSArray *)array categoryid:(NSInteger)categoryid;
+ (void) getDeliveryTimesFromNet:(void (^)(void))sucess;

- (NSDictionary *)getSelectedTimeWithCategoryid:(NSInteger)categoryid;
- (void)setSelectedTimes:(NSDictionary *)dic With:(NSInteger)categoryid;
-(void) clearData;
@end
