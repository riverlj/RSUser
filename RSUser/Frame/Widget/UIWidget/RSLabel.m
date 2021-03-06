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

+ (RSLabel *)lableViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor FontSize:(CGFloat)fontsize
{
    RSLabel *label = [RSLabel lableViewWithFrame:frame bgColor:bgColor textColor:textColor];
    label.font = Font(fontsize);
    return label;
}

+ (UILabel *) labelOneLevelWithFrame:(CGRect)frame Text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = RS_FONT_F2;
    label.textColor = RS_COLOR_C1;
    label.text = text;
    
    return label;
}

+ (UILabel *) labelTwoLevelWithFrame:(CGRect)frame Text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = RS_FONT_F3;
    label.textColor = RS_COLOR_C3;
    label.text = text;
    
    return label;
}

+ (UILabel *) labellWithFrame:(CGRect)frame Text:(NSString *)text Font:(UIFont *)font TextColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    label.text = text;
    
    return label;
}

+(UILabel *)mainLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textColor = RS_COLOR_C1;
    label.font = RS_FONT_F1;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

+(UILabel *)twoLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textColor = RS_COLOR_C3;
    label.font = RS_FONT_F4;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

+(UILabel *)themeLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textColor = RS_Theme_Color;
    label.font = RS_FONT_F1;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

+(UILabel *)labelWithTextColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    return  label;
}
@end
