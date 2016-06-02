//
//  UITextField+RSAdd.m
//  RSUser
//
//  Created by 李江 on 16/6/2.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "UITextField+RSAdd.h"

@implementation UITextField (RSAdd)

-(instancetype)initWithFrame:(CGRect)frame Left:(UIView *)leftView Right:(UIView *)rightView placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.placeholder = placeholder;
        self.layer.borderColor = RS_Line_Color.CGColor;
        self.layer.borderWidth = 1;
        
        [self setLeftView:leftView RightView:rightView];
    }
    return self;
}

- (void)setLeftView:(UIView *)leftView RightView:(UIView*)rightView
{
    if (leftView) {
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = leftView;
    }
    if (rightView) {
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = rightView;
    }
}

- (void)renderFont:(UIFont *)font textColor:(UIColor *)textColor cornerRadius:(CGFloat) cornerRadius
{
    self.font = font;
    self.textColor = textColor;
    self.layer.cornerRadius = cornerRadius;
}
@end
