//
//  ChartsLayer.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "ChartsLayer.h"
#import "ChartFSDataModel.h"
#import "ChartFXDataModel.h"
#import "PWChartColors.h"

@implementation ChartsLayer

- (void)install{
    [super install];
}

- (void)startDraw{
    [super startDraw];
}

- (void)setFsConfig:(ChartFSViewModel *)fsConfig{
    _fsConfig = fsConfig;
    _fxConfig = nil;
}

- (void)setFxConfig:(ChartFXViewModel *)fxConfig{
    _fxConfig = fxConfig;
    _fsConfig = nil;
}

- (void)drawKLine:(ChartFXViewModel *)fxConfig{
    [self clearLayers];
    self.fxConfig = fxConfig;
    if (_fxConfig && [_fxConfig.fxDatas count] > 0) {
        __block NSMutableArray *models = [[NSMutableArray alloc] init];
        NSArray *arr = [NSArray arrayWithArray:_fxConfig.fxDatas];
        for (NSInteger i = self.baseConfig.currentIndex; i < self.baseConfig.currentIndex + self.baseConfig.currentShowNum; i++) {
            if (i < self.fxConfig.fxDatas.count) {
                ChartFXDataModel *model = arr[i];
                CandlestickModel *cModel = [[CandlestickModel alloc] init];
                cModel.top = [model.topPrice floatValue];
                cModel.bottom = [model.bottomPrice floatValue];
                cModel.open = [model.openPrice floatValue];
                cModel.close = [model.closePrice floatValue];
                [models addObject:cModel];
            }
        }
        
        LayerMakerCandlestickDataModel *candlestickDataModel = [[LayerMakerCandlestickDataModel alloc] init];
        candlestickDataModel.showFrame = self.baseConfig.showFrame;
        candlestickDataModel.total = self.baseConfig.currentShowNum;
        candlestickDataModel.top = self.baseConfig.topPrice;
        candlestickDataModel.bottom = self.baseConfig.bottomPrice;
        candlestickDataModel.candlestickDatas = models;
        candlestickDataModel.clrUp = [PWChartColors colorByKey:kChartColorKey_Rise];
        candlestickDataModel.clrDown = [PWChartColors colorByKey:kChartColorKey_Fall];
        candlestickDataModel.clrBal = [PWChartColors colorByKey:kChartColorKey_Stay];
        candlestickDataModel.start = 0;
        candlestickDataModel.lineType = 1;
        CALayer *layer = [LayerMaker getCandlestickLine:candlestickDataModel];
        
        candlestickDataModel.clrUp = [PWChartColors colorByKey:kChartColorKey_Text];
        candlestickDataModel.clrDown = [PWChartColors colorByKey:kChartColorKey_Text];
        LayerMakerTextModel *textModel = [[LayerMakerTextModel alloc] init];
        textModel.digit = fxConfig.baseConfig.digit;
        textModel.font = [UIFont fontWithName:[ChartConfig shareConfig].fontName size:[ChartConfig shareConfig].fontSize];
        CALayer *textLayer = [LayerMaker getCandlestickLineTopAndBottomValue:candlestickDataModel textLayer:textModel];
        [layer addSublayer:textLayer];
        [self addSublayer:layer];
    }
}

- (void)drawFSLine:(ChartFSViewModel *)fsConfig{
    [self clearLayers];
    self.fsConfig = fsConfig;
    if (_fsConfig && [_fsConfig.fsDatas count] > 0) {
        __block NSMutableArray *nowArray = [[NSMutableArray alloc] init];
        __block NSMutableArray *avgArray = [[NSMutableArray alloc] init];
        __block NSMutableArray *thirdArray = [[NSMutableArray alloc] init];
        NSArray *arr = [NSArray arrayWithArray:_fsConfig.fsDatas];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChartFSDataModel *model = obj;
            [nowArray addObject:@(model.nowPrice.doubleValue)];
            [avgArray addObject:@(model.avgPrice.doubleValue)];
            [thirdArray addObject:@(model.thirdLine.doubleValue)];
        }];
        
        CGFloat top;
        CGFloat bottom;
        if (!self.baseConfig.independentTopBottomPrice) {
            [self.fsConfig checkTopAndBottomPrice];
            top = self.baseConfig.topPrice;
            bottom = self.baseConfig.bottomPrice;
        }else{
            NSDictionary * dict = [self.fsConfig checkTopAndBottomPrice:@[@"nowPrice"]];
            top = [dict[@"top"] doubleValue];
            bottom = [dict[@"bottom"] doubleValue];
        }
        LayerMakerLineChartDataModel *lineChartDataModel = [[LayerMakerLineChartDataModel alloc] init];
        lineChartDataModel.showFrame = self.baseConfig.showFrame;
        lineChartDataModel.total = self.baseConfig.maxPointCount;
        lineChartDataModel.top = top;
        lineChartDataModel.bottom = bottom;
        lineChartDataModel.lineChartDatas = nowArray;
        lineChartDataModel.start = 0;
        lineChartDataModel.startX = [ChartConfig shareConfig].chartLineWidth/2;
        CAShapeLayer *nowLayer = [LayerMaker getLineChartLayer:lineChartDataModel];
        nowLayer.lineWidth = [ChartConfig shareConfig].chartLineWidth;
        nowLayer.strokeColor = [PWChartColors colorByKey:kChartColorKey_XJ].CGColor;
        [self addSublayer:nowLayer];
        
        if (fsConfig.isShowShadow) {
            UIColor *fromColor = [[PWChartColors colorByKey:kChartColorKey_XJFrom] colorWithAlphaComponent:.5];
            UIColor *toColor = [[PWChartColors colorByKey:kChartColorKey_XJTo] colorWithAlphaComponent:.1];
            CAGradientLayer *gradientLayer = [LayerMaker drawGredientLayer:self.baseConfig.showFrame path:nowLayer.path fromColor:fromColor toColor:toColor];
            CGRect f = self.baseConfig.showFrame;
            f.size.width = f.size.width + f.origin.x;
            f.origin.x = 0;
            f.size.height = f.size.height + f.origin.y;
            f.origin.y = 0;
            gradientLayer.frame = f;
            [self addSublayer:gradientLayer];
        }
        
        if (fsConfig.isShowMA) {
            if (!self.baseConfig.independentTopBottomPrice) {
                top = self.baseConfig.topPrice;
                bottom = self.baseConfig.bottomPrice;
            }else{
                NSDictionary * dict = [self.fsConfig checkTopAndBottomPrice:@[@"avgPrice"]];
                top = [dict[@"top"] doubleValue];
                bottom = [dict[@"bottom"] doubleValue];
            }
            LayerMakerLineChartDataModel *lineChartDataModel = [[LayerMakerLineChartDataModel alloc] init];
            lineChartDataModel.showFrame = self.baseConfig.showFrame;
            lineChartDataModel.total = self.baseConfig.maxPointCount;
            lineChartDataModel.top = top;
            lineChartDataModel.bottom = bottom;
            lineChartDataModel.lineChartDatas = avgArray;
            lineChartDataModel.start = 0;
            lineChartDataModel.startX = [ChartConfig shareConfig].chartLineWidth/2;
            CAShapeLayer *avgLayer = [LayerMaker getLineChartLayer:lineChartDataModel];
            avgLayer.lineWidth = [ChartConfig shareConfig].chartLineWidth;
            avgLayer.strokeColor = [PWChartColors colorByKey:kChartColorKey_JJ].CGColor;
            [self addSublayer:avgLayer];
        }
        
        if (fsConfig.isShowThirdLine) {
            if (!self.baseConfig.independentTopBottomPrice) {
                top = self.baseConfig.topPrice;
                bottom = self.baseConfig.bottomPrice;
            }else{
                NSDictionary * dict = [self.fsConfig checkTopAndBottomPrice:@[@"thirdLine"]];
                top = [dict[@"top"] doubleValue];
                bottom = [dict[@"bottom"] doubleValue];
            }
            LayerMakerLineChartDataModel *lineChartDataModel = [[LayerMakerLineChartDataModel alloc] init];
            lineChartDataModel.showFrame = self.baseConfig.showFrame;
            lineChartDataModel.total = self.baseConfig.maxPointCount;
            lineChartDataModel.top = top;
            lineChartDataModel.bottom = bottom;
            lineChartDataModel.lineChartDatas = thirdArray;
            lineChartDataModel.start = 0;
            lineChartDataModel.startX = [ChartConfig shareConfig].chartLineWidth/2;
            CAShapeLayer *avgLayer = [LayerMaker getLineChartLayer:lineChartDataModel];
            avgLayer.lineWidth = [ChartConfig shareConfig].chartLineWidth;
            avgLayer.strokeColor = [PWChartColors colorByKey:kChartColorKey_ThirdLine].CGColor;
            [self addSublayer:avgLayer];
        }
    }
}

- (void)drawVOL:(id)ztConfig{
    [self clearLayers];
    NSArray *array;
    if ([ztConfig isKindOfClass:[ChartFXViewModel class]]) {
        self.fxConfig = ztConfig;
        array = (NSArray *)self.fxConfig.fxDatas;
    }else if ([ztConfig isKindOfClass:[ChartFSViewModel class]]){
        self.fsConfig = ztConfig;
        array = (NSArray *)self.fsConfig.fsDatas;
    }
    if (array.count > 0) {
        __block NSMutableArray *volArray = [[NSMutableArray alloc] init];
        NSArray *arr = [NSArray arrayWithArray:array];
        if ([ztConfig isKindOfClass:[ChartFXViewModel class]]) {
            NSInteger start = self.baseConfig.currentIndex < arr.count ? self.baseConfig.currentIndex : array.count - 1;
            NSInteger length = arr.count - start > self.baseConfig.currentShowNum ? self.baseConfig.currentShowNum : arr.count - start;
            arr = [array subarrayWithRange:NSMakeRange(self.baseConfig.currentIndex < arr.count ? self.baseConfig.currentIndex : start, length)];
        }else if ([ztConfig isKindOfClass:[ChartFSViewModel class]]){
            arr = [NSArray arrayWithArray:array];
        }
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StickModel *sModel = [[StickModel alloc] init];
            if (self.fsConfig) {
                ChartFSDataModel *model = obj;
                sModel.color = [model.nowPrice doubleValue] > [model.perFSModel.nowPrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Rise] : [model.nowPrice doubleValue] < [model.perFSModel.nowPrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Fall] : [PWChartColors colorByKey:kChartColorKey_Stay];
                sModel.value = model.nowVol.doubleValue;
            }else if (self.fxConfig) {
                ChartFXDataModel *model = obj;
                sModel.color = [model.closePrice doubleValue] > [model.openPrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Rise] : [model.closePrice doubleValue] < [model.openPrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Fall] : [model.closePrice doubleValue] > [model.perFXModel.closePrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Rise] : [model.closePrice doubleValue] < [model.perFXModel.closePrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Fall] : [PWChartColors colorByKey:kChartColorKey_Rise];
                sModel.value = model.volume.doubleValue;
            }
            [volArray addObject:sModel];
        }];
        CALayer *volLayer;
        LayerMakerStickDataModel *stickDataModel = [[LayerMakerStickDataModel alloc] init];
        stickDataModel.showFrame = self.baseConfig.showFrame;
        stickDataModel.total = self.baseConfig.currentShowNum;
        stickDataModel.top = self.baseConfig.topPrice;
        stickDataModel.bottom = self.baseConfig.bottomPrice;
        stickDataModel.stickDatas = volArray;
        stickDataModel.lineWidth = -1;
        if ([ztConfig isKindOfClass:[ChartFXViewModel class]]) {
            volLayer = [LayerMaker getStickLine:stickDataModel];
        }else if ([ztConfig isKindOfClass:[ChartFSViewModel class]]){
            stickDataModel.total = self.baseConfig.maxPointCount;
            volLayer = [LayerMaker getStickLine:stickDataModel];
        }
        if (volLayer) {
            [self addSublayer:volLayer];
        }
    }
}
@end
