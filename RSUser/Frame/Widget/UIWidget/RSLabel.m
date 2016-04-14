//
//  RSLabel.m
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSLabel.h"

@implementation RSLabel
+ (RSLabel *)lableViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor
{
    RSLabel *label = [[RSLabel alloc]initWithFrame:frame];
    label.backgroundColor = bgColor;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
