//
//  ChartZBViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartZBViewModel.h"

@implementation ChartZBViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
    }
    return nil;
}

- (void)dealloc{
    _zbDatas = nil;
}
@end
