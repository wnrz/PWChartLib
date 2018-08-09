//
//  ChartBaseLayer.h
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChartBaseViewModel.h"

@interface ChartBaseLayer : CAShapeLayer


@property(nonatomic , assign)UIColor *lineColor;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;

- (void)install;
- (void)startDraw;
- (void)clearLayers;
- (void)redraw:(void(^)(ChartBaseLayer *obj))block;
@end
