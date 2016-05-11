//
//  UserInfoModel.h
//  RSUser
//
//  Created by 李江 on 16/5/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface UserInfoModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,assign)NSInteger userid;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,assign)NSInteger gender;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,assign)NSInteger mobilemethod;
@property (nonatomic ,assign)CGFloat credit;

@property (nonatomic,copy)NSString *title;
@property (nonatomic ,copy)NSString *url;



+ (void)getUserInfo:(void (^)(UserInfoModel *))success;
@end
