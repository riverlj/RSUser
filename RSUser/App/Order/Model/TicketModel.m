//
//  TicketModel.m
//  RedScarf
//
//  Created by lishipeng on 2016-05-04.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "TicketModel.h"

@implementation TicketModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"ticketId" : @"id",
        @"name" : @"name",
        @"type" : @"type",
        @"placeholder" : @"placeholder",
        @"children" : @"children",
    };
}

+ (NSValueTransformer *)childrenJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSArray * jsonArray = value;
        NSMutableArray * childrenArray = [NSMutableArray array];
        
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TicketModel * ticketItem = [MTLJSONAdapter modelOfClass:[TicketModel class] fromJSONDictionary:obj error:nil];
            [childrenArray addObject:ticketItem];
        }];
        
        return childrenArray;
    }];
}

+ (void)createticket:(NSDictionary *)params success:(void (^)(void))successArray
{
    [RSHttp requestWithURL:@"/ticket/create" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] showToast:@"提交成功"];
        successArray();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}
@end
