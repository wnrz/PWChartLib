//
//  ChartBaseViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseViewModel.h"

@implementation ChartBaseViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self install];
    }
    return self;
}

- (void)dealloc{
    [self removeAllBridge];
    _hqData = nil;
    _verticalSeparateArr = nil;
    _horizontalSeparateArr = nil;
    _verticalSeparateDottedArr = nil;
    _horizontalSeparateDottedArr = nil;
}

- (void)setMaxPointCount:(NSInteger)maxPointCount{
    _maxPointCount = maxPointCount;
    _maxShowNum = maxPointCount;
    _maxShowNum = maxPointCount;
    _currentIndex = 0;
    _currentShowNum = maxPointCount;
}

- (void)install{
    _verticalSeparateArr = @[@(0),@(1)];
    _horizontalSeparateArr = @[@(0),@(1)];
    _verticalSeparateDottedArr = @[@.25,@.5,@.75];
    
    _hqData = [[ChartHQDataModel alloc] init];
//
//    _hqData.digit = 2;
//
//    self.topPrice = 1;
//    self.bottomPrice = 0;
}

- (void)SyncParameter:(ChartBaseViewModel *)con{
    self.showIndex = con.showIndex;
    self.showCrossLine = con.showCrossLine;
    self.maxPointCount = con.maxPointCount;
    self.maxShowNum = con.maxShowNum;
    self.minShowNum = con.minShowNum;
    self.currentIndex = con.currentIndex;
    self.currentShowNum = con.currentShowNum;
}
@end
