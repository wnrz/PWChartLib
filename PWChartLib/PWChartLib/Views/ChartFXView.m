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
    
    self.baseConfig.isDrawLeftText = YES;
    self.baseConfig.isDrawRightText = NO;
    self.baseConfig.isDrawCrossLeftText = YES;
    self.baseConfig.isDrawCrossRightText = NO;
}

- (NSInteger)dataNumber{
    return _fxConfig.fxDatas.count;
}

- (void)startDraw{
    self.showFrame = CGRectMake(0 + self.baseConfig.offsetLeft, 0 + self.baseConfig.offsetTop, self.frame.size.width - self.baseConfig.offsetLeft - self.baseConfig.offsetRight, self.frame.size.height - self.baseConfig.offsetTop - self.baseConfig.offsetBottom);
    self.baseConfig.topPrice = 0;
    self.baseConfig.bottomPrice = 0;
    [_fxConfig checkTopAndBottomPrice];
    
    if (!self.baseConfig.hqData) {
        return;
    }
    [self.formLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    if (self.fxConfig.drawKline) {
        [self.chartsLayer drawKLine:_fxConfig];
    }
    
    [_zbChartsLayer drawZB];
    
    [self.crossLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.dataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartDataLayer *)obj setIsDrawLeftText:self.baseConfig.isDrawLeftText];
        [(ChartDataLayer *)obj setIsDrawRightText:self.baseConfig.isDrawRightText];
        [(ChartDataLayer *)obj setIsDrawCrossLeftText:self.baseConfig.isDrawCrossLeftText];
        [(ChartDataLayer *)obj setIsDrawCrossRightText:self.baseConfig.isDrawCrossRightText];
        [(ChartDataLayer *)obj setIsLeftRiseFallColor:self.baseConfig.isLeftRiseFallColor];
        [(ChartDataLayer *)obj setIsRightRiseFallColor:self.baseConfig.isRightRiseFallColor];
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
        [zbView.baseConfig SyncParameter:self.baseConfig];
        [zbView startDraw];
    }];
    [self.fxConfig getZBData];
    [self startDraw];
}

- (void)clearData{
    _fxConfig.baseConfig.currentIndex = 0;
    [_fxConfig.fxDatas removeAllObjects];
    [_zbChartsLayer clearLayers];
    [self startDraw];
}

- (void)changeZB:(NSString *)zbName{
    self.fxConfig.ztZBName = zbName;
    [self.fxConfig getZBData];
    [self startDraw];
}

- (void)changeZQ:(NSInteger)fxLinetype{
    if (self.fxConfig.fxLinetype != fxLinetype) {
        [self clearData];
        NSArray *arr = [NSArray arrayWithArray:self.ftViews];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChartZBView *view = obj;
            [view clearData];
        }];
        self.fxConfig.fxLinetype = fxLinetype;
    }
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

- (CGPoint)correctCrossLinePoint:(CGPoint)crossLinePoint{
    CGPoint point = [super correctCrossLinePoint:crossLinePoint];
    if (_fxConfig.fxDatas.count > self.baseConfig.showIndex && self.baseConfig.showIndex >= 0 && self.baseConfig.topPrice != self.baseConfig.bottomPrice) {
        ChartFXDataModel *model = _fxConfig.fxDatas[self.baseConfig.showIndex];
        CGFloat num = ([model.closePrice doubleValue] - self.baseConfig.bottomPrice) / (self.baseConfig.topPrice - self.baseConfig.bottomPrice);
        CGFloat y = self.showFrame.origin.y + self.showFrame.size.height * (1 - num);
        point.y = y;
    }
    return point;
}
@end
