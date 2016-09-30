//
//  SchoolModel.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "SchoolModel.h"

@implementation ChannelViewModel
@end


@implementation ChannelModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"channelId" : @"id",
             @"title" : @"title",
             @"path" : @"path",
             @"appurl" : @"appurl",
             @"h5url" : @"h5url",
             @"needlogin" : @"needlogin"
             };
}

-(NSComparisonResult) sortChannels: (ChannelModel *)another
{
    return self.channelId > another.channelId;
}

@end

@implementation Categorys

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
//             @"addtime" : @"addtime",
             @"name" : @"name",
//             @"pid" : @"pid",
//             @"status" : @"status",
//             @"type" : @"type",
//             @"modtime" :@"modtime",
             @"categoryid" : @"id",
//             @"attr" : @"attr"
             };
}

@end

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
             @"minprice": @"minprice",
             @"contactMobile" : @"contactmobile",
             @"categorys" : @"categorys",
             @"name" : @"name"
             };
}

+ (void)getSchoolMsg:(void (^)(SchoolModel *))successArray
{
    if (!COMMUNTITYID) {
        return;
    }
    NSDictionary *params = @{
                             @"communityid" : COMMUNTITYID
                             };
    [RSHttp requestWithURL:@"/community/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        
        NSError *error = nil;
        SchoolModel *model = [MTLJSONAdapter modelOfClass:[SchoolModel class] fromJSONDictionary:data error:&error];
        NSLog(@"%@", error);
        successArray(model);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]showToast:errmsg];
    }];
}

+ (void)getSchoolMsg:(void (^)(SchoolModel * schoolModel))successArray failure:(void (^)(void))failure schoolid:(NSString *)schoolid
{
    NSString *pschoolid = @"";
    if (schoolid.length > 0) {
        pschoolid = schoolid;
    }else {
        pschoolid = [COMMUNTITYID stringValue];
    }
    if (pschoolid.length <= 0) {
        return;
    }
    NSDictionary *params = @{
                             @"communityid" : pschoolid
                             };
    [RSHttp requestWithURL:@"/community/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        
        NSError *error = nil;
        SchoolModel *model = [MTLJSONAdapter modelOfClass:[SchoolModel class] fromJSONDictionary:data error:&error];
        successArray(model);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]showToast:errmsg];
        failure();
    }];
}

+ (NSValueTransformer *)channelsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ChannelModel.class];
}

+ (NSValueTransformer *)categorysJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Categorys.class];
}

- (NSString *)getCategoryName:(NSInteger)categoryid {
    NSString *name = nil;
    NSArray *array = self.categorys;
    for (int i=0; i<array.count; i++) {
        Categorys *category = array[i];
        if (category.categoryid == categoryid) {
            name = category.name;
            break;
        }
    }
    return name;
}

@end
