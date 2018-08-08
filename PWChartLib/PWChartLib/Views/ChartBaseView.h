//
//  ChartBaseView.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartHQDataModel.h"
#import "ChartBaseViewModel.h"

#import "ChartBaseFormLayer.h"

@interface ChartBaseView : UIView

@property (nonatomic , weak)ChartBaseView *ztView;
@property (nonatomic , strong)NSMutableArray *zbViews;

@property (nonatomic , strong)ChartHQDataModel *hqData;
@property (nonatomic , strong)ChartBaseViewModel *baseConfig;

@property (nonatomic , strong)NSMutableArray *layers;
@property (nonatomic , strong)ChartBaseFormLayer *formLayer;
@property (nonatomic , strong)CAShapeLayer *crossLayer;

@end
