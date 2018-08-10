//
//  ChartsLayer.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "ChartsLayer.h"
#import "ChartFSDataModel.h"
#import "ChartFXDataModel.h"
#import "ChartColors.h"

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
    self.fxConfig = fxConfig;
    if (_fxConfig && [_fxConfig.fxDatas count] > 0) {
        __block NSMutableArray *top = [[NSMutableArray alloc] init];
        __block NSMutableArray *bottom = [[NSMutableArray alloc] init];
        __block NSMutableArray *open = [[NSMutableArray alloc] init];
        __block NSMutableArray *close = [[NSMutableArray alloc] init];
        NSArray *arr = [NSArray arrayWithArray:_fxConfig.fxDatas];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChartFXDataModel *model = obj;
            [top addObject:model.topPrice];
            [bottom addObject:model.bottomPrice];
            [open addObject:model.openPrice];
            [close addObject:model.closePrice];
        }];
    }
}

- (void)drawFSLine:(ChartFSViewModel *)fsConfig{
    self.fsConfig = fsConfig;
    if (_fsConfig && [_fsConfig.fsDatas count] > 0) {
        __block NSMutableArray *nowArray = [[NSMutableArray alloc] init];
        __block NSMutableArray *avgArray = [[NSMutableArray alloc] init];
        NSArray *arr = [NSArray arrayWithArray:_fsConfig.fsDatas];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChartFSDataModel *model = obj;
            [nowArray addObject:@(model.nowPrice.doubleValue)];
            [avgArray addObject:@(model.avgVol.doubleValue)];
        }];
        CAShapeLayer *nowLayer = [LayerMaker getLineChartLayer:self.baseConfig.showFrame total:self.baseConfig.maxPointCount top:self.baseConfig.topPrice bottom:self.baseConfig.bottomPrice arr:nowArray start:0 startX:0];
        nowLayer.lineWidth = .5;
        nowLayer.strokeColor = [ChartColors colorByKey:kChartColorKey_XJ].CGColor;
        [self addSublayer:nowLayer];
        
        if (fsConfig.isShowMA) {
            CAShapeLayer *avgLayer = [LayerMaker getLineChartLayer:self.baseConfig.showFrame total:self.baseConfig.maxPointCount top:self.baseConfig.topPrice bottom:self.baseConfig.bottomPrice arr:avgArray start:0 startX:0];
            avgLayer.lineWidth = .5;
            avgLayer.strokeColor = [ChartColors colorByKey:kChartColorKey_JJ].CGColor;
            [self addSublayer:nowLayer];
        }
    }
}
@end
