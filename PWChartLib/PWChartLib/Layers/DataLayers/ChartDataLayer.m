//
//  ChartDataLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartDataLayer.h"
#import "ChartTools.h"

@implementation ChartDataLayer

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
    if (self.baseConfig && self.isDrawLeftText) {
        [self drawLineWithArr:self.baseConfig.verticalSeparateArr];
        [self drawLineWithArr:self.baseConfig.verticalSeparateDottedArr];
    }
    if (self.baseConfig && self.isDrawRightText) {
        [self drawRightWithArr:self.baseConfig.verticalSeparateArr];
        [self drawRightWithArr:self.baseConfig.verticalSeparateDottedArr];
    }
}

- (void)drawCrossText{
    if (self.baseConfig.showCrossLine) {
        CGFloat num = 0;
        num = self.baseConfig.showCrossLinePoint.y / (self.baseConfig.showFrame.size.height - self.baseConfig.showFrame.origin.y);
        if (self.baseConfig && self.isDrawCrossLeftText) {
            [self drawLeftWithNum:num isCross:YES];
        }
        if (self.baseConfig && self.isDrawCrossRightText) {
            [self drawRightWithNum:num isCross:YES];
        }
    }
}

- (void)drawLineWithArr:(NSArray *)arr{
    if (self.baseConfig) {
        __weak typeof(self) weakSelf = self;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CGFloat num = [obj doubleValue];
            [strongSelf drawLeftWithNum:num isCross:NO];
        }];
        
    }
}

- (void)drawRightWithArr:(NSArray *)arr{
    if (self.baseConfig) {
        __weak typeof(self) weakSelf = self;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CGFloat num = [obj doubleValue];
            [strongSelf drawRightWithNum:num isCross:NO];
        }];
    }
}

- (void)drawLeftWithNum:(CGFloat)num isCross:(BOOL)isCross{
    [self drawWithNum:num isLeft:YES isCross:isCross];
}

- (void)drawRightWithNum:(CGFloat)num isCross:(BOOL)isCross{
    [self drawWithNum:num isLeft:NO isCross:isCross];
}

- (void)drawWithNum:(CGFloat)num isLeft:(BOOL)isLeft isCross:(BOOL)isCross{
    if (self.baseConfig) {
        NSInteger digit = self.baseConfig.hqData.digit;
        CGFloat top = self.baseConfig.topPrice;
        CGFloat bottom = self.baseConfig.bottomPrice;
        __block CGFloat value = top - bottom;
        
        CGFloat x = self.baseConfig.showFrame.origin.x;
        CGFloat maxX = self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width;
        CGFloat height = self.baseConfig.showFrame.size.height - self.baseConfig.showFrame.origin.y;
        
        CGFloat y = height * num;
        CGPoint point = CGPointMake(x, y);
        
        CGFloat value2 = value * (1 - num) + bottom;
        NSString *string = chartDigitString(digit, [NSString stringWithFormat:@"%f" , value2]);
        if (!isLeft) {
            value2 = (value2 - value / 2) / (value / 2 + bottom) * 100;
            string = [NSString stringWithFormat:@"%.2f%%" , value2];
            point = CGPointMake(maxX, y);
        }
        CGSize size = [ChartTools sizeWithText:string maxSize:CGSizeMake(1000, 1000) fontSize:12];
        CGRect frame = CGRectMake(isCross ? point.x : point.x + 5, point.y - size.height / 2, isCross ? size.width + 10 : size.width, size.height);
        if (!isLeft) {
            frame = CGRectMake(point.x - size.width - 10, point.y - size.height / 2, isCross ? size.width + 10 : size.width, size.height);
        }
        frame = [self chackFrame:frame];
        CATextLayer *layer = [LayerMaker getTextLayer:string point:point font:[UIFont systemFontOfSize:12] foregroundColor:[UIColor grayColor] frame:frame];
        if (isCross) {
            layer.backgroundColor = [UIColor whiteColor].CGColor;
            layer.borderColor = [UIColor grayColor].CGColor;
            layer.borderWidth = .5;
        }
        [self addSublayer:layer];
    }
}

- (CGRect)chackFrame:(CGRect)frame{
    CGFloat minY = self.baseConfig.showFrame.origin.y;
    CGFloat maxY = self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height;
    if (frame.origin.y < minY) {
        frame.origin.y = minY;
    }else if (frame.origin.y + frame.size.height > maxY){
        frame.origin.y = maxY - frame.size.height;
    }
    return frame;
}
@end
