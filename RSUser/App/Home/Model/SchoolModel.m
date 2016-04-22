//
//  SchoolModel.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "SchoolModel.h"

@implementation SchoolModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"communtityId" : @"id",
             @"closedesc" : @"closedesc",
             @"status" : @"status",
             @"fastesttime" : @"fastesttime",
             @"lastesttime" : @"lastesttime",
             @"subscribedates" : @"subscribedates",
             @"deliverytime" : @"deliverytime",
             @"channels": @"channels",
             @"minprice": @"minprice"
             };
}

+ (void)getSchoolMsg:(void (^)(SchoolModel *))successArray
{
    NSDictionary *params = @{
                             @"id" : COMMUNTITYID
                             };
    [RSHttp requestWithURL:@"/weixin/communityinfo" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        
        NSError *error = nil;
        SchoolModel *model = [MTLJSONAdapter modelOfClass:[SchoolModel class] fromJSONDictionary:data error:&error];
        NSLog(@"%@", error);
        successArray(model);
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}
@end
