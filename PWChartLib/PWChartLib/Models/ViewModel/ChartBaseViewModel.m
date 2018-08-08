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
        _hqData = [[ChartHQDataModel alloc] init];
    }
    return self;
}

- (void)dealloc{
    [self removeAllBridge];
    
    _hqData = nil;
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
