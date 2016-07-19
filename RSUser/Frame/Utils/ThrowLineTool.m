//
//  ThrowLineTool.m
//  抛物线
//
//  Created by 李江 on 16/4/6.
//  Copyright © 2016年 李江. All rights reserved.
//

#import "ThrowLineTool.h"

static ThrowLineTool *s_sharedInstance = nil;
@implementation ThrowLineTool

+ (ThrowLineTool *)sharedTool
{
    if (!s_sharedInstance) {
        s_sharedInstance = [[[self class] alloc] init];
    }
    return s_sharedInstance;
}

/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param start  起点坐标
 *  @param end    终点坐标
 *  @param height 高度，抛物线最高点比起点/终点y坐标最低(即高度最高)所超出的高度
 */
- (void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end
             height:(CGFloat)height duration:(CGFloat)duration
{
    self.showingView = obj;

    //初始化抛物线path
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cpx = end.x+200;
    CGFloat cpy = start.y-100;
    
    
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    //添加二次被塞尔曲线
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, end.x, end.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CFRelease(path);
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = self;
    groupAnimation.repeatCount = 1;
    groupAnimation.duration = duration;
    groupAnimation.removedOnCompletion = YES;
    groupAnimation.animations = @[animation];
    [self.showingView.layer addAnimation:groupAnimation forKey:@"position scale"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[[AppConfig getAPPDelegate].window viewWithTag:10] removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidFinish)]) {
        [self.delegate performSelector:@selector(animationDidFinish) withObject:nil];
    }
    [self.showingView removeFromSuperview];
    self.showingView = nil;
}

@end