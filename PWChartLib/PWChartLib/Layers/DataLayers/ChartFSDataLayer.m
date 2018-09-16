//
//  ChartDataLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFSDataLayer.h"
#import "ChartTools.h"
#import "PWChartColors.h"
#import "ChartConfig.h"

@implementation ChartFSDataLayer

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
            num = (self.baseConfig.showCrossLinePoint.x - self.baseConfig.showFrame.origin.x) / (self.baseConfig.showFrame.size.width);
            if (self.baseConfig && self.isDrawCrossBottomText && self.fsConfig) {
                [self drawBottomWithNum:0 num:num isCross:YES];
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
        CGFloat width = self.baseConfig.showFrame.size.width;
        CGFloat x = width * num + self.baseConfig.showFrame.origin.x;
        
        CGFloat y = self.baseConfig.showFrame.origin.y + self.baseConfig.showFrame.size.height;
        CGPoint point = CGPointMake(x, y);
        
        NSString *string = @"";
        if (isCross) {
            if (self.fsConfig.fsDatas.count != 0) {
                NSInteger idx = num * self.baseConfig.maxPointCount;
                if (idx >= self.fsConfig.fsDatas.count) {
                    idx = _fsConfig.fsDatas.count - 1;
                }
                ChartFSDataModel *model = _fsConfig.fsDatas[idx];
                if (self.baseConfig.showBottomType == BottomDataType_DateAndTime) {
                    string = [NSString stringWithFormat:@"%@/%@ %@:%@" , [model.date substringWithRange:NSMakeRange(4, 2)] , [model.date substringWithRange:NSMakeRange(6, 2)] , [model.time substringToIndex:2] , [model.time substringFromIndex:2]];
                }else if (self.baseConfig.showBottomType == BottomDataType_Date) {
                    string = [NSString stringWithFormat:@"%@/%@/%@" , [model.date substringToIndex:4] , [model.date substringWithRange:NSMakeRange(4, 2)] , [model.date substringWithRange:NSMakeRange(6, 2)]];
                }else if (self.baseConfig.showBottomType == BottomDataType_Time) {
                    string = [NSString stringWithFormat:@"%@:%@" , [model.time substringToIndex:2] , [model.time substringFromIndex:2]];
                }
            }
        }else{
            if (self.fsConfig.times.count != 0 && self.fsConfig.times.count >= index) {
                if (index == 0) {
                    ChartFSTimeModel *model = self.fsConfig.times[index];
                    string = [NSString stringWithFormat:@"%02ld:%02ld" , model.start / 60 , model.start % 60];
                }else if (index == self.fsConfig.times.count){
                    ChartFSTimeModel *model = self.fsConfig.times[index - 1];
                    string = [NSString stringWithFormat:@"%02ld:%02ld" , model.end % (60 * 24) / 60 , model.end % 60];
                }else{
                    ChartFSTimeModel *model1 = self.fsConfig.times[index - 1];
                    ChartFSTimeModel *model2 = self.fsConfig.times[index];
                    string = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld" , model1.end % (60 * 24) / 60 , model1.end % 60 , model2.start / 60 , model2.start % 60];
                }
            }else{
                NSInteger idx = index * (self.fsConfig.fsDatas.count - 1);
                if (self.fsConfig.fsDatas.count > idx) {
                    ChartFSDataModel *model = self.fsConfig.fsDatas[idx];
                    if (self.baseConfig.showBottomType == BottomDataType_DateAndTime) {
                        string = [NSString stringWithFormat:@"%@/%@ %@:%@" , [model.date substringWithRange:NSMakeRange(4, 2)] , [model.date substringWithRange:NSMakeRange(6, 2)] , [model.time substringToIndex:2] , [model.time substringFromIndex:2]];
                    }else if (self.baseConfig.showBottomType == BottomDataType_Date) {
                        string = [NSString stringWithFormat:@"%@/%@/%@" , [model.date substringToIndex:4] , [model.date substringWithRange:NSMakeRange(4, 2)] , [model.date substringWithRange:NSMakeRange(6, 2)]];
                    }else if (self.baseConfig.showBottomType == BottomDataType_Time) {
                        string = [NSString stringWithFormat:@"%@:%@" , [model.time substringToIndex:2] , [model.time substringFromIndex:2]];
                    }
                }
            }
        }
        
        CGSize size = [ChartTools sizeWithText:string maxSize:CGSizeMake(1000, 1000) fontSize:12];
        point.x = point.x - size.width / (isCross ? 2 : 1);
//        point.y = point.y - size.height;
        CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
        
        frame.origin.x = frame.origin.x < self.baseConfig.showFrame.origin.x ? self.baseConfig.showFrame.origin.x : frame.origin.x + frame.size.width  > self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width ? self.baseConfig.showFrame.origin.x + self.baseConfig.showFrame.size.width - frame.size.width : frame.origin.x;
        
        CATextLayer *layer = [LayerMaker getTextLayer:string point:point font:[UIFont fontWithName:[ChartConfig shareConfig].fontName size:10] foregroundColor:[PWChartColors colorByKey:(isCross ? kChartColorKey_TextBorderText : kChartColorKey_Text)] frame:frame];
        if (isCross) {
            layer.backgroundColor = [PWChartColors colorByKey:kChartColorKey_TextBorderBackground].CGColor;
            layer.borderColor = [PWChartColors colorByKey:kChartColorKey_TextBorder].CGColor;
            layer.borderWidth = .5;
        }
        [self addSublayer:layer];
    }
}
@end
