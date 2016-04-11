//
//  RSCartButtion.m
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSCartButtion.h"

@interface RSCartButtion()

@end

@implementation RSCartButtion
+(void)load {
    [super registerSubclass];
}

+(NSUInteger)indexOfPlusButtonInTabBar
{
    return 0;
}
+(CGFloat)multiplerInCenterY
{
    return 0.3;
}

+ (instancetype)plusButton
{
     
    RSCartButtion *button = [RSCartButtion buttonWithType:UIButtonTypeCustom];
    
    UIImage *buttonImage = [UIImage imageNamed:@"tab_cart"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    [button setTitle:@"购物车" forState:UIControlStateNormal];
    [button setTitleColor:RS_TabBar_Title_Color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
    [button addTarget:button action:@selector(clickCart:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 控件大小,间距大小
    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 0.7;
    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth ;
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdgeWidth;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeWidth * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdgeWidth  + verticalMargin * 2 + labelLineHeight * 0.5 + 10;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)clickCart:(RSCartButtion *)button
{
    //TODO 弹出View
}

@end
