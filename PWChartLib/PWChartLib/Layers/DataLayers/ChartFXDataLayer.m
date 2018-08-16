//
//  ChartDataLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXDataLayer.h"
#import "ChartTools.h"
#import "ChartColors.h"

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
    if (!self.baseConfig.showCrossLine) {
        NSInteger idx = self.baseConfig.showIndex;
        if (idx != MIN(self.fxConfig.fxDatas.count - 1, self.baseConfig.currentShowNum + self.baseConfig.currentIndex)) {
            idx = MIN(self.fxConfig.fxDatas.count - 1, self.baseConfig.currentShowNum + self.baseConfig.currentIndex);
            self.baseConfig.showIndex = idx;
        }
    }
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
        if (self.baseConfig.showCrossLinePoint.x >= self.baseConfig.showFrame.origin.x && self.baseConfig.showCrossLinePoint.x <= self.baseConfig.showFrame.size.width + self.baseConfig.showFrame.origin.x) {
            CGFloat num = 0;
            num = (self.baseConfig.showCrossLinePoint.x - [ChartTools getStartX:self.baseConfig.showFrame total:self.baseConfig.currentShowNum]) / (self.baseConfig.showFrame.size.width - [ChartTools getStartX:self.baseConfig.showFrame total:self.baseConfig.currentShowNum] * 2);
            if (self.baseConfig && self.isDrawCrossBottomText && self.fxConfig) {
                [self drawBottomWithNum:num num:num isCross:YES];
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
        NSInteger idx = num * self.baseConfig.currentShowNum + self.baseConfig.currentIndex;
        if (idx < self.baseConfig.currentIndex) {
            idx = self.baseConfig.currentIndex;
        }
        if (idx > self.baseConfig.currentShowNum + self.baseConfig.currentIndex){
            idx = self.baseConfig.currentShowNum + self.baseConfig.currentIndex;
        }
        if (idx >= self.fxConfig.fxDatas.count) {
            idx = self.fxConfig.fxDatas.count - 1;
        }
        self.baseConfig.showIndex = idx;
        if (self.baseConfig && self.fxConfig.fxDatas.count >= idx) {
            CGFloat width = self.baseConfig.showFrame.size.width;
            CGFloat x = width * num + self.baseConfig.showFrame.origin.x;
            
            CGFloat y = self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height;
            CGPoint point = CGPointMake(x, y);
            
            NSString *string = @"";
          
            if (self.fxConfig.fxDatas.count > idx) {
                ChartFXDataModel *model = self.fxConfig.fxDatas[idx];
                model.date = model.date.length > 8 ? model.date : [NSString stringWithFormat:@"%08ld" , (long)[model.date integerValue]];
                model.time = model.time.length > 4 ? model.time : [NSString stringWithFormat:@"%04ld" , (long)[model.time integerValue]];
                if (self.baseConfig.showBottomHourAndMin) {
                    string = [NSString stringWithFormat:@"%@/%@ %@:%@" , [model.date substringWithRange:NSMakeRange(4, 2)] , [model.date substringWithRange:NSMakeRange(6, 2)] , [model.time substringToIndex:2] , [model.time substringFromIndex:2]];
                }else{
                    string = [NSString stringWithFormat:@"%@/%@/%@" , [model.date substringToIndex:4] , [model.date substringWithRange:NSMakeRange(4, 2)] , [model.date substringWithRange:NSMakeRange(6, 2)]];
                }
            }
            
            CGSize size = [ChartTools sizeWithText:string maxSize:CGSizeMake(1000, 1000) fontSize:12];
            point.x = point.x - size.width / (isCross ? 2 : 1);
            //        point.y = point.y - size.height;
            CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
            
            frame.origin.x = frame.origin.x < self.baseConfig.showFrame.origin.x ? self.baseConfig.showFrame.origin.x : frame.origin.x + frame.size.width  > self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width ? self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width - frame.size.width : frame.origin.x;
            
            CATextLayer *layer = [LayerMaker getTextLayer:string point:point font:[UIFont systemFontOfSize:12] foregroundColor:[ChartColors colorByKey:(isCross ? kChartColorKey_TextBorderText : kChartColorKey_Text)] frame:frame];
            if (isCross) {
                layer.backgroundColor = [ChartColors colorByKey:kChartColorKey_TextBorderBackground].CGColor;
                layer.borderColor = [ChartColors colorByKey:kChartColorKey_TextBorder].CGColor;
                layer.borderWidth = .5;
            }
            [self addSublayer:layer];
        }
    }
}
@end
