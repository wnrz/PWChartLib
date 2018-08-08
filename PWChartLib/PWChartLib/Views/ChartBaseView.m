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
    _layers = [[NSMutableArray alloc] init];
    
    
    _formLayer = [[ChartFormLayer alloc] init];
    _formLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_formLayer];
    
    _crossLayer = [[ChartCrossLineLayer alloc] init];
    _crossLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_crossLayer];
    
    _dataLayer = [[ChartDataLayer alloc] init];
    _dataLayer.baseConfig = _baseConfig;
    [self.layer addSublayer:_dataLayer];
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
    
    NSArray *arr = [NSArray arrayWithArray:_layers];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartBaseLayer *layer = obj;
        [layer removeFromSuperlayer];
        layer = nil;
    }];
    arr = nil;
    
    [_layers removeAllObjects];
    _layers = nil;
    
    [_formLayer removeFromSuperlayer];
    _formLayer = nil;
    
    [_crossLayer removeFromSuperlayer];
    _crossLayer = nil;
    
    [_dataLayer removeFromSuperlayer];
    _dataLayer = nil;
}

- (void)setShowFrame:(CGRect)showFrame{
    _showFrame = showFrame;
    
    [_formLayer redraw:^(ChartBaseLayer *obj) {
        obj.showFrame = showFrame;
    }];
    [_layers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChartBaseLayer *layer = obj;
        [layer redraw:^(ChartBaseLayer *obj) {
            obj.showFrame = showFrame;
        }];
    }];
    [_crossLayer redraw:^(ChartBaseLayer *obj) {
        obj.showFrame = showFrame;
    }];
    [_dataLayer redraw:^(ChartBaseLayer *obj) {
        obj.showFrame = showFrame;
    }];
}

- (void)setData:(id)data{
    
}

- (void)setZtView:(ChartBaseView *)ztView{
    _ztView = ztView;
    if (![ztView isEqual:self]) {
        self.baseConfig = ztView.baseConfig;
    }
}

- (NSInteger)dataNumber{
    return 0;
}


- (void)panGesAction:(UIPanGestureRecognizer*)recognizer{
    if (_ztView && ![_ztView canUsePanGestureRecognizer]) {
        return;
    }
    if (self.baseConfig.showCrossLine) {
        CGPoint translatedPoint = [recognizer locationInView:self];
        self.baseConfig.showCrossLinePoint = translatedPoint;
        if (chartIsValidArr(self.ftViews)) {
            NSArray *arr = [NSArray arrayWithArray:self.ftViews];
            for (NSInteger i = 0 ; i < arr.count; i++) {
                ChartBaseView *zb = self.ftViews[i];
                CGPoint translatedPoint2 = [recognizer locationInView:zb];
                zb.baseConfig.showCrossLinePoint = translatedPoint2;
            }
        }
        if (![_ztView isEqual:self]) {
            CGPoint translatedPoint2 = [recognizer locationInView:_ztView];
            _ztView.baseConfig.showCrossLinePoint = translatedPoint2;
        }
        float startX = [ChartTools getStartX:self.showFrame total:self.baseConfig.currentShowNum];
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
        [self setNeedsDisplay];
        
        if (chartIsValidArr(self.ftViews)) {
            NSArray *arr = [NSArray arrayWithArray:self.ftViews];
            for (NSInteger i = 0 ; i < arr.count; i++) {
                ChartBaseView *zb = self.ftViews[i];
                [zb.baseConfig SyncParameter:self.baseConfig];
                [zb setNeedsDisplay];
            }
        }
        if (![_ztView isEqual:self]) {
            [_ztView.baseConfig SyncParameter:self.baseConfig];
            [_ztView setNeedsDisplay];
        }
    }else{
        //                NSLog(@"!!!");
        CGPoint translatedPoint = [recognizer translationInView:self];
        
        float startX = self.showFrame.size.width / self.baseConfig.currentShowNum + 1;
        startX = startX / 2;
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
            [self setNeedsDisplay];
            
            if (chartIsValidArr(self.ftViews)) {
                NSArray *arr = [NSArray arrayWithArray:self.ftViews];
                for (NSInteger i = 0 ; i < arr.count; i++) {
                    ChartBaseView *zb = self.ftViews[i];
                    [zb.baseConfig SyncParameter:self.baseConfig];
                    [zb setNeedsDisplay];
                }
            }
            if (![_ztView isEqual:self]) {
                [_ztView.baseConfig SyncParameter:self.baseConfig];
                [_ztView setNeedsDisplay];
            }
        }
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
    [self setNeedsDisplay];
    
    if (chartIsValidArr(self.ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:self.ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = self.ftViews[i];
            [zb.baseConfig SyncParameter:self.baseConfig];
            [zb setNeedsDisplay];
        }
    }
    if (![_ztView isEqual:self]) {
        [_ztView.baseConfig SyncParameter:self.baseConfig];
        [_ztView setNeedsDisplay];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(DrawViewPinched:end:)]) {
        [_delegate DrawViewPinched:self end:recognizer.state == UIGestureRecognizerStateEnded];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FXTChanged" object:self userInfo:nil];
}

- (void)tapPressedGesAction:(UILongPressGestureRecognizer *)recognizer{
    [self hiddenCrossLine];
}

- (void)longPressedGesAction:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        _baseConfig.showCrossLine =YES;
        if (chartIsValidArr(_ftViews)) {
            NSArray *arr = [NSArray arrayWithArray:_ftViews];
            for (NSInteger i = 0 ; i < arr.count; i++) {
                ChartBaseView *zb = _ftViews[i];
                zb.baseConfig.showCrossLine = YES;
            }
        }
        if (![_ztView isEqual:self]) {
            _ztView.baseConfig.showCrossLine = YES;
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
    }
    if (self.baseConfig.showCrossLine) {
        float startX = self.ztView.showFrame.size.width / self.ztView.baseConfig.currentShowNum + 1;
        startX = startX / 2;
        CGPoint translatedPoint = [recognizer locationInView:self];
        self.baseConfig.showCrossLinePoint = translatedPoint;
        if (chartIsValidArr(self.ftViews)) {
            NSArray *arr = [NSArray arrayWithArray:self.ftViews];
            for (NSInteger i = 0 ; i < arr.count; i++) {
                ChartBaseView *zb = self.ftViews[i];
                CGPoint translatedPoint2 = [recognizer locationInView:zb];
                zb.baseConfig.showCrossLinePoint = translatedPoint2;
            }
        }
        if (![_ztView isEqual:self]) {
            CGPoint translatedPoint2 = [recognizer locationInView:_ztView];
            _ztView.baseConfig.showCrossLinePoint = translatedPoint2;
        }
        self.baseConfig.showIndex = self.ztView.baseConfig.currentIndex + (self.ztView.baseConfig.showCrossLinePoint.x - self.ztView.showFrame.origin.x) / (self.ztView.showFrame.size.width - startX) * self.ztView.baseConfig.currentShowNum;
        if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > [self.ztView dataNumber] - 1) {
            self.baseConfig.showIndex = (NSInteger)[self.ztView dataNumber] - 1;
        }else if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > self.ztView.baseConfig.currentIndex + self.ztView.baseConfig.currentShowNum - 1) {
            self.baseConfig.showIndex = self.ztView.baseConfig.currentIndex + self.ztView.baseConfig.currentShowNum - 1;
        }else if (self.baseConfig.showIndex < self.ztView.baseConfig.currentIndex){
            self.baseConfig.showIndex = self.ztView.baseConfig.currentIndex;
        }else if (self.baseConfig.showIndex < 0){
            self.baseConfig.showIndex = 0;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FXTTapped" object:self userInfo:[NSDictionary dictionaryWithObject:@"1" forKey:@"isShow"]];
        
        if (chartIsValidArr(self.ftViews)) {
            NSArray *arr = [NSArray arrayWithArray:self.ftViews];
            for (NSInteger i = 0 ; i < arr.count; i++) {
                ChartBaseView *zb = self.ftViews[i];
                [zb.baseConfig SyncParameter:self.baseConfig];
                [zb setNeedsDisplay];
            }
        }
        if (![_ztView isEqual:self]) {
            [_ztView.baseConfig SyncParameter:self.baseConfig];
            [_ztView setNeedsDisplay];
        }
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FXTTapped" object:self userInfo:[NSDictionary dictionaryWithObject:@"0" forKey:@"isShow"]];
        
        if (chartIsValidArr(self.ftViews)) {
            NSArray *arr = [NSArray arrayWithArray:self.ftViews];
            for (NSInteger i = 0 ; i < arr.count; i++) {
                ChartBaseView *zb = self.ftViews[i];
                [zb.baseConfig SyncParameter:self.baseConfig];
                [zb setNeedsDisplay];
            }
        }
        if (![_ztView isEqual:self]) {
            [_ztView.baseConfig SyncParameter:self.baseConfig];
            [_ztView setNeedsDisplay];
        }
    }
    [self setNeedsDisplay];
    if (_delegate && [_delegate respondsToSelector:@selector(DrawViewTapped:end:)]) {
        //        [_delegate DrawViewTapped:self end:recognizer.state == UIGestureRecognizerStateEnded];
        [_delegate DrawViewTapped:self end:NO];
    }
}

- (void)hiddenCrossLine{
    _baseConfig.showCrossLine = NO;
    //    _otherView.baseConfig.showCrossLine = NO;
    if (IsValidateArr(_ftViews)) {
        NSArray *arr = [NSArray arrayWithArray:_ftViews];
        for (NSInteger i = 0 ; i < arr.count; i++) {
            ChartBaseView *zb = _ftViews[i];
            zb.baseConfig.showCrossLine = NO;
        }
    }
    self.baseConfig.showIndex = self.baseConfig.currentIndex + self.baseConfig.currentShowNum - 1;
    if (self.baseConfig.showIndex >= 0 && self.baseConfig.showIndex > [self.datas count] - 1) {
        self.baseConfig.showIndex = (NSInteger)[self.datas count] - 1;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FXTTapped" object:self userInfo:[NSDictionary dictionaryWithObject:@"0" forKey:@"isShow"]];
    
    if (IsValidateArr(self.ftViews)) {
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

- (UIPanGestureRecognizer *)getPanGestureRecognizer{
    return _panGes;
}

- (BOOL)canUsePanGestureRecognizer{
    return YES;
}

@end
