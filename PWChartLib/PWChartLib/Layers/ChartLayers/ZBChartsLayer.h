//
//  ZBChartsLayer.h
//  AFNetworking
//
//  Created by 王宁 on 2018/8/13.
//

#import "ChartBaseLayer.h"
#import "ChartZBViewModel.h"
#import "ChartFXViewModel.h"

@interface ZBChartsLayer : ChartBaseLayer

@property (nonatomic , weak)ChartFXViewModel *fxConfig;
@property (nonatomic , weak)ChartZBViewModel *zbConfig;
- (void)drawZB;
@end
