//
//  ChartZBViewModel.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartZBDataModel.h"
#import "ChartBaseViewModel.h"

@interface ChartZBViewModel : NSObject

@property (nonatomic , strong)ChartZBDataModel *zbDatas;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;
@end
