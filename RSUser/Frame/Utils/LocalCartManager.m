//
//  LocalCartManager.m
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LocalCartManager.h"

#define COMMUNTITYID_STR [NSString stringWithFormat:@"%@", COMMUNTITYID]
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

- (void)saveData
{
    NSDictionary *dic = [self.allSchoolCartData valueForKey:COMMUNTITYID_STR];
    if (!dic) {
        dic = [NSMutableDictionary new];
    }
    [dic setValue:self.localCartData forKey:@"CARTS"];
    [self.allSchoolCartData setValue:dic forKey:COMMUNTITYID_STR];
}

- (NSMutableArray *)getData
{
    if (!COMMUNTITYID)
    {
        return [NSMutableArray new];
    }
    _localCartData = [[self.allSchoolCartData valueForKey:[NSString stringWithFormat:@"%@", COMMUNTITYID]] valueForKey:@"CARTS"];
    if (!_localCartData) {
        _localCartData = [NSMutableArray new];
    }
    return _localCartData;
}

/**
 * 获取merge标志
 */
- (NSInteger)getMergeFlag
{
    return [[[self.allSchoolCartData valueForKey:COMMUNTITYID_STR] valueForKey:@"isMerge"] integerValue];
}

/**
 *  设置flag
 */
- (void)saveMergeFlag:(NSInteger)merge
{
    [[self.allSchoolCartData valueForKey:COMMUNTITYID_STR] setValue:[NSNumber numberWithInteger:merge] forKey:@"isMerge"];
}

@end
