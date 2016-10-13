//
//  XHStarRateView.h
//  XHStarRateView
//
//  Created by 江欣华 on 16/4/1.
//  Copyright © 2016年 jxh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHStarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};
typedef NS_ENUM(NSInteger, RateType)
{
    RateTypeDelivery = 0,
    RateTypeGood = 1
};

@protocol XHStarRateViewDelegate <NSObject>

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore;
-(void)starRateView:(XHStarRateView *)starRateView beforeScore:(CGFloat)currentScore;
@end

@interface XHStarRateView : UIView

@property (nonatomic,assign)BOOL isAnimation;       //是否动画显示，默认NO
@property (nonatomic,assign)RateStyle rateStyle;    //评分样式    默认是WholeStar
@property (nonatomic,assign)RateType rateType;    //评分样式    默认是WholeStar
@property (nonatomic, weak) id<XHStarRateViewDelegate>delegate;



-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;

-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame rateType:(RateType)rateType;

-(instancetype)initWithFrame:(CGRect)frame rateType:(RateType)rateType currentScore:(CGFloat)currentScore;

-(instancetype)initWithFrame:(CGRect)frame foregroundStarImage:(NSString *)imagename backgroundStarImage:(NSString *)imagename currentScore:(CGFloat)currentScore;

@end
