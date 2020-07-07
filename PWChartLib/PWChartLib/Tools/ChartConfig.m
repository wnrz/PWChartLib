//
//  ChartConfig.m
//  AFNetworking
//
//  Created by 王宁 on 2018/9/16.
//

#import "ChartConfig.h"

@implementation ChartConfig

+(ChartConfig *)shareConfig{
    //使用单一线程，解决网络同步请求的问题
    static ChartConfig* shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ChartConfig alloc] init];
        shareInstance.fontName = @"Helvetica Neue";
        shareInstance.fontSize = 10;
        shareInstance.chartLineWidth = 1;
    });
    return shareInstance;
}

+ (CALayer *)flashPointLayer:(UIColor *)color {
    CALayer * spreadLayer;
    spreadLayer = [CALayer layer];
    CGFloat diameter = 10; //扩散的大小
    spreadLayer.bounds = CGRectMake(0,0, diameter, diameter);
    spreadLayer.cornerRadius = diameter/2; //设置圆角变为圆形
    //    spreadLayer.position = personImageButton.center;
    spreadLayer.backgroundColor = color.CGColor;
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3;
    animationGroup.repeatCount = INFINITY;//重复无限次
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = defaultCurve;
    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.7;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 3;//动画持续时间
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 3;
    opacityAnimation.values = @[@0.4, @0.45,@0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.2,@1];//关键帧
    opacityAnimation.removedOnCompletion = NO;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];//添加到动画组
    [spreadLayer addAnimation:animationGroup forKey:@"pulse"];
    
    CALayer *_flashPointLayer = [[CALayer alloc] init];
    CGFloat width = 5;
    _flashPointLayer.bounds = CGRectMake(0, 0, width, width);
    _flashPointLayer.cornerRadius = width/2;
    _flashPointLayer.backgroundColor = color.CGColor;
    _flashPointLayer.position = CGPointMake(5, 5);
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = UIColor.clearColor.CGColor;
    layer.bounds = CGRectMake(0,0, diameter, diameter);
    [layer addSublayer:_flashPointLayer];
    [layer addSublayer:spreadLayer];
    
    return layer;
}
@end
