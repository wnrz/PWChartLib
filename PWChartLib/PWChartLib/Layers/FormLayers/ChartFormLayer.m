//
//  ChartFormLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFormLayer.h"
#import "PWChartColors.h"

@implementation ChartFormLayer

- (void)install{
    [super install];
}


- (void)startDraw{
    [super startDraw];
    self.lineWidth = .1;
    [self drawForm];
}

- (void)drawForm{
    if (self.baseConfig) {
        [self drawLineWithArr:self.baseConfig.verticalSeparateArr isVer:YES isDot:NO];
        [self drawLineWithArr:self.baseConfig.horizontalSeparateArr isVer:NO isDot:NO];
        [self drawLineWithArr:self.baseConfig.verticalSeparateDottedArr isVer:YES isDot:YES];
        [self drawLineWithArr:self.baseConfig.horizontalSeparateDottedArr isVer:NO isDot:YES];
    }
}

- (void)drawLineWithArr:(NSArray *)arr isVer:(BOOL)isVer isDot:(BOOL)isDot{
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat num = [obj floatValue];
        CGPoint startPoint;
        CGPoint endPoint;
        if (isVer) {
            startPoint = CGPointMake(self.baseConfig.showFrame.origin.x , self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height * num);
            endPoint = CGPointMake(self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width, self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height * num);
        }else{
            startPoint = CGPointMake(self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width * num, self.baseConfig.showFrame.origin.y);
            endPoint = CGPointMake(self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width * num, self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height);
        }
        
        CAShapeLayer *layer = [LayerMaker getLineLayer:startPoint toPoint:endPoint isDot:isDot];
        layer.strokeColor = [PWChartColors colorByKey:kChartColorKey_Form].CGColor;
        layer.lineWidth = self.lineWidth;
        [self addSublayer:layer];
    }];
}
@end
