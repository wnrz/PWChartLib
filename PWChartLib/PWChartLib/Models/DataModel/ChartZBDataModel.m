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
- (void)checkTopAndBottomPrice:(ChartBaseViewModel *)baseConfig{
    NSArray *arr = [NSArray arrayWithArray:_zbDatas];
    __block CGFloat top = 0;
    __block CGFloat bottom = 0;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger start = baseConfig.currentIndex;
        NSInteger length = baseConfig.currentShowNum;
        start = start < 0 ? 0 : start;
        length =  length > self->_numCount - start - 1 ? self->_numCount - start - 1 : length;
        if (length < 0) {
            return;
        }
        NSDictionary *d = obj;
        NSArray *array = d[@"linesArray"];
        NSInteger after = [d[@"start"] integerValue];
        NSInteger num = self.numCount - array.count;
        if (length + start > array.count) {
            length = array.count - start;
        }
        NSArray *a = [array subarrayWithRange:NSMakeRange(start - num > 0 ? start - num : 0, length)];
        [a enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (after <= idx2 + start) {
                CGFloat value = [obj doubleValue];
                if (top == 0 && bottom == 0) {
                    top = value;
                    bottom = value;
                }else {
                    if (!isnan(value) && !isinf(value)) {
                        top = top > value ? top : value;
                        bottom = bottom < value ? bottom : value;
                    }
                }
            }
        }];
    }];
    if (top == bottom && top != 0) {
        top = top * 1.01;
        bottom = bottom * 0.99;
    }
    if (baseConfig.topPrice == 0 && baseConfig.bottomPrice == 0) {
        baseConfig.topPrice = top;
        baseConfig.bottomPrice = bottom;
    }else{
        if (top != 0 || bottom != 0) {
            baseConfig.topPrice = baseConfig.topPrice > top ? baseConfig.topPrice : top;
            baseConfig.bottomPrice = baseConfig.bottomPrice < bottom ? baseConfig.bottomPrice : bottom;
        }
    }
}
@end
