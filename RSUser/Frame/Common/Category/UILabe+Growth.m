//
//  UILabel+growth.m
//  RedScarf
//
//  Created by lishipeng on 16/4/12.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "UILabel+Growth.h"

@implementation UILabel(Growth)
-(void)setGrowthAttributedText:(NSAttributedString *)attrStr
{
    self.numberOfLines = 0;
    [self setAttributedText:attrStr];
    CGSize size = [self sizeThatFits:CGSizeMake(self.width, 10000)];
    self.height = size.height;
}

-(void)setGrowthText:(NSString *)str
{
    self.numberOfLines = 0;
    self.text = str;
    CGSize size = [self sizeThatFits:CGSizeMake(self.width, 10000)];
    self.height = size.height;
}
@end
