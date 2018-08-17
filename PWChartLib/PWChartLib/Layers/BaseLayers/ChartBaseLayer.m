//
//  ChartBaseLayer.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartBaseLayer.h"
#import "PWChartColors.h"

@implementation ChartBaseLayer

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

- (instancetype)initWithLayer:(id)layer{
    self = [super initWithLayer:layer];
    if (self) {
        [self install];
    }
    return self;
}

- (void)dealloc{
    [self clearLayers];
    _lineColor = nil;
    
    [_baseConfig removeBridgeObserver:self];
}

- (void)install{
    self.lineWidth = 1;
    self.lineColor = [PWChartColors colorByKey:kChartColorKey_Form];
}

- (void)startDraw{
    [self clearLayers];
}

- (void)clearLayers{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.sublayers];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *layer = obj;
        [layer removeFromSuperlayer];
        layer = nil;
    }];
}

- (void)redraw:(void(^)(ChartBaseLayer *obj))block{
    if (block) {
        block(self);
    }
    [self startDraw];
}
@end
