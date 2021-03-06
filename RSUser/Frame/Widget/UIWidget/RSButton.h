//
//  RSButton.h
//  RSUser
//
//  Created by 李江 on 16/4/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSButton : UIButton
+ (RSButton *)buttonWithFrame:(CGRect)frame ImageName:(NSString *)imagename Text:(NSString *)text TextColor:(UIColor *)tcolor;
+ (RSButton *)themeBorderButton:(CGRect)frame Text:(NSString *)text;
+ (UIButton *)themeBackGroundButton:(CGRect)frame Text:(NSString *)text;

+ (void)countDown:(UIButton *)button;
@end
