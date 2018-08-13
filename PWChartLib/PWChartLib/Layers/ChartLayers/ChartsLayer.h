//
//  ChartsLayer.h
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "ChartBaseLayer.h"
#import "ChartFSViewModel.h"
#import "ChartFXViewModel.h"

@interface ChartsLayer : ChartBaseLayer

@property (nonatomic , weak)ChartFSViewModel *fsConfig;
@property (nonatomic , weak)ChartFXViewModel *fxConfig;

- (void)drawKLine:(ChartFXViewModel *)fxConfig;

- (void)drawFSLine:(ChartFSViewModel *)fsConfig;
- (void)drawVOL:(id)ztConfig;

@end
