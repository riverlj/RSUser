//
//  AddressModel.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"addressId" : @"id",
             @"name" : @"name",
             @"mobile" : @"mobile",
             @"communityid" : @"communityid",
             @"communityname" : @"communityname",
             @"buildingid" : @"buildingid",
             @"buildingname" : @"buildingname",
             @"addition" : @"addition",
             @"address" : @"address",
             @"checked" : @"checked",
             };
}

+ (void)getAddressList: (void(^)(NSArray *))successArray
{
    [RSHttp requestWithURL:@"/weixin/addresses" params:nil httpMethod:@"GET" success:^(NSArray *data) {
        NSMutableArray *addressList = [[NSMutableArray alloc]init];
        [data enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            AddressModel *model = [MTLJSONAdapter modelOfClass:[AddressModel class] fromJSONDictionary:dic error:&error];
            if (error) {
                NSLog(@"%@", error);
            }
            [addressList addObject:model];
        }];
        successArray(addressList);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView] showToast:errmsg];
    }];
}

+ (void)editaddr:(NSDictionary *)params successBlock:(void (^)(void))success
{
    
    [RSHttp requestWithURL:@"/weixin/editaddr" params:params httpMethod:@"POST" success:^(id data) {
        [[RSToastView shareRSAlertView]showToast:@"修改成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView]showToast:@"修改失败"];
    }];
}

+ (void)deleteAddr:(NSString *)addressId successBlock:(void (^)(void))success
{
    NSDictionary *params = @{
                             @"addressid" : addressId
                             };
    [RSHttp requestWithURL:@"/weixin/removeaddr" params:params httpMethod:@"POST" success:^(id data) {
        [[RSToastView shareRSAlertView]showToast:@"删除成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView]showToast:@"修改失败,请重试"];
    }];
}


@end
