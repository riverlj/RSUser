//
//  UserInfoModel.m
//  RSUser
//
//  Created by 李江 on 16/5/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "UserInfoModel.h"

/**
 
 */
@implementation UserInfoModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userid" : @"id",
             @"name" : @"name",
             @"headimg" : @"headimg",
             @"gender" : @"gender",
             @"mobile" : @"mobile",
             @"mobilemethod" : @"mobilemethod",
             @"credit" : @"credit"
             };
}

+ (void)getUserInfo:(void (^)(UserInfoModel *))success
{
    [RSHttp requestWithURL:@"/user/info" params:nil httpMethod:@"GET" success:^(NSDictionary *data) {
        NSError *error = nil;
        UserInfoModel *model = [MTLJSONAdapter modelOfClass:[UserInfoModel class] fromJSONDictionary:data error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        success(model);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];

}
@end
