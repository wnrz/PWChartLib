
//
//  ChartFXViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXViewModel.h"

@implementation ChartFXViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
        _fxDatas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_fxDatas removeAllObjects];
    _fxDatas = nil;
}

- (void)chackTopAndBottomPrice{
    if (_fxDatas.count == 0) {
        return;
    }
    NSInteger start = _baseConfig.currentIndex;
    NSInteger end = _baseConfig.currentIndex + _baseConfig.currentShowNum;
    start = start < 0 ? 0 : start;
    end =  end > _fxDatas.count ? _fxDatas.count - 1 : 0;
    if (end < start) {
        return;
    }
    __block CGFloat top = _baseConfig.topPrice;
    __block CGFloat bottom = _baseConfig.bottomPrice;
    NSArray *arr = [_fxDatas subarrayWithRange:NSMakeRange(start, end - start)];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartFXDataModel *model = obj;
        top = [model.topPrice doubleValue] > top ? [model.topPrice doubleValue] : top;
        top = [model.openPrice doubleValue] > top ? [model.openPrice doubleValue] : top;
        top = [model.closePrice doubleValue] > top ? [model.closePrice doubleValue] : top;
        top = [model.bottomPrice doubleValue] > top ? [model.bottomPrice doubleValue] : top;
        
        bottom = [model.topPrice doubleValue] < bottom ? [model.topPrice doubleValue] : bottom;
        bottom = [model.openPrice doubleValue] < bottom ? [model.openPrice doubleValue] : bottom;
        bottom = [model.closePrice doubleValue] < bottom ? [model.closePrice doubleValue] : bottom;
        bottom = [model.bottomPrice doubleValue] < bottom ? [model.bottomPrice doubleValue] : bottom;
    }];
    _baseConfig.topPrice = top;
    _baseConfig.bottomPrice = bottom;
}

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas{
    
}
@end
