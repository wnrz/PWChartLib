//
//  ChartFSView.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseView.h"
#import "ChartFSViewModel.h"
#import "ChartFSDataLayer.h"

@interface ChartFSView : ChartBaseView

@property (nonatomic , strong)ChartFSDataLayer *fsDataLayer;
@property (nonatomic , strong)ChartFSViewModel *fsConfig;

- (void)saveDatas:(NSArray<ChartFSDataModel *> *)datas;
- (void)setTimes:(NSArray<ChartFSTimeModel *> *)times;
- (void)updateTopAndBottomTimeByHQData:(ChartHQDataModel *)model;
@end
