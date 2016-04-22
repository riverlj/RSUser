//
//  WeiXinLoginUtil.h
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiXinLoginUtil : NSObject
+(void)sendAuthRequest;
+(void)getAccess_token:(NSString *)code;
@end
