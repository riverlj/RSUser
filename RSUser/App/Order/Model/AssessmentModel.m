//
//  AssessmentModel.m
//  RSUser
//
//  Created by 李江 on 16/10/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AssessmentModel.h"

@implementation TagModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"tagid" : @"id",
             @"num" : @"num",
             @"tagcontent" : @"content",
             @"tagfavorable" : @"favorable"
             };
    
}
@end

@implementation AssessmentGoodModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"goodid" : @"id",
             @"goodname" : @"name",
             @"tag" : @"tag"
             };
}
-(NSDictionary *)tagObjs{
    if (_tagObjs) {
        return _tagObjs;
    }
    NSArray *keys = [self.tag allKeys];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i=0; i<keys.count; i++) {
        NSString *key = keys[i];
        NSArray *temp = [self.tag valueForKey:key];
        NSError *error = nil;
        NSArray *model = [MTLJSONAdapter modelsOfClass:TagModel.class fromJSONArray:temp error:&error];
        [dic setValue:model forKey:key];
        
    }
    _tagObjs = dic;
    return _tagObjs;
}

- (NSArray *)getCurrentTags {
    return [self.tagObjs valueForKey:self.currentkey];
}

- (NSArray *)getSelectedTag {
    NSArray *array = [self getCurrentTags];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        TagModel *tagModel = array[i];
        if (tagModel.isSelected) {
            [temp addObject:tagModel.tagid];
        }
    }
    return temp;
}

-(NSString *)currentkey {
    if (_currentkey) {
        return _currentkey;
    }
    return @"0";
}

-(void)setSelected:(Boolean)tagfavorable withTagid:(NSNumber *)tagid {
    NSArray *array = [self getCurrentTags];
    for (int i=0; i<array.count; i++) {
        TagModel *tagModel = array[i];
        if ([tagModel.tagid integerValue] == [tagid integerValue]) {
            tagModel.isSelected = tagfavorable;
        }
    }
}

- (void)setNOFavorable {
    NSArray *array = [self getCurrentTags];
    for (int i=0; i<array.count; i++) {
        TagModel *tagModel = array[i];
        tagModel.isSelected = NO;
    }
}

@end

@implementation AssessmentModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"product" : @"product",
             @"delivery" : @"delivery"
             };
}

+ (NSValueTransformer *)productJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:AssessmentGoodModel.class];
}

+ (NSValueTransformer *)deliveryJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:AssessmentGoodModel.class];
}

+ (void)getAssessmentWithOrderid:(NSString *)orderid success:(void(^)(AssessmentModel *assessmentModel))success failure:(void(^)(void))failure {
    NSDictionary *params = @{
                             @"orderid" : orderid
                          };
    [RSHttp requestWithURL:@"/rate/tag" params:params httpMethod:@"GET" success:^(id data) {
        NSError *error = nil;
        AssessmentModel *assessmentModel = [MTLJSONAdapter modelOfClass:AssessmentModel.class fromJSONDictionary:data error:&error];
        if (error){
//            [[RSToastView shareRSToastView] showToast:@"/rate/tag解析失败"];
        }
        success(assessmentModel);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}

+(void)submitRate:(NSDictionary *)params success:(void (^)(void)) success failure:(void (^) (void)) failure{
    [RSHttp requestWithURL:@"/rate/create/v2" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] showToast:@"评价成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}
@end
