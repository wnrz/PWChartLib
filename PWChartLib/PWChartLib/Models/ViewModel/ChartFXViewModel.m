
//
//  ChartFXViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXViewModel.h"

@interface ChartFXViewModel () {
    NSMapTable *fxMapTable;
}

@end

@implementation ChartFXViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
        _fxDatas = [[NSMutableArray alloc] init];
        fxMapTable = [NSMapTable strongToWeakObjectsMapTable];
        _baseConfig.maxShowNum = 150;
        _baseConfig.minShowNum = 20;
        _baseConfig.currentShowNum = 55;
    }
    return self;
}

- (void)dealloc{
    [fxMapTable removeAllObjects];
    fxMapTable = nil;
    
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
    end =  end > _fxDatas.count ? _fxDatas.count - 1 : end;
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
        
        bottom = bottom ? bottom : top;
        bottom = [model.topPrice doubleValue] < bottom ? [model.topPrice doubleValue] : bottom;
        bottom = [model.openPrice doubleValue] < bottom ? [model.openPrice doubleValue] : bottom;
        bottom = [model.closePrice doubleValue] < bottom ? [model.closePrice doubleValue] : bottom;
        bottom = [model.bottomPrice doubleValue] < bottom ? [model.bottomPrice doubleValue] : bottom;
    }];
    _baseConfig.topPrice = top;
    _baseConfig.bottomPrice = bottom;
}

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas{
    if (_fxDatas.count == 0) {
        //        datas = [self sortByTimeStamp:datas];
        [self setPerModel:datas];
        _fxDatas = [NSMutableArray arrayWithArray:datas];
    }else{
        NSMutableArray *arr = [self filterByMapTable:datas];
        [self increaseNewDatas:arr];
        //        datas = [self sortByTimeStamp:datas];
        [self setPerModel:self.fxDatas];
    }
}

- (NSArray *)sortByTimeStamp:(NSArray *)datas{
    if (datas.count > 1) {
        datas = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    return datas;
}

- (void)setPerModel:(NSArray *)datas{
    __block ChartFXDataModel *tmp;
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartFXDataModel *model = obj;
        if (idx == 0) {
            tmp = model;
        }
        model.perFXModel = tmp;
        [self->fxMapTable setObject:model forKey:[model.timeStamp copy]];
    }];
}

- (NSMutableArray *)filterByMapTable:(NSArray *)datas{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datas];
    [datas enumerateObjectsUsingBlock:^(ChartFXDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartFXDataModel *model = obj;
        ChartFXDataModel *model2 = [self->fxMapTable objectForKey:model.timeStamp];
        if (model2) {
            NSInteger index = [self.fxDatas indexOfObject:model2];
            [self->fxMapTable setObject:model forKey:[model.timeStamp copy]];
            [self.fxDatas replaceObjectAtIndex:index withObject:model];
            [arr removeObject:model];
        }
    }];
    return arr;
}

- (void)increaseNewDatas:(NSArray *)datas{
    [_fxDatas addObjectsFromArray:datas];
}

- (void)setFXLinetype:(KLineType)FXLinetype{
    if (_FXLinetype != FXLinetype) {
        _FXLinetype = FXLinetype;
        [self.fxDatas removeAllObjects];
    }
}
@end
