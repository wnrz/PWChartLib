//
//  ChartCrossLineLayer.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/8.
//

#import "ChartCrossLineLayer.h"

@implementation ChartCrossLineLayer

- (void)install{
    [super install];
}

- (void)startDraw{
    [super startDraw];
}

- (void)drawCrossLine{
    [self clearLayers];
    if (self.baseConfig) {
        if (self.baseConfig.showCrossLine) {
            [self drawLine:self.baseConfig.showCrossLinePoint isVer:YES];
            [self drawLine:self.baseConfig.showCrossLinePoint isVer:NO];
        }else{
            
        }
    }
}

- (void)setBaseConfig:(ChartBaseViewModel *)baseConfig{
    super.baseConfig ? [super.baseConfig removeAllBridge] : 0;
    super.baseConfig = baseConfig;
    [baseConfig addBridgeObserver:self forKeyPath:@"showCrossLine" action:@selector(drawCrossLine)];
    [baseConfig addBridgeObserver:self forKeyPath:@"showCrossLinePoint" action:@selector(drawCrossLine)];
}

- (void)drawLine:(CGPoint)point isVer:(BOOL)isVer{
    CGPoint startPoint;
    CGPoint endPoint;
    if (isVer) {
        if (point.y < self.baseConfig.showFrame.origin.y || point.y > self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height) {
            return;
        }
        startPoint = CGPointMake(self.baseConfig.showFrame.origin.x , self.baseConfig.showFrame.origin.y + point.y);
        endPoint = CGPointMake(self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width, self.baseConfig.showFrame.origin.y + point.y);
    }else{
        if (point.x < self.baseConfig.showFrame.origin.x || point.x > self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width) {
            return;
        }
        startPoint = CGPointMake(self.baseConfig.showFrame.origin.x + point.x, self.baseConfig.showFrame.origin.y);
        endPoint = CGPointMake(self.baseConfig.showFrame.origin.x + point.x, self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height);
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
