//
//  ProfileModel.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-22.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
    };
}

-(int)cellHeightWithWidth:(int)width
{
    if(_cellHeight > 0) {
        return _cellHeight;
    }
    _cellHeight = 49;
    return _cellHeight;
}

@end
