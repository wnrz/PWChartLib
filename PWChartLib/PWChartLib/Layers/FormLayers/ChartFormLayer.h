//
//  ChartFormLayer.h
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChartBaseLayer.h"

@interface ChartFormLayer : ChartBaseLayer

@property(nonatomic , strong)NSArray *verticalSeparateArr; //有多少个 横向 分割线 实线 最小0 最大1
@property(nonatomic , strong)NSArray *horizontalSeparateArr;  //有多少个 纵向 分割线  实线 最小0 最大1
@property(nonatomic , strong)NSArray *verticalSeparateDottedArr; //有多少个 横向 分割线 虚线 最小0 最大1
@property(nonatomic , strong)NSArray *horizontalSeparateDottedArr;  //有多少个 纵向 分割线 虚线 最小0 最大1


- (void)drawForm;
@end
