//
//  NSUserDefault+Token.m
//  RedScarf
//
//  Created by lishipeng on 15/12/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "NSUserDefaults+Token.h"

@implementation NSUserDefaults(Token)

+(NSString *) getValue:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:key]) {
        return [defaults objectForKey:key];
    }
    return nil;
}


+(void) setValue:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(void) clearValueForKey:(NSString *) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+(void) setCommuntityId:(NSString *)communtityId
{
    [NSUserDefaults setValue:communtityId forKey:@"communtityId"];
}

+(void) setCommuntityName:(NSString *)communtityName
{
    [NSUserDefaults setValue:communtityName forKey:@"communtityName"];
}

+(NSString *)getCommuntityId
{
    return [NSUserDefaults getValue:@"communtityId"];
}

+(NSString *)getCommuntityName
{
    return [NSUserDefaults getValue:@"communtityName"];
}

@end
