//
//  TicketModel.h
//  RedScarf
//
//  Created by lishipeng on 2016-05-04.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSModel.h"

@interface TicketModel : RSModel<MTLJSONSerializing>
@property (nonatomic,assign) NSInteger ticketId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic ,assign)NSInteger ismodelSelected;  //0 未选中， 1 选中

+ (void)createticket:(NSDictionary *)params success:(void (^)(void))successArray;@end
