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

typedef enum{
    FTZBNone = 0,
    
    //分时幅图指标类型
    FTZBFSVOL,
    FTZBFSMACD,
    FTZBFSKDJ,
    
    //k线幅图指标类型
    FTZBFXARBR,
    FTZBFXATR,
    FTZBFXBIAS,
    FTZBFXCCI,
    FTZBFXDKBY,
    FTZBFXKD,
    FTZBFXKDJ,
    FTZBFXLWR,
    FTZBFXMACD,
    FTZBFXQHLSR,
    FTZBFXRSI,
    FTZBFXWR,
    FTZBFXVOL,
    FTZBFXOBV,
    FTZBFXASI,
    FTZBFXROC,
    FTZBFXPSY,
    FTZBFXTSZF0
} DrawFTZBType;  //幅图指标类型

@interface ChartZBViewModel : NSObject

@property (nonatomic , strong)ChartZBDataModel *zbDatas;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;
@property (nonatomic , weak)ChartFSViewModel *fsConfig;
@property (nonatomic , weak)ChartFXViewModel *fxConfig;

@property (nonatomic , strong)NSString *ftZBName;
@property (nonatomic , assign)DrawFTZBType zbType;

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;
@end
