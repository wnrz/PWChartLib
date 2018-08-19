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
#import "ChartFSViewModel.h"
#import "ChartFXViewModel.h"

@interface ChartPureZBViewModel : NSObject

@property (nonatomic , weak)ChartBaseViewModel *baseConfig;
- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;

@end
