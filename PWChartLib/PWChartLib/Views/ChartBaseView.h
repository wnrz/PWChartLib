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

#import "ChartFormLayer.h"
#import "ChartCrossLineLayer.h"
#import "ChartDataLayer.h"
#import "ChartsLayer.h"

@interface ChartBaseView : UIView <UIGestureRecognizerDelegate>{
    UIPanGestureRecognizer *_panGes;
    UIPinchGestureRecognizer *_twoFingerPinch;
    UILongPressGestureRecognizer *_longGes;
    UITapGestureRecognizer *_tapGes;
}

@property (nonatomic , weak)ChartBaseView *ztView;
@property (nonatomic , strong)NSMutableArray *ftViews;

@property (nonatomic , strong)ChartBaseViewModel *baseConfig;

@property (nonatomic , strong)ChartsLayer *chartsLayer;
@property (nonatomic , strong)ChartFormLayer *formLayer;
@property (nonatomic , strong)ChartCrossLineLayer *crossLayer;
@property (nonatomic , strong)ChartDataLayer *dataLayer;

@property(nonatomic , assign)CGRect showFrame;

@property(nonatomic)BOOL enableTap; // 是否可以响应点击时间
@property(nonatomic)BOOL enableDrag; // 是否可以响应点击时间
@property(nonatomic)BOOL enableScale; // 是否可以响应点击时间

- (void)install;

- (void)startDraw;

- (void)setData:(id)data;

- (NSInteger)dataNumber;

- (void)panGesAction:(UIPanGestureRecognizer*)recognizer;
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;
- (void)longPressedGesAction:(UILongPressGestureRecognizer *)recognizer;
- (UIPanGestureRecognizer *)getPanGestureRecognizer;
- (BOOL)canUsePanGestureRecognizer;
@end
