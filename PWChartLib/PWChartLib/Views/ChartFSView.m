//
//  ChartFSView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFSView.h"

@implementation ChartFSView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)install{
    [super install];
    self.ztView = self;
}

- (void)initFormLayer{
    
}

- (NSInteger)dataNumber{
    return _fsConfig.fsDatas.count;
}
@end
