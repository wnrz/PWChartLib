//
//  ChartFSView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFSView.h"
#import "ChartZBView.h"

@implementation ChartFSView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
    [_fsDataLayer removeFromSuperlayer];
    _fsDataLayer = nil;
}

- (void)install{
    [super install];
    self.ztView = self;
    _fsConfig = [[ChartFSViewModel alloc] initWithBaseConfig:self.baseConfig];
    
    _fsDataLayer = [[ChartFSDataLayer alloc] init];
    _fsDataLayer.baseConfig = self.baseConfig;
    _fsDataLayer.fsConfig = self.fsConfig;
    [self.layer insertSublayer:_fsDataLayer above:self.dataLayer];
    
    self.enableScale = NO;
    self.baseConfig.isDrawLeftText = YES;
    self.baseConfig.isDrawRightText = YES;
    self.baseConfig.isDrawCrossLeftText = YES;
    self.baseConfig.isDrawCrossRightText = YES;
    self.baseConfig.isLeftRiseFallColor = YES;
    self.baseConfig.isRightRiseFallColor = YES;
}

- (void)initFormLayer{
    
}

- (NSInteger)dataNumber{
    return _fsConfig.fsDatas.count;
}

- (void)startDraw{
    if (!self.baseConfig.hqData) {
        return;
    }
    [self.formLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.chartsLayer drawFSLine:_fsConfig];
    
    [self.crossLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.dataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartDataLayer *)obj setIsDrawLeftText:self.fsDataLayer.baseConfig.isDrawLeftText];
        [(ChartDataLayer *)obj setIsDrawRightText:self.fsDataLayer.baseConfig.isDrawRightText];
        [(ChartDataLayer *)obj setIsDrawCrossLeftText:self.fsDataLayer.baseConfig.isDrawCrossLeftText];
        [(ChartDataLayer *)obj setIsDrawCrossRightText:self.fsDataLayer.baseConfig.isDrawCrossRightText];
        [(ChartDataLayer *)obj setIsLeftRiseFallColor:self.fsDataLayer.baseConfig.isLeftRiseFallColor];
        [(ChartDataLayer *)obj setIsRightRiseFallColor:self.fsDataLayer.baseConfig.isRightRiseFallColor];
    }];
    
    [_fsDataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartFSDataLayer *)obj setIsDrawBottomText:YES];
        [(ChartFSDataLayer *)obj setIsDrawCrossBottomText:YES];
    }];
    
}

- (void)saveDatas:(NSArray *)datas{
    if (datas.count == 0) {
        return;
    }
    [_fsConfig saveDatas:datas];
    NSArray *arr = [NSArray arrayWithArray:self.ftViews];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartZBView *zbView = obj;
        [zbView.config getZBData];
        [zbView startDraw];
    }];
    [self startDraw];
}

- (void)clearData{
    [_fsConfig.fsDatas removeAllObjects];
    [self startDraw];
}

- (void)changeZB:(NSString *)zbName{
    
}

- (void)setTimes:(NSArray<ChartFSTimeModel *> *)times{
    _fsConfig.times = times;
    [self SyncParameterConfigs];
}

- (void)updateTopAndBottomTimeByHQData:(ChartHQDataModel *)model{
    [_fsConfig updateTopAndBottomTimeByHQData:model];
}

- (CGPoint)correctCrossLinePoint:(CGPoint)crossLinePoint{
    CGPoint point = [super correctCrossLinePoint:crossLinePoint];
    if (_fsConfig.fsDatas.count > self.baseConfig.showIndex && self.baseConfig.showIndex >= 0 && self.baseConfig.topPrice != self.baseConfig.bottomPrice) {
        ChartFSDataModel *model = _fsConfig.fsDatas[self.baseConfig.showIndex];
        CGFloat num = ([model.nowPrice doubleValue] - self.baseConfig.bottomPrice) / (self.baseConfig.topPrice - self.baseConfig.bottomPrice);
        CGFloat y = self.showFrame.origin.y + self.showFrame.size.height * (1 - num);
        point.y = y;
    }
    return point;
}
@end
