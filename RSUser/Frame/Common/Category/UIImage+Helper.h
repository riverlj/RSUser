//
//  UIImage+Helper.h
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
/**
 *  颜色转换为image
 *
 *  @param color  要转换的颜色
 *  @param size   输出image的大小
 *  @param radius 输出image的边角弧度
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius ;
@end
