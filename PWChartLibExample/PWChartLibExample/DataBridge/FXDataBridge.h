//
//  FXDataBridge.h
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/10.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "PWBaseDataBridge.h"
#import "ChartFXView.h"

typedef NS_ENUM(NSInteger , KLineType){
    KLineType_1Min = 0,
    KLineType_5Min,
    KLineType_30Min,
    KLineType_60Min,
    KLineType_DAY,
    KLineType_WEEK,
    KLineType_MONTH,
};

@interface FXDataBridge : PWBaseDataBridge

@property (nonatomic , weak)ChartFXView *fxView;
@property (nonatomic , strong)NSString *codeId;

- (void)loadFX:(int)type;
@end
