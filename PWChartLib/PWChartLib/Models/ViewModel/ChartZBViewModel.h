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
    PWFTZBNone = 0,
    
    //分时幅图指标类型
    PWFTZBFSVOL,
    PWFTZBFSMACD,
    PWFTZBFSKDJ,
    
    //k线幅图指标类型
    PWFTZBFXARBR,
    PWFTZBFXATR,
    PWFTZBFXBIAS,
    PWFTZBFXCCI,
    PWFTZBFXDKBY,
    PWFTZBFXKD,
    PWFTZBFXKDJ,
    PWFTZBFXLWR,
    PWFTZBFXMACD,
    PWFTZBFXQHLSR,
    PWFTZBFXRSI,
    PWFTZBFXWR,
    PWFTZBFXVOL,
    PWFTZBFXOBV,
    PWFTZBFXASI,
    PWFTZBFXROC,
    PWFTZBFXPSY,
    PWFTZBFXTSZF0,
    PWFTZBFXDKNLX,
    PWFTZBFXBOLL
} PWDrawFTZBType;  //幅图指标类型

@interface ChartZBViewModel : NSObject

@property (nonatomic , strong)ChartZBDataModel *zbDatas;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;
@property (nonatomic , weak)ChartFSViewModel *fsConfig;
@property (nonatomic , weak)ChartFXViewModel *fxConfig;

@property (nonatomic , strong)NSString *ftZBName;
@property (nonatomic , assign)PWDrawFTZBType zbType;

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;

- (void)getZBData;
- (void)checkTopAndBottomPrice;
@end
