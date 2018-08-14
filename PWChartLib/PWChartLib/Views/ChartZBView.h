//
//  ChartZBView.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseView.h"
#import "ChartZBViewModel.h"
#import "ZBChartsLayer.h"

@interface ChartZBView : ChartBaseView

@property (nonatomic , strong)ZBChartsLayer *zbChartsLayer;
@property (nonatomic , strong)ChartZBViewModel *config;

- (void)showZB:(NSString *)zbName;
@end
