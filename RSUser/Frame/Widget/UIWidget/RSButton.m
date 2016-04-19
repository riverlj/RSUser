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

@end
