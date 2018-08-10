//
//  FSDataBridge.h
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/10.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "PWBaseDataBridge.h"
#import "ChartFSView.h"

@interface FSDataBridge : PWBaseDataBridge

@property (nonatomic , weak)ChartFSView *fsView;
@property (nonatomic , strong)NSString *codeId;
@property (nonatomic , strong)NSString *marketCode;


- (void)loadFS;
- (void)loadTime;
@end
