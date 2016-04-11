//
//  CartNumberLabel.m
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CartNumberLabel.h"
static CartNumberLabel *shareCarNumberLabel = nil;
@implementation CartNumberLabel
+(id)shareCartNumberLabel{
    @synchronized(self)
    {
        if (shareCarNumberLabel == nil)
        {
            shareCarNumberLabel = [[CartNumberLabel alloc]init];
            
            shareCarNumberLabel.frame = CGRectMake(0, 0, 16, 16);
            shareCarNumberLabel.font = Font(12);
            shareCarNumberLabel.top = -10;
            shareCarNumberLabel.adjustsFontSizeToFitWidth = YES;
            shareCarNumberLabel.textColor = RS_TabBar_count_Color;
            shareCarNumberLabel.backgroundColor = [NSString colorFromHexString:@"ffa53a"];
            shareCarNumberLabel.clipsToBounds = YES;
            shareCarNumberLabel.textAlignment = NSTextAlignmentCenter;
            shareCarNumberLabel.layer.cornerRadius = 8.f;
        }
    }
    return shareCarNumberLabel;
}
@end
