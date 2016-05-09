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
            [shareLocationModel getFristSchool];
        }
    }
    return shareLocationModel;
}

- (void)getFristSchool
{
    NSArray *array = [self getCommnitysFromDocument];
    
    if (array.count>0) {
        self.communtityId = [array[0] valueForKey:@"communtityId"];
        self.communtityName = [array[0] valueForKey:@"communtityName"];
    }
    
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
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

- (void)setLocationModel:(NSDictionary *)dic
{
    self.communtityId = [dic valueForKey:@"id"];
    self.communtityName = [dic valueForKey:@"name"];
}

- (void)setLocationModelWhithModel:(LocationModel *)model
{
    self.communtityId = model.communtityId;
    self.communtityName = model.communtityName;
}

- (NSArray *)getCommnitysFromDocument
{
    NSString *path = [RSFileStorage perferenceSavePath:[self getClassName]];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}


- (void)save
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self getCommnitysFromDocument]];
    BOOL flag = NO;
    NSInteger index = 0;
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        if ([[dic valueForKey:@"communtityId"] isEqualToNumber:self.communtityId]) {
            index = i;
            flag = YES;
        }
    }
    
    if (flag) { // 存在
        [array exchangeObjectAtIndex:index withObjectAtIndex:0];
    }else{
        NSDictionary *dic = @{
                              @"communtityId": self.communtityId,
                              @"communtityName": self.communtityName
                              };
        [array insertObject:dic atIndex:0];
    }
    
    if (array.count > 3) {  //
        [array removeLastObject];
    }
    
    NSString *path = [RSFileStorage perferenceSavePath:[self getClassName]];
    [array writeToFile:path atomically:YES];
    
}

- (void)clear
{
    [RSFileStorage removeFile:[self getClassName]];
}

@end
