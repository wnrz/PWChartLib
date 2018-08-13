//
//  ChartBaseView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseView.h"
#import "ChartTools.h"

@implementation ChartBaseView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self install];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self install];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self install];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)install{
    _ftViews = [[NSMutableArray alloc] init];
    _baseConfig = [[ChartBaseViewModel alloc] init];
    
    
    _formLayer = [[ChartFormLayer alloc] init];
    _formLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_formLayer];
    
    _chartsLayer = [[ChartsLayer alloc] init];
    _chartsLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_chartsLayer];
    
    _crossLayer = [[ChartCrossLineLayer alloc] init];
    _crossLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_crossLayer];
    
    _dataLayer = [[ChartDataLayer alloc] init];
    _dataLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_dataLayer];
    
    self.ztView = self;
    
    if (!_panGes) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
        [_panGes setMinimumNumberOfTouches:1];
        [_panGes setMaximumNumberOfTouches:1];
        [_panGes setDelegate:self];
        [self addGestureRecognizer:_panGes];
    }
}

- (void)dealloc{
    _ztView = nil;
    [_ftViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        [view removeFromSuperview];
        view = nil;
    }];
    [_ftViews removeAllObjects];
    _ftViews = nil;
    
    _baseConfig = nil;
    
    [_formLayer removeFromSuperlayer];
    _formLayer = nil;
    
    [_chartsLayer removeFromSuperlayer];
    _chartsLayer = nil;
    
    [_crossLayer removeFromSuperlayer];
    _crossLayer = nil;
    
    [_dataLayer removeFromSuperlayer];
    _dataLayer = nil;
}

- (void)setShowFrame:(CGRect)showFrame{
    _showFrame = showFrame;
    
    _baseConfig.showFrame = showFrame;
    
    [self startDraw];
}

- (void)startDraw{
    if (!_baseConfig.hqData) {
        return;
    }
    [_formLayer redraw:^(ChartBaseLayer *obj) {
    }];
    [_chartsLayer redraw:^(ChartBaseLayer *obj) {
    }];
    [_crossLayer redraw:^(ChartBaseLayer *obj) {
    }];
    [_dataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartDataLayer *)obj setIsDrawLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawRightText:YES];
        [(ChartDataLayer *)obj setIsDrawCrossLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawCrossRightText:YES];
    }];
}

- (void)setData:(id)data{
    
}

- (NSInteger)dataNumber{
    return 0;
}

- (void)setEnableTap:(BOOL)enableTap{
    _enableTap = enableTap;
    if (_enableTap) {
        if (!_longGes) {
            _longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedGesAction:)];
            [_longGes setMinimumPressDuration:.5];
            [self addGestureRecognizer:_longGes];
        }
        if (!_tapGes) {
            _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressedGesAction:)];
            [self addGestureRecognizer:_tapGes];
        }
    }else{
        if (_longGes) {
            [self removeGestureRecognizer:_longGes];
            _longGes = nil;
        }
        if (_tapGes) {
            [self removeGestureRecognizer:_tapGes];
            _tapGes = nil;
        }
    }
}

- (void)setEnableDrag:(BOOL)enableDrag{
    _enableDrag = enableDrag;
}

- (void)setEnableScale:(BOOL)enableScale{
    _enableScale = enableScale;
    if (enableScale) {
        if (!_twoFingerPinch) {
            _twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
            [self addGestureRecognizer:_twoFingerPinch];
        }
    }else{
        if (_twoFingerPinch) {
            [self removeGestureRecognizer:_twoFingerPinch];
            _twoFingerPinch = nil;
        }
    }
}


- (void)panGesAction:(UIPanGestureRecognizer*)recognizer{
    if (_ztView && ![_ztView canUsePanGestureRecognizer]) {
        return;
    }
    if (self.baseConfig.showCrossLine) {
        if (!_enableTap) {
            return;
        }
        [self showCrossLine:recognizer];
    }else{
        if (!_enableDrag) {
            return;
        }
        CGPoint translatedPoint = [recognizer translationInView:self];
        
        NSString *className = NSStringFromClass([self class]);
        float startX = [className isEqual:@"ChartFSView"] ? 0 : [ChartTools getStartX:self.showFrame total:self.baseConfig.currentShowNum];
        float width = (self.showFrame.size.width - startX)/self.baseConfig.currentShowNum;
        NSInteger num;
        if (translatedPoint.x*translatedPoint.x > width* width) {
            //                        NSLog(@"???");
            if (translatedPoint.x < 0) {
                num = translatedPoint.x/(self.showFrame.size.width/self.baseConfig.currentShowNum);
                if (labs(num) < 1) {
                    num = -1;
                }
                
                if (self.baseConfig.currentIndex - num + self.baseConfig.currentShowNum <= [self dataNumber]) {
                    self.baseConfig.currentIndex = self.baseConfig.currentIndex - num;
                    if (self.baseConfig.currentIndex > [self dataNumber] - self.baseConfig.currentShowNum) {
                        self.baseConfig.currentIndex = (NSInteger)[self dataNumber] - self.baseConfig.currentShowNum;
                    }
                }
                
                
            }else{
                num = translatedPoint.x/((self.showFrame.size.width)/self.baseConfig.currentShowNum);
                if (labs(num) < 1) {
                    num = 1;
                }
                self.baseConfig.currentIndex = self.baseConfig.currentIndex - num;
                if (self.baseConfig.currentIndex <= 0) {
                    self.baseConfig.currentIndex = 0;
                }
            }
            
            self.baseConfig.showIndex = self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1;
            if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > [self dataNumber] - 1) {
                self.baseConfig.showIndex = (NSInteger)[self dataNumber] - 1;
            }else if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1) {
                self.baseConfig.showIndex = self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1;
            }else if (self.baseConfig.showIndex < self.baseConfig.currentIndex){
                self.baseConfig.showIndex = self.baseConfig.currentIndex;
            }else if (self.baseConfig.showIndex < 0){
                self.baseConfig.showIndex = 0;
            }
            [recognizer setTranslation:CGPointMake(translatedPoint.x - num * width, 0) inView:self];
            
            if (chartIsValidArr(self.ftViews)) {
                NSArray *arr = [NSArray arrayWithArray:self.ftViews];
                for (NSInteger i = 0 ; i < arr.count; i++) {
                    ChartBaseView *zb = self.ftViews[i];
                    [zb.baseConfig SyncParameter:self.baseConfig];
                }
            }
            if (![_ztView isEqual:self]) {
                [_ztView.baseConfig SyncParameter:self.baseConfig];
            }
        }
        [self startDraw];
    }
}

-(void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer{
    if (self.ztView.baseConfig.showCrossLine) {
        return;
    }
    if (recognizer.scale < 1) {
        if (self.baseConfig.currentShowNum < 20) {
            self.baseConfig.currentShowNum = self.baseConfig.currentShowNum + 1;
        }else{
            self.baseConfig.currentShowNum = self.baseConfig.currentShowNum * 1.05;
        }
    }else if (recognizer.scale > 1){
        if (self.baseConfig.currentShowNum < 20) {
            self.baseConfig.currentShowNum = self.baseConfig.currentShowNum - 1;
        }else{
            self.baseConfig.currentShowNum = self.baseConfig.currentShowNum * 0.95;
        }
    }
    if (self.baseConfig.maxShowNum > self.showFrame.size.width/5) {
        //        self.baseConfig.maxShowNum = self.showFrame.size.width/5;
    }
    if (self.baseConfig.minShowNum < 5) {
        self.baseConfig.minShowNum = 5;
    }
    
    if (self.baseConfig.currentShowNum > self.baseConfig.maxShowNum) {
        self.baseConfig.currentShowNum = self.baseConfig.maxShowNum;
    }else if (self.baseConfig.currentShowNum < self.baseConfig.minShowNum){
        self.baseConfig.currentShowNum = self.baseConfig.minShowNum;
    }
    
    if (self.baseConfig.currentIndex > [self dataNumber] - self.baseConfig.currentShowNum) {
        self.baseConfig.currentIndex = (NSInteger)[self dataNumber] - self.baseConfig.currentShowNum;
    }
    
    if (self.baseConfig.currentIndex < 0) {
        self.baseConfig.currentIndex = (NSInteger)[self dataNumber] - self.baseConfig.currentShowNum;
    }
    
    self.baseConfig.currentIndex = self.baseConfig.showIndex - self.baseConfig.currentShowNum + 1;
    if (self.baseConfig.currentIndex < 0) {
        self.baseConfig.currentIndex = 0;
    }
    
    if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > [self dataNumber] - 1) {
        self.baseConfig.showIndex = (NSInteger)[self dataNumber] - 1;
    }else if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1) {
        self.baseConfig.showIndex = self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1;
    }else if (self.baseConfig.showIndex < self.baseConfig.currentIndex){
        self.baseConfig.showIndex = self.baseConfig.currentIndex;
    }else if (self.baseConfig.showIndex < 0){
        self.baseConfig.showIndex = 0;
    }
    
    [recognizer setScale:1];
    
    if (chartIsValidArr(self.ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:self.ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = self.ftViews[i];
            [zb.baseConfig SyncParameter:self.baseConfig];
        }
    }
    if (![_ztView isEqual:self]) {
        [_ztView.baseConfig SyncParameter:self.baseConfig];
    }
    [self startDraw];
}

- (void)tapPressedGesAction:(UILongPressGestureRecognizer *)recognizer{
    [self hiddenCrossLine];
}

- (void)longPressedGesAction:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        _baseConfig.showCrossLine =YES;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
    }
    if (self.baseConfig.showCrossLine) {
        [self showCrossLine:recognizer];
    }else{
        [self hiddenCrossLine];
    }
}

- (void)showCrossLine:(UIGestureRecognizer *)recognizer{
    if (![self isEqual:self.ztView]) {
        [self.ztView showCrossLine:recognizer];
        return;
    }
    
    CGPoint translatedPoint = [recognizer locationInView:self];
    self.baseConfig.showCrossLinePoint = translatedPoint;
    if (chartIsValidArr(self.ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:self.ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = self.ftViews[i];
            CGPoint translatedPoint2 = [recognizer locationInView:zb];
            zb.baseConfig.showCrossLinePoint = translatedPoint2;
            zb.baseConfig.showCrossLine = YES;
        }
    }
    NSString *className = NSStringFromClass([self class]);
    float startX = [className isEqual:@"ChartFSView"] ? 0 : [ChartTools getStartX:self.showFrame total:self.baseConfig.currentShowNum];
    self.baseConfig.showIndex = self.baseConfig.currentIndex + (self.baseConfig.showCrossLinePoint.x - self.showFrame.origin.x - startX) / (self.showFrame.size.width - startX * 2) * self.baseConfig.currentShowNum;
    if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > [self dataNumber] - 1) {
        self.baseConfig.showIndex = (NSInteger)[self dataNumber] - 1;
    }else if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1) {
        self.baseConfig.showIndex = self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1;
    }else if (self.baseConfig.showIndex < self.baseConfig.currentIndex){
        self.baseConfig.showIndex = self.baseConfig.currentIndex;
    }else if (self.baseConfig.showIndex < 0){
        self.baseConfig.showIndex = 0;
    }
    
    if (chartIsValidArr(self.ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:self.ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = self.ftViews[i];
            [zb.baseConfig SyncParameter:self.baseConfig];
        }
    }
}

- (void)hiddenCrossLine{
    if (!self.ztView.baseConfig.showCrossLine) {
        return;
    }
    if (![self isEqual:self.ztView]) {
        [self.ztView hiddenCrossLine];
        return;
    }
    _baseConfig.showCrossLine = NO;
    //    _otherView.baseConfig.showCrossLine = NO;
    if (chartIsValidArr(_ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:_ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = _ftViews[i];
            zb.baseConfig.showCrossLine = NO;
        }
    }
    self.baseConfig.showIndex = self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1;
    if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > [self dataNumber] - 1) {
        self.baseConfig.showIndex = (NSInteger)[self dataNumber] - 1;
    }
    
    if (chartIsValidArr(self.ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:self.ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = self.ftViews[i];
            [zb.baseConfig SyncParameter:self.baseConfig];
        }
    }
}

- (UIPanGestureRecognizer *)getPanGestureRecognizer{
    return _panGes;
}

- (BOOL)canUsePanGestureRecognizer{
    return YES;
}

@end
