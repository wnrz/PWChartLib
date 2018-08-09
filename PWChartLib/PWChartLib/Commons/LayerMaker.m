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
@end
