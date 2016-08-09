//
//  DeliverytimeManager.h
//  RSUser
//
//  Created by 李江 on 16/8/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliverytimeManager : NSObject
+ (id)shareDelivertimeManger;
- (void)setDeliveryTimes:(NSDictionary *)deliveryTimes;
- (NSArray *)getTimesByCategoryid:(NSInteger)categoryid;
- (void)addDeliveryTimes:(NSArray *)array categoryid:(NSInteger)categoryid;
+ (void) getDeliveryTimesFromNet;
@end
