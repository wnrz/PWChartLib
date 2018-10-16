//
//  LayerMaker.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "LayerMaker.h"
#import "ChartTools.h"

@implementation CandlestickModel

@end

@implementation StickModel

@end

@implementation LayerMaker


+ (CAShapeLayer *)getLineLayer:(NSArray *)points isDot:(BOOL)isDot{
    CAShapeLayer *layer = [CAShapeLayer layer];
    if (points.count == 0) {
        return layer;
    }
    __block BOOL currentPoint = NO;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [points[idx] CGPointValue];
        if (!currentPoint) {
            currentPoint = YES;
            [linePath moveToPoint:point];
        }else{
            [linePath addLineToPoint:point];
        }
    }];
    layer.path = linePath.CGPath;
    if (isDot) {
        layer.lineDashPattern = @[@5,@2];
    }
    return layer;
}

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
    
    CGFloat width = showFrame.size.width - startX * 2;
    CGFloat height = showFrame.size.height;
    CGFloat mid = fabs(top - bottom);
    if (mid != 0) {
        __block BOOL currentPoint = NO;
        __block CGFloat perValue = NAN;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat value = 0.0;// = (isnan([obj doubleValue]) || isinf([obj doubleValue]) ? 0 : [obj doubleValue]) - bottom;
            if (isnan([obj doubleValue]) || isinf([obj doubleValue])) {
                if (!isnan(perValue) && !isinf(perValue)) {
                    value = perValue;
                }
            }else{
                value = [obj doubleValue] - bottom;
            }
            if (!isnan(value) && !isinf(value)) {
                perValue = value;
                
                CGFloat x = showFrame.origin.x + startX +  width / (total - 1) * idx;
                CGFloat y = height * (1 - value / mid) + showFrame.origin.y;
                CGPoint point = CGPointMake(x, y);
                if (idx >= start) {
                    if (isnan(point.x) || isinf(point.x) || isnan(point.y) || isinf(point.y)) {
                        NSLog(@"");
                    }
                    if (!currentPoint) {
                        currentPoint = YES;
                        [linePath moveToPoint:point];
                    }else{
                        [linePath addLineToPoint:point];
                    }
                }
                
            }
        }];
    }
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = linePath.CGPath;
    
//    [layer addSublayer:gradientLayer];
    CAShapeLayer *maksLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:showFrame];
    maksLayer.path = path.CGPath;
    layer.mask = maksLayer;
    return layer;
}

+ (CAGradientLayer *)drawGredientLayer:(CGRect)showFrame path:(CGPathRef)path fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    NSMutableArray *bezierPoints = [NSMutableArray array];
    CGPathApply(path, (__bridge void *)(bezierPoints), processPathElement);

    UIBezierPath *linePath = [UIBezierPath bezierPath];
    if (bezierPoints && bezierPoints.count > 0) {
        CGPoint p = [bezierPoints[0] CGPointValue];
        [linePath moveToPoint:CGPointMake(p.x, showFrame.origin.y + showFrame.size.height)];
        [bezierPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint p2 = [obj CGPointValue];
            [linePath addLineToPoint:p2];
        }];
        p = [[bezierPoints lastObject] CGPointValue];
        [linePath addLineToPoint:CGPointMake(p.x, showFrame.origin.y + showFrame.size.height)];
        [linePath closePath];
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = linePath.CGPath;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    UIColor *color2 = [ChartTools getNewColorWith:color alpha:.2];
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    
    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(0,1);
    gradientLayer.mask = layer;
    return gradientLayer;
}

void processPathElement(void* info, const CGPathElement* element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    CGPoint point = points[0];
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:point]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:point]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}

+ (CALayer *)getCandlestickLine:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom models:(NSArray *)models clrUp:(UIColor *)clrUp clrDown:(UIColor *)clrDown clrBal:(UIColor *)clrBal start:(NSInteger)start lineType:(NSInteger)lintType{
    CALayer *layer = [[CALayer alloc] init];
    CGFloat startX = [ChartTools getStartX:showFrame total:total];
    CGFloat width = (showFrame.size.width - 2 * startX) / total;
    CGFloat height = showFrame.size.height;
    CGFloat mid = fabs(top - bottom);
    if (mid == 0) {
        mid = 1;
    }
    __block CGFloat x = startX + width / 2;
    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        x = showFrame.origin.x + startX + width / 2 + idx * width;
        CandlestickModel *model = obj;
        
        CGFloat value = model.open - bottom;
        CGFloat y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointOpen = CGPointMake(x, y);
        
        value = model.close - bottom;
        y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointClose = CGPointMake(x, y);
        
        value = model.top - bottom;
        y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointTop = CGPointMake(x, y);
        
        value = model.bottom - bottom;
        y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointBottom = CGPointMake(x, y);
        
        CGColorRef color = model.open < model.close ? clrUp.CGColor : model.open > model.close ? clrDown.CGColor : clrBal.CGColor;
        
        CAShapeLayer *topToBottomLayar = [self getLineLayer:pointTop toPoint:pointBottom isDot:NO];
        topToBottomLayar.lineWidth = 1;
        
        topToBottomLayar.strokeColor = color;
        
        [layer addSublayer:topToBottomLayar];
        
        if (lintType == 0 || (lintType == 1 && model.open > model.close)) {
            CAShapeLayer *openToCloseLayer = [self getLineLayer:pointOpen toPoint:pointClose isDot:NO];
            openToCloseLayer.lineWidth = width * .7;
            openToCloseLayer.strokeColor = color;
            [layer addSublayer:openToCloseLayer];
        }else if (lintType == 0 || lintType == 1) {
            CGPoint point1 = CGPointMake(pointOpen.x - width *.7 / 2, pointOpen.y);
            CGPoint point2 = CGPointMake(pointOpen.x + width *.7 / 2, pointOpen.y);
            CGPoint point3 = CGPointMake(pointOpen.x + width *.7 / 2, pointClose.y);
            CGPoint point4 = CGPointMake(pointOpen.x - width *.7 / 2, pointClose.y);
            CAShapeLayer *openToCloseLayer = [self getLineLayer:@[@(point1) , @(point2) , @(point3) , @(point4) , @(point1)] isDot:NO];
            openToCloseLayer.lineWidth = .5;
            openToCloseLayer.strokeColor = color;
            if ((lintType == 1 && model.open < model.close)) {
                openToCloseLayer.fillColor = [UIColor whiteColor].CGColor;
            }else{
                openToCloseLayer.fillColor = color;
            }
            [layer addSublayer:openToCloseLayer];
        }else if (lintType == 2) {
            CGPoint point1 = CGPointMake(pointOpen.x - width / 2, pointOpen.y);
            CGPoint point2 = CGPointMake(pointOpen.x, pointOpen.y);
            CGPoint point3 = CGPointMake(pointOpen.x + width / 2, pointClose.y);
            CGPoint point4 = CGPointMake(pointOpen.x, pointClose.y);
            CAShapeLayer *openLayer = [self getLineLayer:@[@(point1) , @(point2)] isDot:NO];
            openLayer.lineWidth = 1;
            openLayer.strokeColor = color;
            [layer addSublayer:openLayer];
            
            CAShapeLayer *closeLayer = [self getLineLayer:@[@(point3) , @(point4)] isDot:NO];
            closeLayer.lineWidth = 1;
            closeLayer.strokeColor = color;
            [layer addSublayer:closeLayer];
        }
    }];
    
    CAShapeLayer *maksLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:showFrame];
    maksLayer.path = path.CGPath;
    layer.mask = maksLayer;
    return layer;
}

+ (CALayer *)getStickLine:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom models:(NSArray *)models start:(NSInteger)start lineWidth:(CGFloat)lineWidth{
    CALayer *layer = [[CALayer alloc] init];
    CGFloat startX = [ChartTools getStartX:showFrame total:total];
    CGFloat width = (showFrame.size.width - 2 * startX) / total;
    CGFloat height = showFrame.size.height;
    CGFloat mid = fabs(top - bottom);
    if (mid == 0) {
        mid = 1;
    }
    __block CGFloat x = startX + width / 2;
    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        x = showFrame.origin.x + startX + width / 2 + idx * width;
        StickModel *model = obj;
        
        CGFloat value = model.value - bottom;
        CGFloat y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointOpen = CGPointMake(x, y);
        
        value = 0 - bottom;
        y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointClose = CGPointMake(x, y);
        
        CGColorRef color = model.color.CGColor;
        
        CAShapeLayer *volLayer = [self getLineLayer:pointOpen toPoint:pointClose isDot:NO];
        volLayer.lineWidth = lineWidth > 0 ? lineWidth : width *.7;
        volLayer.strokeColor = color;
        [layer addSublayer:volLayer];
    }];
    CAShapeLayer *maksLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:showFrame];
    maksLayer.path = path.CGPath;
    layer.mask = maksLayer;
    return layer;
}

+ (CALayer *)drawImages:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom image:(UIImage *)image array:(NSArray *)array isBuy:(BOOL)isBuy{
    CALayer *layer = [[CALayer alloc] init];
    if (!image) {
        return layer;
    }
    CGFloat startX = [ChartTools getStartX:showFrame total:total];
    CGFloat width = (showFrame.size.width - 2 * startX) / total;
    CGFloat height = showFrame.size.height;
    CGFloat mid = fabs(top - bottom);
    if (mid == 0) {
        mid = 1;
    }
    __block CGFloat x = startX + width / 2;
    CGImageRef imageRef = image.CGImage;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = [obj doubleValue];
        if (isnan(value) || isinf(value)) {
            return;
        }
        x = showFrame.origin.x + startX + width / 2 + idx * width;
        x = x - image.size.width / 2;
        value = value - bottom;
        CGFloat y = height * (1 - value / mid) + showFrame.origin.y;
        y = isBuy ? (y) : (y - image.size.height);
        
        CALayer *imageLayer = [[CALayer alloc] init];
        imageLayer.frame = CGRectMake(x, y, image.size.width, image.size.height);
        imageLayer.contents = (__bridge id _Nullable)(imageRef);
        [layer addSublayer:imageLayer];
    }];
//    CGImageRelease(imageRef);
    CAShapeLayer *maksLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:showFrame];
    maksLayer.path = path.CGPath;
    layer.mask = maksLayer;
    return layer;
}
@end
