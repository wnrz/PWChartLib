
//
//  ChartFXViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXViewModel.h"
#import "FXZBParam.h"
#import "ChartTools.h"

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
        _zbDatas = [[ChartZBDataModel alloc] init];
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
    if (_baseConfig.topPrice != top && _baseConfig.bottomPrice != bottom) {
        CGFloat mid = top - bottom;
        mid = mid * (5 / self.baseConfig.showFrame.size.height);
        _baseConfig.topPrice = top + mid;
        _baseConfig.bottomPrice = bottom - mid;
    }
    [self.zbDatas chackTopAndBottomPrice:_baseConfig];
}

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas{
    NSInteger index = _baseConfig.currentIndex;
    BOOL needUpdate = NO;
    if (_baseConfig.currentIndex + _baseConfig.currentShowNum >= _fxDatas.count ) {
        needUpdate = YES;
    }
    if (_fxDatas.count == 0) {
        datas = [self sortByTimeStamp:datas];
        [self setPerModel:datas];
        _fxDatas = [NSMutableArray arrayWithArray:datas];
    }else{
        NSMutableArray *arr = [self filterByMapTable:datas];
        [self increaseNewDatas:arr];
        datas = [self sortByTimeStamp:datas];
        [self setPerModel:self.fxDatas];
    }
    if (needUpdate) {
        index = _fxDatas.count - _baseConfig.currentShowNum;
        _baseConfig.currentIndex = index < 0 ? 0 : index;
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
        tmp = model;
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

- (void)setfxLinetype:(KLineType)fxLinetype{
    if (_fxLinetype != fxLinetype) {
        _fxLinetype = fxLinetype;
        [self.fxDatas removeAllObjects];
    }
}

- (void)setZtZBName:(NSString *)ztZBName{
    _ztZBName = ztZBName;
    [ztZBName isEqualToString:@"MA"] ? self.ztZBType = FXZTZBMA : 0;
    [ztZBName isEqualToString:@"特色"] ? self.ztZBType = FXZTZBTSZF : 0;
}

- (void)getZBData{
    NSMutableDictionary *dict;
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.fxDatas];
    (self.ztZBType == FXZTZBMA) ? dict = [[FXZBParam shareFXZBParam] getPriMAResult:array] : 0;
    (self.ztZBType == FXZTZBTSZF) ? dict = [[FXZBParam shareFXZBParam] getTSZF0Result:array] : 0;
    self.zbDatas.datas = dict;
}
@end
