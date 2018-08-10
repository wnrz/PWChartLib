//
//  ChartDataLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXDataLayer.h"
#import "ChartTools.h"

@implementation ChartFXDataLayer

- (void)install{
    [super install];
}

- (void)setBaseConfig:(ChartBaseViewModel *)baseConfig{
    super.baseConfig ? [super.baseConfig removeAllBridge] : 0;
    super.baseConfig = baseConfig;
    [baseConfig addBridgeObserver:self forKeyPath:@"showCrossLine" action:@selector(startDraw)];
    [baseConfig addBridgeObserver:self forKeyPath:@"showCrossLinePoint" action:@selector(startDraw)];
}

- (void)startDraw{
    [super startDraw];
    
    [self drawText];
    [self drawCrossText];
}

- (void)drawText{
    if (self.baseConfig && self.isDrawBottomText) {
        [self drawBottomWithArr:self.baseConfig.horizontalSeparateArr];
        [self drawBottomWithArr:self.baseConfig.horizontalSeparateDottedArr];
    }
}

- (void)drawCrossText{
    if (self.baseConfig.showCrossLine) {
        if (self.baseConfig.showCrossLinePoint.y >= self.baseConfig.showFrame.origin.y && self.baseConfig.showCrossLinePoint.y <= self.baseConfig.showFrame.size.height + self.baseConfig.showFrame.origin.y) {
            CGFloat num = 0;
            num = self.baseConfig.showCrossLinePoint.y / (self.baseConfig.showFrame.size.height - self.baseConfig.showFrame.origin.y);
            if (self.baseConfig && self.isDrawCrossBottomText && self.fxConfig) {
                //
            }
        }
    }
}

- (void)drawBottomWithArr:(NSArray *)arr{
    if (self.baseConfig) {
        __weak typeof(self) weakSelf = self;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CGFloat num = [obj doubleValue];
            [strongSelf drawBottomWithNum:idx num:num isCross:NO];
        }];
    }
}

- (void)drawBottomWithNum:(NSInteger)index num:(CGFloat)num isCross:(BOOL)isCross{
    if (self.baseConfig) {
        NSInteger digit = self.baseConfig.hqData.digit;
        CGFloat top = self.baseConfig.topPrice;
        CGFloat bottom = self.baseConfig.bottomPrice;
        __block CGFloat value = top - bottom;
        
        CGFloat width = self.baseConfig.showFrame.size.width - self.baseConfig.showFrame.origin.x;
        CGFloat x = width * num;
        
        CGFloat y = self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height;
        CGPoint point = CGPointMake(x, y);
        
        CGFloat value2 = value * (1 - num) + bottom;
        NSString *string = chartDigitString(digit, [NSString stringWithFormat:@"%f" , value2]);
        
        CGSize size = [ChartTools sizeWithText:string maxSize:CGSizeMake(1000, 1000) fontSize:12];
        CGRect frame = CGRectMake(isCross ? point.x : point.x + 5, point.y - size.height / 2, isCross ? size.width + 10 : size.width, size.height);
        
        frame.origin.x = frame.origin.x < self.baseConfig.showFrame.origin.x ? self.baseConfig.showFrame.origin.x : frame.origin.x + frame.size.width  > self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width ? self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width - frame.size.width : frame.origin.x;
        
        CATextLayer *layer = [LayerMaker getTextLayer:string point:point font:[UIFont systemFontOfSize:12] foregroundColor:[UIColor grayColor] frame:frame];
        if (isCross) {
            layer.backgroundColor = [UIColor whiteColor].CGColor;
            layer.borderColor = [UIColor grayColor].CGColor;
            layer.borderWidth = .5;
        }
        [self addSublayer:layer];
    }
}
@end
