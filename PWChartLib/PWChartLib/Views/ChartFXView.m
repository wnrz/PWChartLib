//
//  ChartFXView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXView.h"

@implementation ChartFXView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
    [_fxDataLayer removeFromSuperlayer];
    _fxDataLayer = nil;
}

- (void)install{
    [super install];
    self.ztView = self;
    _fxConfig = [[ChartFXViewModel alloc] initWithBaseConfig:self.baseConfig];
    
    _fxDataLayer = [[ChartFXDataLayer alloc] init];
    _fxDataLayer.baseConfig = self.baseConfig;
    _fxDataLayer.fxConfig = self.fxConfig;
    [self.layer insertSublayer:_fxDataLayer above:self.dataLayer];
}

- (NSInteger)dataNumber{
    return _fxConfig.fxDatas.count;
}

- (void)startDraw{
    self.baseConfig.topPrice = 0;
    self.baseConfig.bottomPrice = 0;
    [_fxConfig chackTopAndBottomPrice];
    
    if (!self.baseConfig.hqData) {
        return;
    }
    [self.formLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.chartsLayer drawKLine:_fxConfig];
    
    [self.crossLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.dataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartDataLayer *)obj setIsDrawLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawRightText:NO];
        [(ChartDataLayer *)obj setIsDrawCrossLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawCrossRightText:NO];
    }];
    
    [_fxDataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartFXDataLayer *)obj setIsDrawBottomText:YES];
        [(ChartFXDataLayer *)obj setIsDrawCrossBottomText:YES];
    }];
}

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas{
    if (datas.count == 0) {
        return;
    }
    [_fxConfig saveDatas:datas];
    [self startDraw];
}
@end
