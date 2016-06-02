//
//  UITextField+RSAdd.h
//  RSUser
//
//  Created by 李江 on 16/6/2.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (RSAdd)
/**
 *  初始化textFiled， 默认类型是UITextBorderStyleRoundedRect，边框是1，边框颜色是RS_Line_Color
 *
 *  @param frame       frame
 *  @param leftView    左边视图
 *  @param rightView   右边视图
 *  @param placeholder 提示语
 *
 *  @return UITextField
 */
-(instancetype)initWithFrame:(CGRect)frame Left:(UIView *)leftView Right:(UIView *)rightView placeholder:(NSString *)placeholder;

/**
 *  渲染视图
 *
 *  @param font         字体
 *  @param textColor    文本颜色
 *  @param cornerRadius 圆角
 */
- (void)renderFont:(UIFont *)font textColor:(UIColor *)textColor cornerRadius:(CGFloat) cornerRadius;

- (void)setLeftView:(UIView *)leftView RightView:(UIView*)rightView;
@end
