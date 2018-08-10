//
//  ChartFXViewModel.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartFXDataModel.h"
#import "ChartBaseViewModel.h"

@interface ChartFXViewModel : NSObject

@property (nonatomic , strong)NSMutableArray<ChartFXDataModel *> *fxDatas;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;
- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas;
@end
