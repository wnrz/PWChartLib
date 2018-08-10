//
//  LayerMaker.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "LayerMaker.h"

@implementation LayerMaker


+ (CAShapeLayer *)getLineLayer:(CGPoint)startPoint toPoint:(CGPoint)endPoint isDot:(BOOL)isDot{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:startPoint];
    [linePath addLineToPoint:endPoint];
    layer.path = linePath.CGPath;
    if (isDot) {
        layer.lineDashPattern = @[@5,@2];
    }
    return layer;
}

+ (CATextLayer *)getTextLayer:(NSString *)text point:(CGPoint)point font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor frame:(CGRect)frame{
    CATextLayer *layer = [CATextLayer layer];
    layer.foregroundColor = foregroundColor.CGColor;
    layer.string = text;
    layer.contentsScale = [UIScreen mainScreen].scale;
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layer.font = fontRef;
    layer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    layer.frame = frame;
    layer.alignmentMode = @"center";
    return layer;
}

+ (CAShapeLayer *)getLineChartLayer:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom arr:(NSArray *)arr start:(NSInteger)start startX:(NSInteger)startX{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    CGFloat width = showFrame.size.width - showFrame.origin.x - startX * 2;
    CGFloat height = showFrame.size.height - showFrame.origin.y;
    CGFloat mid = fabs(top - bottom);
    if (mid != 0) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat value = [obj doubleValue] - bottom;
            CGFloat x = startX +  width / (total + 1) * idx;
            CGFloat y = height * (1 - value / mid) + showFrame.origin.y;
            CGPoint point = CGPointMake(x, y);
            if (idx == start) {
                [linePath moveToPoint:point];
            }else if (idx > start){
                [linePath addLineToPoint:point];
            }
        }];
    }
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = linePath.CGPath;
    
    CAGradientLayer *gradientLayer = [self drawGredientLayer:linePath.CGPath];
    [layer addSublayer:gradientLayer];
    return layer;
}

+ (CAGradientLayer *)drawGredientLayer:(CGPathRef)path{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:250/255.0 green:170/255.0 blue:10/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.4].CGColor];
    
    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(1,0);
    
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = path;
    gradientLayer.mask = arc;
    return gradientLayer;
}
@end
