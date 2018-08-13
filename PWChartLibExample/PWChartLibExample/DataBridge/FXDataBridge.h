//
//  FXDataBridge.h
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/10.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "PWBaseDataBridge.h"
#import "ChartFXView.h"

@interface FXDataBridge : PWBaseDataBridge

@property (nonatomic , weak)ChartFXView *fxView;
@property (nonatomic , strong)NSString *codeId;

- (void)loadFX:(int)type;
@end
