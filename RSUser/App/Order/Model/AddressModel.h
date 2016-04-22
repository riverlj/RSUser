//
//  AddressModel.h
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface AddressModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,copy)NSString *addressId;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,assign)NSInteger communityid;
@property (nonatomic ,copy)NSString *communityname;
@property (nonatomic ,assign)NSInteger buildingid;
@property (nonatomic ,copy)NSString *buildingname;
@property (nonatomic ,copy)NSString *addition;
@property (nonatomic ,copy)NSString *address;
@property (nonatomic ,assign)BOOL checked;

+ (void)getAddressList: (void(^)(NSArray *))successArray;
+ (void)deleteAddr:(NSString *)addressId successBlock:(void (^)(void))success;
+ (void)editaddr:(NSDictionary *)params successBlock:(void (^)(void))success;
@end
