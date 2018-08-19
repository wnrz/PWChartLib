//
//  ChartZBViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartPureZBViewModel.h"
#import "PWFSZBParam.h"
#import "PWFXZBParam.h"
#import "ChartTools.h"

@implementation ChartPureZBViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
    }
    return self;
}

- (void)dealloc{
}
@end
