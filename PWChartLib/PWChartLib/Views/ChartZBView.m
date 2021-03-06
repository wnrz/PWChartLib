//
//  ChartZBView.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartZBView.h"
#import "ChartFSView.h"
#import "ChartFXView.h"

@implementation ChartZBView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)install{
    [super install];
    self.baseConfig.digit = 2;
    _config = [[ChartZBViewModel alloc] initWithBaseConfig:self.baseConfig];
    
    _zbChartsLayer = [[ZBChartsLayer alloc] init];
    _zbChartsLayer.zbConfig = _config;
    _zbChartsLayer.baseConfig = self.baseConfig;
    [self.layer insertSublayer:_zbChartsLayer above:self.formLayer];
}

- (NSInteger)dataNumber{
    return [self.ztView dataNumber];
}

- (void)startDraw{
    self.showFrame = CGRectMake(0 + self.baseConfig.offsetLeft, 0 + self.baseConfig.offsetTop, self.frame.size.width - self.baseConfig.offsetLeft - self.baseConfig.offsetRight, self.frame.size.height - self.baseConfig.offsetTop - self.baseConfig.offsetBottom);
    self.baseConfig.topPrice = 0;
    self.baseConfig.bottomPrice = 0;
    
    if (!self.baseConfig.hqData) {
        return;
    }
    [self.formLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.config checkTopAndBottomPrice];
    if ([self.ztView isKindOfClass:[ChartFSView class]] && self.config.zbType == PWFTZBFSVOL) {
        [self.chartsLayer drawVOL:[(ChartFSView *)self.ztView fsConfig]];
    }else if ([self.ztView isKindOfClass:[ChartFXView class]] && self.config.zbType == PWFTZBFXVOL) {
        [self.chartsLayer drawVOL:[(ChartFXView *)self.ztView fxConfig]];
    }else{
        [self.chartsLayer clearLayers];
    }
    
    [_zbChartsLayer drawZB];
    
    [self.crossLayer redraw:^(ChartBaseLayer *obj) {
    }];
    
    [self.dataLayer redraw:^(ChartBaseLayer *obj) {
        [(ChartDataLayer *)obj setIsDrawLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawRightText:NO];
        [(ChartDataLayer *)obj setIsDrawCrossLeftText:YES];
        [(ChartDataLayer *)obj setIsDrawCrossRightText:NO];
    }];
}

- (void)clearData{
    [_config.zbDatas.datas removeAllObjects];
    [self startDraw];
}

- (void)changeZB:(NSString *)zbName{
    self.config.ftZBName = zbName;
    [self.config getZBData];
    [self startDraw];
}

- (void)setZtView:(ChartBaseView *)ztView{
    if (super.ztView) {
        [super.ztView.ftViews removeObject:self];
    }
    super.ztView = ztView;
    [super.ztView.ftViews addObject:self];
    if ([ztView isKindOfClass:[ChartFSView class]]) {
        self.config.fsConfig = [(ChartFSView *)ztView fsConfig];
    }else if ([ztView isKindOfClass:[ChartFXView class]]) {
        self.config.fxConfig = [(ChartFXView *)ztView fxConfig];
    }
}

- (void)showZB:(NSString *)zbName{
    if (![self.config.ftZBName isEqual:zbName]) {
        self.config.ftZBName = zbName;
        [self.config getZBData];
        [self startDraw];
    }
}

- (CGPoint)correctCrossLinePoint:(CGPoint)crossLinePoint{
    CGPoint point = [super correctCrossLinePoint:crossLinePoint];
    point.y = -1;
    return point;
}
@end
