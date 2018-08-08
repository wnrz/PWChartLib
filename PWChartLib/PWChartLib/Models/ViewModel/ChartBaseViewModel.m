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
@end
