//
//  RSTextFiled.h
//  RSUser
//
//  Created by 李江 on 16/4/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSTextFiled : UITextField
+ (RSTextFiled *)textFiledWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius LeftImageName:(NSString *)imageName;
+ (RSTextFiled *)textFiledWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius RightImageName:(NSString *)imageName;
+ (RSTextFiled *)textFiledWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius Placeholder:(NSString *)placeholder;
@end
