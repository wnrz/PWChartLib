//
//  ChartFSViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFSViewModel.h"

@implementation ChartFSTimeModel

@end

@interface ChartFSViewModel () {
    NSMapTable *fsMapTable;
}

@end

@implementation ChartFSViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
        _fsDatas = [[NSMutableArray alloc] init];
        fsMapTable = [NSMapTable strongToWeakObjectsMapTable];
        _isShowShadow = YES;
        _baseConfig.showBottomType = BottomDataType_Time;
    }
    return self;
}

- (void)dealloc{
    [fsMapTable removeAllObjects];
    fsMapTable = nil;
    
    [_fsDatas removeAllObjects];
    _fsDatas = nil;
    
    _baseConfig = nil;
    
    _times = nil;
    
//    _leftRightDataKey = nil;
}

- (void)checkTopAndBottomPrice{
    if (!_baseConfig.independentTopBottomPrice) {
        CGFloat mid = [_baseConfig.hqData.closePrice doubleValue] != 0 ? [_baseConfig.hqData.closePrice doubleValue] : (_baseConfig.topPrice - _baseConfig.bottomPrice) / 2 + _baseConfig.bottomPrice;
        NSDictionary * dict = [self checkTopAndBottomPrice:@[@"nowPrice",@"avgPrice"]];
        if (_baseConfig.topPrice == _baseConfig.bottomPrice && _baseConfig.topPrice == 0) {
            _baseConfig.topPrice = [dict[@"top"] doubleValue];
            _baseConfig.bottomPrice = [dict[@"bottom"] doubleValue];
        }else{
            if (!([dict[@"top"] doubleValue] == [dict[@"bottom"] doubleValue] && [dict[@"top"] doubleValue] == 0)) {
                _baseConfig.topPrice = _baseConfig.topPrice < [dict[@"top"] doubleValue] ? [dict[@"top"] doubleValue] : _baseConfig.topPrice;
                _baseConfig.bottomPrice = _baseConfig.bottomPrice > [dict[@"bottom"] doubleValue] ? [dict[@"bottom"] doubleValue] : _baseConfig.bottomPrice;
            }
        }
        if (!(_baseConfig.topPrice == _baseConfig.bottomPrice && _baseConfig.topPrice == 0)) {
            if (_baseConfig.hqData.closePrice != 0) {
                CGFloat p = fabs(_baseConfig.topPrice - mid);
                p = p > fabs(_baseConfig.bottomPrice - mid) ? p : fabs(_baseConfig.bottomPrice - mid);
                _baseConfig.topPrice = mid + p;
                _baseConfig.bottomPrice = mid - p;
            }
        }
    }
}

- (NSDictionary *)checkTopAndBottomPrice:(NSArray *)keys{
    if (_fsDatas.count == 0) {
        return @{@"top":@(0),@"bottom":@(0)};
    }
    NSInteger start = _baseConfig.currentIndex;
    NSInteger length = _baseConfig.currentShowNum;
    start = start < 0 ? 0 : start;
    length =  length > (_fsDatas.count -  _baseConfig.currentIndex) ? _fsDatas.count -  _baseConfig.currentIndex : length;
    length = length < 0 ? 0 : length;
    CGFloat top;// = _baseConfig.topPrice;
    CGFloat bottom;// = _baseConfig.bottomPrice;
    NSArray *arr = [_fsDatas subarrayWithRange:NSMakeRange(start, length)];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string1 = [NSString stringWithFormat:@"@max.%@.doubleValue" , obj];
        NSString *string2 = [NSString stringWithFormat:@"@min.%@.doubleValue" , obj];
        NSString *obj1 = [arr valueForKeyPath:string1];
        NSString *obj2 = [arr valueForKeyPath:string2];
        if ([obj1 floatValue] != 0) {
            [array addObject:obj1];
        }
        if ([obj2 floatValue] != 0) {
            [array addObject:obj2];
        }
        
        if (self.baseConfig.independentTopBottomPrice) {
            if ([obj1 floatValue] != 0) {
                [self.baseConfig.topPrices setObject:obj1 forKey:obj];
            }
            if ([obj2 floatValue] != 0) {
                [self.baseConfig.bottomPrices setObject:obj2 forKey:obj];
            }
        }
    }];
    top = [[array valueForKeyPath:@"@max.self"] doubleValue];
    bottom = [[array valueForKeyPath:@"@min.self"] doubleValue];
    if (top == bottom && top != 0) {
        top = top + fabs(top) * 0.01;
        bottom = bottom - fabs(bottom) * 0.01;
    }
    return @{@"top":@(top),@"bottom":@(bottom)};
}

- (void)saveDatas:(NSArray<ChartFSDataModel *> *)datas{
    if (_fsDatas.count == 0) {
//        datas = [self sortByTimeStamp:datas];
        [self setPerModel:datas];
        _fsDatas = [NSMutableArray arrayWithArray:datas];
        self.baseConfig.showIndex = _fsDatas.count - 1;
    }else{
        NSMutableArray *arr = [self filterByMapTable:datas];
        [self increaseNewDatas:arr];
//        datas = [self sortByTimeStamp:datas];
        [self setPerModel:self.fsDatas];
    }
}

- (NSArray *)sortByTimeStamp:(NSArray *)datas{
    if (datas.count > 1) {
        datas = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ChartFSDataModel *model1 = obj1;
            ChartFSDataModel *model2 = obj2;
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
    __block ChartFSDataModel *tmp;
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartFSDataModel *model = obj;
        if (idx == 0) {
            tmp = model;
        }
        model.perFSModel = tmp;
        tmp = model;
        [self->fsMapTable setObject:model forKey:[model.timeStamp copy]];
    }];
}

- (NSMutableArray *)filterByMapTable:(NSArray *)datas{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:datas];
    [datas enumerateObjectsUsingBlock:^(ChartFSDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartFSDataModel *model = obj;
        ChartFSDataModel *model2 = [self->fsMapTable objectForKey:model.timeStamp];
        if (model2) {
            NSInteger index = [self.fsDatas indexOfObject:model2];
            [self->fsMapTable setObject:model forKey:[model.timeStamp copy]];
            [self.fsDatas replaceObjectAtIndex:index withObject:model];
            [arr removeObject:model];
        }
    }];
    return arr;
}

- (void)increaseNewDatas:(NSArray *)datas{
    [_fsDatas addObjectsFromArray:datas];
}

- (void)updateTopAndBottomTimeByHQData:(ChartHQDataModel *)model{
    if (model.closePrice.doubleValue != 0 && model.topPrice.doubleValue != 0 && model.bottomPrice.doubleValue != 0) {
        _baseConfig.hqData = model;
        CGFloat tmp = MAX(fabs(model.topPrice.doubleValue - model.closePrice.doubleValue), fabs(model.bottomPrice.doubleValue - model.closePrice.doubleValue));
        CGFloat top = model.closePrice.doubleValue + tmp;
        CGFloat bottom = model.closePrice.doubleValue - tmp;
        if ((_baseConfig.topPrice == 0 && _baseConfig.bottomPrice == 0) || (_baseConfig.topPrice < top || _baseConfig.bottomPrice > bottom)) {
            _baseConfig.topPrice = top;
            _baseConfig.bottomPrice = bottom;
        }
    }
}

- (void)setTimes:(NSArray<ChartFSTimeModel *> *)times{
    _times = times;
    __block CGFloat count = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [times enumerateObjectsUsingBlock:^(ChartFSTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count = count + obj.end - obj.start;
        [arr addObject:@(obj.end - obj.start)];
    }];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    __block NSInteger count2 = 0;
    [arr2 addObject:@(count2)];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger time = [obj integerValue];
        count2 = count2 + time;
        [arr2 addObject:@(count2 / count)];
    }];
    _baseConfig.maxPointCount = count;
    _baseConfig.horizontalSeparateArr = arr2;
}
@end
