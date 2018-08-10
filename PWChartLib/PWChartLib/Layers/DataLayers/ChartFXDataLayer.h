//
//  ChartDataLayer.h
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChartBaseLayer.h"
#import "ChartFXViewModel.h"

@interface ChartFXDataLayer : ChartBaseLayer

@property (nonatomic , weak)ChartFXViewModel *fxConfig;
@property (nonatomic , assign) BOOL isDrawBottomText;
@property (nonatomic , assign) BOOL isDrawCrossBottomText;
@end
