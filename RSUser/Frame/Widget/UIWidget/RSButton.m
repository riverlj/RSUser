//
//  RSButton.m
//  RSUser
//
//  Created by 李江 on 16/4/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSButton.h"

@implementation RSButton

+ (RSButton *)buttonWithFrame:(CGRect)frame ImageName:(NSString *)imagename Text:(NSString *)text TextColor:(UIColor *)tcolor
{
    RSButton *button = [RSButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:tcolor forState:UIControlStateNormal];
    
    return button;
}

+ (RSButton *)themeBorderButton:(CGRect)frame Text:(NSString *)text
{
    RSButton *button = [RSButton buttonWithFrame:frame ImageName:nil Text:text TextColor:RS_Theme_Color];
    button.layer.borderColor = RS_Theme_Color.CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 6;
    button.titleLabel.font = RS_SubButton_Font;
    
    return button;
}

+ (UIButton *)themeBackGroundButton:(CGRect)frame Text:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =frame;
    button.backgroundColor = RS_Theme_Color;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:RS_COLOR_C7 forState:UIControlStateNormal];
    button.layer.cornerRadius = 6;
    button.titleLabel.font = RS_FONT_F1;
    
    return button;
}

@end
