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
#import "ChartZBDataModel.h"

typedef NS_ENUM(NSInteger , KLineType){
    KLineType_1Min = 0,
    KLineType_5Min,
    KLineType_30Min,
    KLineType_60Min,
    KLineType_DAY,
    KLineType_WEEK,
    KLineType_MONTH,
};

typedef enum{
    FXZTZBNone = 0,
    FXZTZBMA,
    FXZTZBTSZF,
} DrawFXZTZBType;  //k线主图

@interface ChartFXViewModel : NSObject

@property (nonatomic , strong)NSMutableArray<ChartFXDataModel *> *fxDatas;
@property (nonatomic , weak)ChartBaseViewModel *baseConfig;
//k线属性
@property (nonatomic , assign)KLineType fxLinetype; // k线周期主图类型


@property (nonatomic , strong)ChartZBDataModel *zbDatas;
@property (nonatomic , strong)NSString *ztZBName;
@property (nonatomic , assign)DrawFXZTZBType ztZBType; // k线主图类型


- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig;
- (void)chackTopAndBottomPrice;
- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas;
- (void)getZBData;
@end
