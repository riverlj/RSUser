//
//  XHStarRateView.m
//  XHStarRateView
//
//  Created by 江欣华 on 16/4/1.
//  Copyright © 2016年 jxh. All rights reserved.
//

#import "XHStarRateView.h"

typedef void(^completeBlock)(CGFloat currentScore);

@interface XHStarRateView()
{
    NSString *_foregroundStarImage;
    NSString *_backgroundStarImage;
    NSString *_foregroundStarDarkImage;
    NSString *_foregroundStarRedImage;
}
@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *foregroundStarDarkView;
@property (nonatomic, strong) UIView *foregroundStarRedView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, strong) UIView *ponitStartView;

@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic,assign)CGFloat currentScore;   // 当前评分：0-5  默认0

@property (nonatomic,strong)completeBlock complete;

@end

@implementation XHStarRateView

#pragma mark - 代理方式
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame rateType:(RateType)rateType{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        self.rateType = rateType;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _delegate = delegate;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame rateType:(RateType)rateType currentScore:(CGFloat)currentScore {
    if (self = [self initWithFrame:frame rateType:rateType]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        self.rateType = rateType;
        self.currentScore = currentScore;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame foregroundStarImage:(NSString *)fimagename backgroundStarImage:(NSString *)bimagename currentScore:(CGFloat)currentScore {
    if (self = [self initWithFrame:frame]) {
        _foregroundStarImage = fimagename;
        _backgroundStarImage = bimagename;
        self.rateType = IncompleteStar;
        self.currentScore = currentScore;
        [self rs_createStarView];
    }
    return self;
}
#pragma mark - block方式
-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}

#pragma mark - private Method

- (void)rs_createStarView
{
    self.foregroundStarView = [self createStarViewWithImage:_foregroundStarImage];
    
    self.backgroundStarView = [self createStarViewWithImage:_backgroundStarImage];
    
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);
    self.ponitStartView = self.foregroundStarView;

    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];

}

-(void)createStarView{
    
    self.foregroundStarView = [self createStarViewWithImage:_foregroundStarImage];
    self.foregroundStarView.tag = 1;
    self.foregroundStarRedView = [self createStarViewWithImage:_foregroundStarRedImage];
    self.foregroundStarRedView.tag = 2;
    self.foregroundStarDarkView = [self createStarViewWithImage:_foregroundStarDarkImage];
    self.foregroundStarDarkView.tag = 3;
    self.backgroundStarView = [self createStarViewWithImage:_backgroundStarImage];
    self.backgroundStarView.tag = 4;
    
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);
    self.foregroundStarDarkView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);
    self.foregroundStarRedView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);

    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    [self addSubview:self.foregroundStarDarkView];
    [self addSubview:self.foregroundStarRedView];
    
    [self changePointView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];

}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(starRateView:beforeScore:)]) {
        [self.delegate starRateView:self beforeScore:_currentScore];
    }
    
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    switch (_rateStyle) {
        case WholeStar:
        {
            _currentScore = ceilf(realStarScore);
            break;
        }
        case HalfStar:
            _currentScore = roundf(realStarScore)>realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
            break;
        case IncompleteStar:
            _currentScore = realStarScore;
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak XHStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.ponitStartView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.currentScore/self.numberOfStars, weakSelf.bounds.size.height);
    }];
}


-(void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    if (self.complete) {
        _complete(_currentScore);
    }
    
    for (int i=0; i<self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if (view != self.backgroundStarView) {
            view.width = 0;
        }
    }
    [self setNeedsLayout];
}

-(void)setRateType:(RateType)rateType {
    _rateType = rateType;
    if (rateType == RateTypeDelivery) {
        _foregroundStarImage = @"icon_delivery_yellow";
        _backgroundStarImage = @"icon_delivery_gray";
        _foregroundStarDarkImage = @"icon_delivery_dark";
        _foregroundStarRedImage = @"icon_delivery_red";
    }
    
    if (rateType == RateTypeGood) {
        _foregroundStarImage = @"icon_start_yellow";
        _backgroundStarImage = @"icon_start_gray";
        _foregroundStarDarkImage = @"icon_start_dark";
        _foregroundStarRedImage = @"icon_start_red";
    }
}

- (void)changePointView {
    if (self.currentScore == 1) {
        [self bringSubviewToFront:self.foregroundStarDarkView];
        self.ponitStartView = self.foregroundStarDarkView;
    }
    if (self.currentScore == 2 || self.currentScore == 3) {
        [self bringSubviewToFront:self.foregroundStarView];
        self.ponitStartView = self.foregroundStarView;
        
    }
    if (self.currentScore==4 || self.currentScore==5) {
        [self bringSubviewToFront:self.foregroundStarRedView];
        self.ponitStartView = self.foregroundStarRedView;
    }

}
@end
