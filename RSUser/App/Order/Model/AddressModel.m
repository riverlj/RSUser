//
//  AddressModel.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AddressModel.h"
#import "BuildingModel.h"

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

-(int) cellHeight
{
    return 67;
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

- (void)edit:(void (^)(void))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.addressId forKey:@"id"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.communityid] forKey:@"communityid"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.buildingid] forKey:@"buildingid"];
    [params setValue:self.addition forKey:@"addition"];
    [params setValue:self.mobile forKey:@"mobile"];
    [params setValue:self.name forKey:@"name"];
    
    [[RSToastView shareRSAlertView] showHUD:@"提交中"];
    [RSHttp requestWithURL:@"/weixin/editaddr" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSAlertView] hidHUD];
        [[RSToastView shareRSAlertView]showToast:@"修改成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView] hidHUD];
        [[RSToastView shareRSAlertView]showToast:errmsg];
    }];
}

-(void)select:(void (^)(void))success
{
    NSDictionary *params = @{
        @"addressid" : self.addressId
    };
    [RSHttp requestWithURL:@"/weixin/selectaddr" params:params httpMethod:@"POSTJSON" success:^(id data) {
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView] showToast:errmsg];
    }];
}

- (void)delete:(void (^)(void))success
{
    NSDictionary *params = @{
        @"addressid" : self.addressId
    };
    [RSHttp requestWithURL:@"/weixin/removeaddr" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSAlertView]showToast:@"删除成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView]showToast:errmsg];
    }];
}

- (BOOL) isNewRecord
{
    if(self.addressId == nil) {
        return YES;
    }
    if([self.addressId integerValue] == 0) {
        return YES;
    }
    return NO;
}

- (void)getBuildings:(void(^)(NSArray *))success
{
    NSDictionary *params = @{
        @"communityid" : [NSString stringWithFormat:@"%zd", self.communityid],
    };
    [RSHttp requestWithURL:@"/weixin/buildings" params:params httpMethod:@"GET" success:^(id data) {
        NSArray *models = [MTLJSONAdapter modelsOfClass:[BuildingModel class] fromJSONArray:data error:nil];
        success(models);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView]showToast:errmsg];
    }];
}



-(BOOL) checkValid:(void (^)())success failure:(void (^)(NSString *, NSString *))failure
{
    if(self.communityid == 0) {
        failure(@"community", @"学校不能为空");
        return NO;
    }
    if(self.buildingid == 0) {
        failure(@"building", @"楼栋不能为空");
        return NO;
    }
    if(self.addition == nil || [self.addition isEqualToString:@""]) {
        failure(@"addition", @"寝室号不能为空");
        return NO;
    }
    if(self.name == nil || [self.addition isEqualToString:@""]) {
        failure(@"name", @"收货人姓名不能为空");
        return NO;
    }
    if(self.mobile == nil || [self.mobile isEqualToString:@""]) {
        failure(@"mobile", @"联系电话不能为空");
        return NO;
    }
    //判断收货人姓名
    if([self.name length] > 10) {
        failure(@"name", @"姓名过长");
        return NO;
    }
    //判断收货人电话号码
    if(![self.mobile isMobile]) {
        failure(@"mobile", @"手机号不合法");
        return NO;
    }
    return YES;
}
@end
