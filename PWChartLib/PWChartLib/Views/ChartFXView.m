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
    _fxconfig = [[ChartFXViewModel alloc] initWithBaseConfig:self.baseConfig];
    
    _fxDataLayer = [[ChartFXDataLayer alloc] init];
    _fxDataLayer.baseConfig = self.baseConfig;
    _fxDataLayer.fxConfig = self.fxconfig;
    [self.layer insertSublayer:_fxDataLayer above:self.dataLayer];
}

- (NSInteger)dataNumber{
    return _fxconfig.fxDatas.count;
}

- (void)startDraw{
    [super startDraw];
    [_fxDataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartFXDataLayer *)obj setIsDrawBottomText:YES];
        [(ChartFXDataLayer *)obj setIsDrawCrossBottomText:YES];
    }];
}

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas{
    if (datas.count == 0) {
        return;
    }
    if (datas.count > 1) {
        [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ChartFXDataModel *model1 = obj1;
            ChartFXDataModel *model2 = obj2;
            if (model1.timeStamp.longLongValue < model2.timeStamp.longLongValue) {
                return NSOrderedAscending;
            }else if (model1.timeStamp.longLongValue > model2.timeStamp.longLongValue){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
        }];
    }
    
    __block ChartFXDataModel *tmp;
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartFXDataModel *model = obj;
        if (idx == 0) {
            tmp = model;
        }
        model.perFXModel = tmp;
    }];
    [_fxconfig saveDatas:datas];
    
    [self startDraw];
}
@end
