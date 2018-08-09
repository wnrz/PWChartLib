//
//  ChartDataLayer.h
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChartBaseLayer.h"

@interface ChartDataLayer : ChartBaseLayer

@property (nonatomic , assign) BOOL isDrawLeftText;
@property (nonatomic , assign) BOOL isDrawRightText;

@property (nonatomic , assign) BOOL isDrawDateText;

@property (nonatomic , assign) BOOL isDrawCrossLeftText;
@property (nonatomic , assign) BOOL isDrawCrossRightText;
@end
