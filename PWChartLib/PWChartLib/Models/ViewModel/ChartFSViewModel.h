//
//  ChartFSViewModel.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartFSDataModel.h"
#import "ChartBaseViewModel.h"

@interface ChartFSTimeModel : NSObject
@property (nonatomic , assign)NSInteger start;
@property (nonatomic , assign)NSInteger end;
@end

@interface ChartFSViewModel : NSObject

@property (nonatomic , strong)NSMutableArray<ChartFSDataModel *> *fsDatas;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;
@property (nonatomic , strong)NSArray<ChartFSTimeModel *> *times;
@property (nonatomic , assign)BOOL isShowMA;

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;
- (void)saveDatas:(NSArray<ChartFSDataModel *> *)datas;
- (void)updateTopAndBottomTimeByHQData:(ChartHQDataModel *)model;
@end
