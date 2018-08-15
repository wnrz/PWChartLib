//
//  ChartFXView.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseView.h"
#import "ChartFXViewModel.h"
#import "ChartFXDataLayer.h"
#import "ZBChartsLayer.h"

@interface ChartFXView : ChartBaseView

@property (nonatomic , strong)ChartFXDataLayer *fxDataLayer;
@property (nonatomic , strong)ZBChartsLayer *zbChartsLayer;
@property (nonatomic , strong)ChartFXViewModel *fxConfig;

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas;

- (void)showZB:(NSString *)zbName;
- (void)changeZQ:(NSInteger)fxLinetype;
@end
