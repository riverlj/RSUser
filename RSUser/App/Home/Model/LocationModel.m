//
//  RSLocationModel.m
//  RSUser
//
//  Created by 李江 on 16/4/14.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LocationModel.h"

static LocationModel *shareLocationModel = nil;
@implementation LocationModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"communtityId" : @"id",
             @"communtityName" : @"name"
             };
}

+ (LocationModel *)shareLocationModel
{
    @synchronized (self)
    {
        if (shareLocationModel == nil)
        {
            shareLocationModel = [[LocationModel alloc]init];
        }
    }
    return shareLocationModel;
}

- (void)setLocationModel:(NSDictionary *)dic
{
    self.communtityId = [dic valueForKey:@"id"];
    self.communtityName = [dic valueForKey:@"name"];
}

+ (void)getSearchResultWithKey:(NSString *)searchKey Result:(void (^)(NSArray *))successArray
{
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSDictionary *param = @{
                          @"q" : searchKey
                          };
    [RSHttp requestWithURL:@"/weixin/search-community" params:param httpMethod:@"GET" success:^(id data) {
        NSArray *array = (NSArray *)data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            LocationModel *model = [MTLJSONAdapter modelOfClass:[LocationModel class] fromJSONDictionary:dic error:nil];
            model.cellHeight = 44;
            model.cellClassName = @"SchoolAddressCell";
            [resultArray addObject:model];
        }];
        successArray(resultArray);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSAlertView] showToast:errmsg];
    }];
}

@end
