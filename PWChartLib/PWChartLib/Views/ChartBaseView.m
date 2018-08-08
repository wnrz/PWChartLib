//
//  ChartBaseView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseView.h"

@implementation ChartBaseView

- (instancetype)init{
    self = [super init];
    if (self) {
        _zbViews = [[NSMutableArray alloc] init];
        _hqData = [[ChartHQDataModel alloc] init];
        _baseConfig = [[ChartBaseViewModel alloc] init];
        _layers = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
    
}


@end
