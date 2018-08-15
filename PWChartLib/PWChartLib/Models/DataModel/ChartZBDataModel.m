//
//  ZBDataModel.m
//  AFNetworking
//
//  Created by 王宁 on 2018/7/12.
//

#import "ChartZBDataModel.h"

@implementation ChartZBDataModel

- (void)setDatas:(NSMutableDictionary *)datas{
    _datas = datas;
    if ([datas count] > 0) {
        _zbName = datas[@"sName"];
        _numCount = [datas[@"nCount"] integerValue];
        _zbDatas = datas[@"linesArray"];
    }else{
        _zbName = @"";
        _numCount = 0;
        _zbDatas = nil;
    }
}
- (void)chackTopAndBottomPrice:(ChartBaseViewModel *)baseConfig{
    NSInteger start = baseConfig.currentIndex;
    NSInteger end = baseConfig.currentShowNum;
    start = start < 0 ? 0 : start;
    end =  end > _numCount - start - 1 ? _numCount - start - 1 : end;
    if (end < 0) {
        return;
    }
    NSArray *arr = [NSArray arrayWithArray:_zbDatas];
    __block CGFloat top = baseConfig.topPrice;
    __block CGFloat bottom = baseConfig.bottomPrice;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *d = obj;
        NSArray *array = d[@"linesArray"];
        NSInteger after = [d[@"start"] integerValue];
        NSArray *a = [array subarrayWithRange:NSMakeRange(start, end - after > 0 ? end - after : 0)];
        [a enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (after <= idx2 + start) {
                CGFloat value = [obj doubleValue];
                if (!isnan(value) && !isinf(value)) {
                    top = top > value ? top : value;
                    bottom = bottom < value ? bottom : value;
                }
            }
        }];
    }];
    baseConfig.topPrice = top;
    baseConfig.bottomPrice = bottom;
}
@end
