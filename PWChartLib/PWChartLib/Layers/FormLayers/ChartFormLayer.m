//
//  ChartFormLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFormLayer.h"

@implementation ChartFormLayer

- (void)install{
    [super install];
    _verticalSeparateArr = @[@(0),@(1)];
    _horizontalSeparateArr = @[@(0),@(1)];
    _verticalSeparateDottedArr = @[@.25,@.5,@.75];
}


- (void)startDraw{
    [super startDraw];
    self.lineWidth = .1;
    [self drawForm];
}

- (void)drawForm{
    [self drawLineWithArr:_verticalSeparateArr isVer:YES isDot:NO];
    [self drawLineWithArr:_horizontalSeparateArr isVer:NO isDot:NO];
    [self drawLineWithArr:_verticalSeparateDottedArr isVer:YES isDot:YES];
    [self drawLineWithArr:_horizontalSeparateDottedArr isVer:NO isDot:YES];
}

- (void)drawLineWithArr:(NSArray *)arr isVer:(BOOL)isVer isDot:(BOOL)isDot{
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat num = [obj floatValue];
        CGPoint startPoint;
        CGPoint endPoint;
        if (isVer) {
            startPoint = CGPointMake(self.showFrame.origin.x , self.showFrame.origin.y + self.showFrame.size.height * num);
            endPoint = CGPointMake(self.showFrame.origin.x + self.showFrame.size.width, self.showFrame.origin.y + self.showFrame.size.height * num);
        }else{
            startPoint = CGPointMake(self.showFrame.origin.x + self.showFrame.size.width * num, self.showFrame.origin.y);
            endPoint = CGPointMake(self.showFrame.origin.x + self.showFrame.size.width * num, self.showFrame.origin.y + self.showFrame.size.height);
        }
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:startPoint];
        [linePath addLineToPoint:endPoint];
        layer.path = linePath.CGPath;
        layer.strokeColor = self.lineColor.CGColor;
        layer.lineWidth = self.lineWidth;
        if (isDot) {
            layer.lineDashPattern = @[@5,@2];
        }
        [self addSublayer:layer];
    }];
}
@end
