//
//  ChartCrossLineLayer.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/8.
//

#import "ChartCrossLineLayer.h"

@implementation ChartCrossLineLayer

- (void)startDraw{
    [super startDraw];
}

- (void)drawCrossLine{
    if (self.baseConfig) {
        if (self.baseConfig.showCrossLine) {
            [self drawLine:self.baseConfig.showCrossLinePoint isVer:YES];
            [self drawLine:self.baseConfig.showCrossLinePoint isVer:NO];
        }else{
            
        }
    }
}

- (void)drawLine:(CGPoint)point isVer:(BOOL)isVer{
    CGPoint startPoint;
    CGPoint endPoint;
    if (isVer) {
        startPoint = CGPointMake(self.showFrame.origin.x , self.showFrame.origin.y + point.y);
        endPoint = CGPointMake(self.showFrame.origin.x + self.showFrame.size.width, self.showFrame.origin.y + point.y);
    }else{
        startPoint = CGPointMake(self.showFrame.origin.x + point.x, self.showFrame.origin.y);
        endPoint = CGPointMake(self.showFrame.origin.x + point.x, self.showFrame.origin.y + self.showFrame.size.height);
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:startPoint];
    [linePath addLineToPoint:endPoint];
    layer.path = linePath.CGPath;
    layer.strokeColor = self.lineColor.CGColor;
    layer.lineWidth = self.lineWidth;
    [self addSublayer:layer];
}
@end
