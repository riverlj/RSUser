//
//  BannerModel.m
//  RSUser
//
//  Created by 李江 on 16/4/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BannerModel.h"

#define RequestURL @"/weixin/banner"
@implementation BannerModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"path" : @"path",
             @"url" : @"url",
             @"title" : @"title"
             };
}

+ (void)getBannerArraySuccess:(void (^)(NSArray *))successArray
{
    __block NSMutableArray *array = [NSMutableArray new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@"2" forKey:@"id"];
    [RSHttp requestWithURL:RequestURL params:dic httpMethod:@"GET" success:^(NSArray *data) {
        for (int i=0; i<data.count; i++) {
            NSError *error = nil;
            BannerModel *model = [MTLJSONAdapter modelOfClass:[BannerModel class] fromJSONDictionary:data[i] error:&error];
            [array addObject:model];
        }
        successArray(array);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView] showHUD:errmsg];
    }];
}
@end
