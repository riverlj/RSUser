//
//  RSTextFiled.m
//  RSUser
//
//  Created by 李江 on 16/4/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTextFiled.h"

@implementation RSTextFiled

+ (RSTextFiled *)textFiledWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius LeftImageName:(NSString *)imageName
{
    RSTextFiled *textFild = [[RSTextFiled alloc]initWithFrame:frame];
    textFild.borderStyle = UITextBorderStyleRoundedRect;
    textFild.layer.borderColor = RS_Line_Color.CGColor;
    textFild.layer.borderWidth = 1;
    textFild.layer.cornerRadius = cornerRadius;
    RSImageView *userNameImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, 39, 45) ImageName:imageName];
    textFild.leftView = userNameImageView;
    textFild.leftViewMode = UITextFieldViewModeAlways;
    
    return textFild;
}


+ (RSTextFiled *)textFiledWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius RightImageName:(NSString *)imageName
{
    RSTextFiled *textFild = [[RSTextFiled alloc]initWithFrame:frame];
    textFild.borderStyle = UITextBorderStyleRoundedRect;
    textFild.layer.borderColor = RS_Line_Color.CGColor;
    textFild.layer.borderWidth = 1;
    textFild.layer.cornerRadius = cornerRadius;
    RSImageView *userNameImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, 39, 45) ImageName:imageName];
    textFild.rightView = userNameImageView;
    textFild.rightViewMode = UITextFieldViewModeAlways;
    
    return textFild;
}

+ (RSTextFiled *)textFiledWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius Placeholder:(NSString *)placeholder
{
    RSTextFiled *textFild = [[RSTextFiled alloc]initWithFrame:frame];
    textFild.borderStyle = UITextBorderStyleRoundedRect;
    textFild.layer.borderColor = RS_Line_Color.CGColor;
    textFild.layer.borderWidth = 1;
    textFild.layer.cornerRadius = cornerRadius;
    textFild.placeholder = placeholder;
    
    return textFild;
}
@end
