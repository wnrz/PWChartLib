//
//  ChartFXView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartFXView.h"
#import "ChartZBView.h"

@interface ChartFXView () {
    BOOL mergePan;
}

@end

@implementation ChartFXView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
    [_fxDataLayer removeFromSuperlayer];
    _fxDataLayer = nil;
}

- (void)install{
    [super install];
    self.ztView = self;
    _fxConfig = [[ChartFXViewModel alloc] initWithBaseConfig:self.baseConfig];
    
    _fxDataLayer = [[ChartFXDataLayer alloc] init];
    _fxDataLayer.baseConfig = self.baseConfig;
    _fxDataLayer.fxConfig = self.fxConfig;
    [self.layer insertSublayer:_fxDataLayer above:self.dataLayer];
    
    _zbChartsLayer = [[ZBChartsLayer alloc] init];
    _zbChartsLayer.baseConfig = self.baseConfig;
    _zbChartsLayer.fxConfig = _fxConfig;
    [self.layer insertSublayer:_zbChartsLayer above:self.chartsLayer];
}

- (NSInteger)dataNumber{
    return _fxConfig.fxDatas.count;
}

- (void)startDraw{
    self.baseConfig.topPrice = 0;
    self.baseConfig.bottomPrice = 0;
    [_fxConfig chackTopAndBottomPrice];
    
    if (!self.baseConfig.hqData) {
        return;
    }
    [self.formLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.chartsLayer drawKLine:_fxConfig];
    
    [_zbChartsLayer drawZB];
    
    [self.crossLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.dataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartDataLayer *)obj setIsDrawLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawRightText:NO];
        [(ChartDataLayer *)obj setIsDrawCrossLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawCrossRightText:NO];
    }];
    
    [_fxDataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartFXDataLayer *)obj setIsDrawBottomText:YES];
        [(ChartFXDataLayer *)obj setIsDrawCrossBottomText:YES];
    }];
}

- (void)saveDatas:(NSArray<ChartFXDataModel *> *)datas{
    if (datas.count == 0) {
        return;
    }
    [_fxConfig saveDatas:datas];
    NSArray *arr = [NSArray arrayWithArray:self.ftViews];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartZBView *zbView = obj;
        [zbView.config getZBData];
        [zbView startDraw];
    }];
    [self.fxConfig getZBData];
    [self startDraw];
}

- (void)showZB:(NSString *)zbName{
    self.fxConfig.ztZBName = zbName;
    [self startDraw];
}

- (void)longPressedGesAction:(UILongPressGestureRecognizer *)recognizer{
    if (mergePan) {
        return;
    }
    [super longPressedGesAction:recognizer];
}

- (BOOL)canUsePanGestureRecognizer{
    @synchronized(self){
        if (!_twoFingerPinch) {
            return YES;
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        _panGes.state != UIGestureRecognizerStatePossible ? [arr addObject:_panGes] : 0;
        for (int i = 0 ; i < self.ftViews.count ; i++) {
            ChartBaseView *view = self.ftViews[i];
            UIPanGestureRecognizer *pan = [view getPanGestureRecognizer];
            pan.state != UIGestureRecognizerStatePossible ? [arr addObject:pan] : 0;
            if (arr.count == 2) {
                break;
            }
        }
        if (arr.count == 2) {
            mergePan = YES;
            UIPanGestureRecognizer *recognizer1 = arr[0];
            UIPanGestureRecognizer *recognizer2 = arr[1];
            CGPoint localPoint1 = [recognizer1 locationInView:self];
            CGPoint localPoint2 = [recognizer2 locationInView:self];
            CGPoint translatedPoint1 = [recognizer1 translationInView:self];
            CGPoint translatedPoint2 = [recognizer2 translationInView:self];
            float length1 = sqrtf(powf(localPoint1.x - localPoint2.x, 2) + powf(localPoint1.y - localPoint2.y, 2));
            float length2 = sqrtf(powf(localPoint1.x - translatedPoint1.x - localPoint2.x + translatedPoint2.x, 2) + powf(localPoint1.y - translatedPoint1.y - localPoint2.y + translatedPoint2.y, 2));
            _twoFingerPinch.scale = _twoFingerPinch.scale * length1 / length2;
            [_twoFingerPinch setValue:@(UIGestureRecognizerStateChanged) forKeyPath:@"state"];
            [self twoFingerPinch:_twoFingerPinch];
            [recognizer1 setTranslation:CGPointZero inView:self];
            [recognizer2 setTranslation:CGPointZero inView:self];
            [arr removeAllObjects];
            return NO;
        }
        if (mergePan) {
            if (arr.count == 1){
                UIPanGestureRecognizer *pan = [arr firstObject];
                if (pan.state == UIGestureRecognizerStateEnded) {
                    mergePan = NO;
                    _twoFingerPinch.scale = 1;
                    [_twoFingerPinch setValue:@(UIGestureRecognizerStateEnded) forKeyPath:@"state"];
                    [self twoFingerPinch:_twoFingerPinch];
                    [_twoFingerPinch setValue:@(UIGestureRecognizerStatePossible) forKeyPath:@"state"];
                }
                [arr removeAllObjects];
                return NO;
            }
        }
        return YES;
    }
}
@end
