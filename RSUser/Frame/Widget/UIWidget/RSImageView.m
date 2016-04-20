//
//  RSImageView.m
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSImageView.h"

@implementation RSImageView
+ (RSImageView *)imageViewWithFrame:(CGRect)frame ImageName:(NSString *)imageName
{
    RSImageView *imageView = [[RSImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}
@end
