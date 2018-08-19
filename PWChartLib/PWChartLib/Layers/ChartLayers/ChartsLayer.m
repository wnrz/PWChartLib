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
        
        CALayer *layer = [LayerMaker getCandlestickLine:self.baseConfig.showFrame total:self.baseConfig.currentShowNum top:self.baseConfig.topPrice bottom:self.baseConfig.bottomPrice models:models clrUp:[PWChartColors colorByKey:kChartColorKey_Rise] clrDown:[PWChartColors colorByKey:kChartColorKey_Fall] clrBal:[PWChartColors colorByKey:kChartColorKey_Stay] start:0 lineType:1];
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
            top = self.baseConfig.topPrice;
            bottom = self.baseConfig.bottomPrice;
        }else{
            NSDictionary * dict = [self.fsConfig chackTopAndBottomPrice:@[@"nowPrice"]];
            top = [dict[@"top"] doubleValue];
            bottom = [dict[@"bottom"] doubleValue];
        }
        CAShapeLayer *nowLayer = [LayerMaker getLineChartLayer:self.baseConfig.showFrame total:self.baseConfig.maxPointCount top:top bottom:bottom   arr:nowArray start:0 startX:0];
        nowLayer.lineWidth = .5;
        nowLayer.strokeColor = [PWChartColors colorByKey:kChartColorKey_XJ].CGColor;
        [self addSublayer:nowLayer];
        
        if (fsConfig.isShowShadow) {
            CAGradientLayer *gradientLayer = [LayerMaker drawGredientLayer:self.baseConfig.showFrame path:nowLayer.path color:[PWChartColors colorByKey:kChartColorKey_XJ]];
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
                NSDictionary * dict = [self.fsConfig chackTopAndBottomPrice:@[@"avgPrice"]];
                top = [dict[@"top"] doubleValue];
                bottom = [dict[@"bottom"] doubleValue];
            }
            CAShapeLayer *avgLayer = [LayerMaker getLineChartLayer:self.baseConfig.showFrame total:self.baseConfig.maxPointCount top:top bottom:bottom arr:avgArray start:0 startX:0];
            avgLayer.lineWidth = .5;
            avgLayer.strokeColor = [PWChartColors colorByKey:kChartColorKey_JJ].CGColor;
            [self addSublayer:avgLayer];
        }
        
        if (fsConfig.isShowThirdLine) {
            if (!self.baseConfig.independentTopBottomPrice) {
                top = self.baseConfig.topPrice;
                bottom = self.baseConfig.bottomPrice;
            }else{
                NSDictionary * dict = [self.fsConfig chackTopAndBottomPrice:@[@"thirdLine"]];
                top = [dict[@"top"] doubleValue];
                bottom = [dict[@"bottom"] doubleValue];
            }
            CAShapeLayer *avgLayer = [LayerMaker getLineChartLayer:self.baseConfig.showFrame total:self.baseConfig.maxPointCount top:top bottom:bottom arr:thirdArray start:0 startX:0];
            avgLayer.lineWidth = .5;
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
                sModel.color = [model.closePrice doubleValue] > [model.openPrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Rise] : [model.closePrice doubleValue] < [model.openPrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Fall] : [model.closePrice doubleValue] > [model.perFXModel.closePrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Rise] : [model.closePrice doubleValue] < [model.perFXModel.closePrice doubleValue] ? [PWChartColors colorByKey:kChartColorKey_Fall] : [PWChartColors colorByKey:kChartColorKey_Stay];
                sModel.value = model.volume.doubleValue;
            }
            [volArray addObject:sModel];
        }];
        CALayer *volLayer;
        if ([ztConfig isKindOfClass:[ChartFXViewModel class]]) {
            volLayer = [LayerMaker getStickLine:self.baseConfig.showFrame total:self.baseConfig.currentShowNum top:self.baseConfig.topPrice bottom:self.baseConfig.bottomPrice models:volArray start:0 lineWidth:-1];
        }else if ([ztConfig isKindOfClass:[ChartFSViewModel class]]){
            volLayer = [LayerMaker getStickLine:self.baseConfig.showFrame total:self.baseConfig.maxPointCount top:self.baseConfig.topPrice bottom:self.baseConfig.bottomPrice models:volArray start:0 lineWidth:-1];
        }
        if (volLayer) {
            [self addSublayer:volLayer];
        }
    }
}
@end
