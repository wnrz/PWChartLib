//
//  ChartsLayer.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "ChartsLayer.h"
#import "ChartFSDataModel.h"
#import "ChartFXDataModel.h"

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
    _fxConfig = fxConfig;
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
    _fsConfig = fsConfig;
    if (_fsConfig && [_fsConfig.fsDatas count] > 0) {
        
    }
}
@end
