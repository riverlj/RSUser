//
//  CustomNSURLProtocol.m
//  RSUser
//
//  Created by 李江 on 16/7/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CustomNSURLProtocol.h"

@implementation CustomNSURLProtocol
+(void)load
{
    [NSURLProtocol registerClass:self];
}
+ (BOOL)canInitWithRequest:(NSMutableURLRequest *)request
{
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        [(id)request setValue:[NSUserDefaults getValue:@"token"] forHTTPHeaderField:@"token"];
    }
    return NO;
}
@end
