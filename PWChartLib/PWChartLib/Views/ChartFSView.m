//
//  ChartFSView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFSView.h"

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
}

- (void)initFormLayer{
    
}

- (NSInteger)dataNumber{
    return _fsConfig.fsDatas.count;
}

- (void)startDraw{
    [super startDraw];
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
}

- (void)setTimes:(NSArray<ChartFSTimeModel *> *)times{
    _fsConfig.times = times;
}

- (void)updateTopAndBottomTimeByHQData:(ChartHQDataModel *)model{
    [_fsConfig updateTopAndBottomTimeByHQData:model];
}
@end
