//
//  LayerMaker.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "LayerMaker.h"
#import "ChartTools.h"

@implementation LayerMakerLineModel

@end

@implementation LayerMakerDataModel

@end

@implementation LayerMakerLineChartDataModel

@end

@implementation LayerMakerCandlestickDataModel

@end

@implementation LayerMakerStickDataModel

@end

@implementation LayerMakerTextModel

@end

@implementation CandlestickModel

@end

@implementation StickModel

@end

@implementation LayerMaker


+ (CAShapeLayer *)getMultiplePointLineLayer:(LayerMakerLineModel *)lineModel{
    CAShapeLayer *layer = [CAShapeLayer layer];
    if (lineModel.points.count == 0) {
        return layer;
    }
    __block BOOL currentPoint = NO;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [lineModel.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [lineModel.points[idx] CGPointValue];
        if (!currentPoint) {
            currentPoint = YES;
            [linePath moveToPoint:point];
        }else{
            [linePath addLineToPoint:point];
        }
    }];
    layer.path = linePath.CGPath;
    if (lineModel.isDot) {
        layer.lineDashPattern = @[@5,@2];
    }
    return layer;
}

+ (CAShapeLayer *)getTwoPointLineLayer:(LayerMakerLineModel *)lineModel{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:lineModel.startPoint];
    [linePath addLineToPoint:lineModel.endPoint];
    layer.path = linePath.CGPath;
    if (lineModel.isDot) {
        layer.lineDashPattern = @[@5,@2];
    }
    return layer;
}

+ (CATextLayer *)getTextLayer:(LayerMakerTextModel *)textModel{
    NSString *text = textModel.text;
    UIFont *font = textModel.font;
    UIColor *foregroundColor = textModel.foregroundColor;
    CGRect frame = textModel.frame;
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

+ (CAShapeLayer *)getLineChartLayer:(LayerMakerLineChartDataModel *)lineChartDataModel{
    CGRect showFrame = lineChartDataModel.showFrame;
    float total = lineChartDataModel.total;
    float top = lineChartDataModel.top;
    float bottom = lineChartDataModel.bottom;
    NSArray *arr = lineChartDataModel.lineChartDatas;
    NSInteger start = lineChartDataModel.start;
    NSInteger startX = lineChartDataModel.startX;
    
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

+ (CALayer *)getCandlestickLine:(LayerMakerCandlestickDataModel *)candlestickDataModel{
    CGRect showFrame = candlestickDataModel.showFrame;
    float total = candlestickDataModel.total;
    float top = candlestickDataModel.top;
    float bottom = candlestickDataModel.bottom;
    NSArray<CandlestickModel *> *models = candlestickDataModel.candlestickDatas;
    UIColor *clrUp = candlestickDataModel.clrUp;
    UIColor *clrDown = candlestickDataModel.clrDown;
    UIColor *clrBal = candlestickDataModel.clrBal;
    NSInteger lintType = candlestickDataModel.lineType;
    
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
        LayerMakerLineModel *lineModel = [[LayerMakerLineModel alloc] init];
        lineModel.startPoint = pointTop;
        lineModel.endPoint = pointBottom;
        lineModel.isDot = NO;
        CAShapeLayer *topToBottomLayar = [self getTwoPointLineLayer:lineModel];
        topToBottomLayar.lineWidth = 1;
        
        topToBottomLayar.strokeColor = color;
        
        [layer addSublayer:topToBottomLayar];
        
        if (lintType == 0 || (lintType == 1 && model.open > model.close)) {
            LayerMakerLineModel *lineModel = [[LayerMakerLineModel alloc] init];
            lineModel.startPoint = pointOpen;
            lineModel.endPoint = pointClose;
            lineModel.isDot = NO;
            CAShapeLayer *openToCloseLayer = [self getTwoPointLineLayer:lineModel];
            openToCloseLayer.lineWidth = width * .7;
            openToCloseLayer.strokeColor = color;
            [layer addSublayer:openToCloseLayer];
        }else if (lintType == 0 || lintType == 1) {
            CGPoint point1 = CGPointMake(pointOpen.x - width *.7 / 2, pointOpen.y);
            CGPoint point2 = CGPointMake(pointOpen.x + width *.7 / 2, pointOpen.y);
            CGPoint point3 = CGPointMake(pointOpen.x + width *.7 / 2, pointClose.y);
            CGPoint point4 = CGPointMake(pointOpen.x - width *.7 / 2, pointClose.y);
            LayerMakerLineModel *lineModel = [[LayerMakerLineModel alloc] init];
            lineModel.points = @[@(point1) , @(point2) , @(point3) , @(point4) , @(point1)];
            lineModel.isDot = NO;
            CAShapeLayer *openToCloseLayer = [self getMultiplePointLineLayer:lineModel];
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
            LayerMakerLineModel *lineModel = [[LayerMakerLineModel alloc] init];
            lineModel.points = @[@(point1) , @(point2)];
            lineModel.isDot = NO;
            CAShapeLayer *openLayer = [self getMultiplePointLineLayer:lineModel];
            openLayer.lineWidth = 1;
            openLayer.strokeColor = color;
            [layer addSublayer:openLayer];
            
            lineModel = [[LayerMakerLineModel alloc] init];
            lineModel.points = @[@(point3) , @(point4)];
            lineModel.isDot = NO;
            CAShapeLayer *closeLayer = [self getMultiplePointLineLayer:lineModel];
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

+ (CALayer *)getCandlestickLineTopAndBottomValue:(LayerMakerCandlestickDataModel *)candlestickDataModel textLayer:(LayerMakerTextModel *)textModel{
    CGRect showFrame = candlestickDataModel.showFrame;
    float total = candlestickDataModel.total;
    float top = candlestickDataModel.top;
    float bottom = candlestickDataModel.bottom;
    NSArray<CandlestickModel *> *models = candlestickDataModel.candlestickDatas;
    UIColor *topColor = candlestickDataModel.clrUp;
    UIColor *bottomColor = candlestickDataModel.clrDown;
    NSInteger digit = textModel ? textModel.digit : 0;
    UIFont *font = textModel ? textModel.font : nil;
    
    CALayer *layer = [[CALayer alloc] init];
    CGFloat startX = [ChartTools getStartX:showFrame total:total];
    CGFloat width = (showFrame.size.width - 2 * startX) / total;
    CGFloat height = showFrame.size.height;
    CGFloat mid = fabs(top - bottom);
    if (mid == 0) {
        mid = 1;
    }
    __block CGFloat x = startX + width / 2;
    __block CGPoint topPoint = CGPointMake(-MAXFLOAT, -MAXFLOAT);
    __block CGPoint bottomPoint = CGPointMake(-MAXFLOAT, -MAXFLOAT);
    __block CGFloat topValue = -MAXFLOAT;
    __block CGFloat bottomValue = MAXFLOAT;
    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        x = showFrame.origin.x + startX + width / 2 + idx * width;
        CandlestickModel *model = obj;
        
        CGFloat value = model.top - bottom;
        CGFloat y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointTop = CGPointMake(x, y);
        
        value = model.bottom - bottom;
        y = height * (1 - value / mid) + showFrame.origin.y;
        CGPoint pointBottom = CGPointMake(x, y);
        
        if (topValue < model.top) {
            topValue = model.top;
            topPoint = pointTop;
        }
        
        if (bottomValue > model.bottom) {
            bottomValue = model.bottom;
            bottomPoint = pointBottom;
        }
    }];
    if (textModel != nil) {
        for (int i = 0 ; i < 2; i++) {
            CGPoint curPoint = i == 0 ? topPoint : bottomPoint;
            CGPoint oldPoint = i == 0 ? topPoint : bottomPoint;
            UIColor *color = i == 0 ? topColor : bottomColor;
            BOOL isLeft = oldPoint.x < showFrame.size.width / 2 + showFrame.origin.x;
            NSString *format = [NSString stringWithFormat:@"%%.%ldf" , (long)digit];
            NSString *string = [NSString stringWithFormat:format , i == 0 ? topValue : bottomValue];
            CGSize size = [ChartTools sizeWithText:string maxSize:CGSizeMake(1000, 1000) fontSize:font.pointSize];
            if (i == 0){
                curPoint.y = (curPoint.y - 5 - size.height / 2) < showFrame.origin.y ? showFrame.origin.y : (curPoint.y - 5 - size.height / 2);
            }else{
                curPoint.y = (curPoint.y + 5 + size.height / 2) > (showFrame.origin.y + showFrame.size.height) ? (showFrame.origin.y + showFrame.size.height - size.height / 2) : (curPoint.y + 5 - size.height / 2);
            }
            curPoint.x = isLeft ? (curPoint.x + 9) : (curPoint.x - size.width - 9);
            CGRect frame = CGRectMake(curPoint.x , curPoint.y , size.width , size.height);
            LayerMakerTextModel *textModel = [[LayerMakerTextModel alloc] init];
            textModel.text = string;
            textModel.font = font;
            textModel.foregroundColor = color;
            textModel.frame = frame;
            CATextLayer *textLayer = [LayerMaker getTextLayer:textModel];
            [layer addSublayer:textLayer];
            
            curPoint.y = curPoint.y + size.height / 2;
            curPoint.x = isLeft ? curPoint.x : (curPoint.x + size.width);
            LayerMakerLineModel *lineModel = [[LayerMakerLineModel alloc] init];
            lineModel.startPoint = oldPoint;
            lineModel.endPoint = curPoint;
            lineModel.isDot = NO;
            CAShapeLayer *lineLayer = [LayerMaker getTwoPointLineLayer:lineModel];
            lineLayer.strokeColor = color.CGColor;
            [layer addSublayer:lineLayer];
        }
    }
    
    CAShapeLayer *maksLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:showFrame];
    maksLayer.path = path.CGPath;
    layer.mask = maksLayer;
    return layer;
}

+ (CALayer *)getStickLine:(LayerMakerStickDataModel *)stickDataModel{
    CGRect showFrame = stickDataModel.showFrame;
    float total = stickDataModel.total;
    float top = stickDataModel.top;
    float bottom = stickDataModel.bottom;
    NSArray<StickModel *> *models = stickDataModel.stickDatas;
    CGFloat lineWidth = stickDataModel.lineWidth;
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
        
        LayerMakerLineModel *lineModel = [[LayerMakerLineModel alloc] init];
        lineModel.startPoint = pointOpen;
        lineModel.endPoint = pointClose;
        lineModel.isDot = NO;
        CAShapeLayer *volLayer = [self getTwoPointLineLayer:lineModel];
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
