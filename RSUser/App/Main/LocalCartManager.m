//
//  LocalCartManager.m
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LocalCartManager.h"

static LocalCartManager *shareLocalCartManager = nil;
@implementation LocalCartManager

+ (LocalCartManager *)shareLocalCartManager
{
    @synchronized (self)
    {
        if (shareLocalCartManager == nil)
        {
            shareLocalCartManager = [[LocalCartManager alloc]init];
            shareLocalCartManager.localCartData = [NSMutableArray new];
            shareLocalCartManager.allSchoolCartData = [NSMutableDictionary new];
        }
    }
    return shareLocalCartManager;
}

- (NSMutableArray *)localCartData
{
    self.localCartData = [_allSchoolCartData valueForKey:[NSString stringWithFormat:@"%@", COMMUNTITYID]];
    return self.localCartData;
}

- (void)setLocalCartData:(NSMutableArray *)localCartData
{
    [_allSchoolCartData setValue:localCartData forKey:[NSString stringWithFormat:@"%@", COMMUNTITYID]];
}

@end
