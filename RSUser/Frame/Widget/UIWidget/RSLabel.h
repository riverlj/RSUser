//
//  RSLabel.h
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSLabel : UILabel

+ (RSLabel *)lableViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor;

+ (RSLabel *)lableViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor FontSize:(CGFloat)fontsize;

+ (UILabel *) labelOneLevelWithFrame:(CGRect)frame Text:(NSString *)text;
+ (UILabel *) labelTwoLevelWithFrame:(CGRect)frame Text:(NSString *)text;
@end
