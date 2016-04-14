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

@end
