//
//  ZBChartsLayer.m
//  AFNetworking
//
//  Created by 王宁 on 2018/8/13.
//

#import "ZBChartsLayer.h"
#import "ChartColors.h"
#import "ChartTools.h"

@implementation ZBChartsLayer

- (void)drawZB{
    [self clearLayers];
    ChartBaseViewModel *baseConfig = _fxConfig ? _fxConfig.baseConfig : _zbConfig.baseConfig;
    NSArray *arr = _fxConfig ? _fxConfig.zbDatas.datas[@"linesArray"] : _zbConfig.zbDatas.datas[@"linesArray"];
    if (chartIsValidArr(arr)) {
        NSMutableArray *dataArr = _fxConfig ? (NSMutableArray *)_fxConfig.fxDatas : _zbConfig.fsConfig ? (NSMutableArray *)_zbConfig.fsConfig.fsDatas : (NSMutableArray *)_zbConfig.fxConfig.fxDatas;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;

            NSInteger after = [dict[@"start"] integerValue] - baseConfig.currentIndex;
            after = after >= 0 ? after : 0;
            NSMutableArray *A;
            NSInteger num = 0;
            if (chartIsValidDic(dict) && chartIsValidArr(dict[@"linesArray"])) {
                A = [NSMutableArray arrayWithArray:dict[@"linesArray"]];
                A = [self correctArray:A];
                num = (NSInteger)dataArr.count - (NSInteger)A.count;
                for (NSInteger i = 0 ; i < num ; i++) {
                    [A insertObject:@(0) atIndex:0];
                }
                NSInteger begin = baseConfig.currentIndex > (NSInteger)A.count ? (NSInteger)A.count - 1 : baseConfig.currentIndex;
                NSInteger end = baseConfig.currentShowNum > (NSInteger)A.count - begin ? (NSInteger)A.count - begin : baseConfig.currentShowNum;
                A = [NSMutableArray arrayWithArray:[A subarrayWithRange:NSMakeRange(begin, end)]];
            }
            if (A) {
                if ([dict[@"type"] intValue] == 0) {
                    //折线 0
//                    [DrawCommonMethod drawMALine:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice arr:A clr:[ChartColors drawColorByIndex:idx] lineWidth:.5 lineDash:NO shadow:NO start:((drawView.drawDataCon.currentIndex >= num) ? 0 : num - drawView.drawDataCon.currentIndex)];
                    
                    CGFloat startX = [ChartTools getStartX:baseConfig.showFrame total:baseConfig.currentShowNum];
                    CGFloat width = baseConfig.showFrame.size.width - startX * 2;
                    width = width / baseConfig.currentShowNum;
                    CAShapeLayer *lineLayer = [LayerMaker getLineChartLayer:baseConfig.showFrame total:baseConfig.currentShowNum top:baseConfig.topPrice bottom:baseConfig.bottomPrice arr:A start:after startX:startX + width / 2];
                    lineLayer.lineWidth = .5;
                    lineLayer.strokeColor = [ChartColors drawColorByIndex:idx].CGColor;
                    [self addSublayer:lineLayer];
                }else if ([dict[@"type"] intValue] == 3) {
                    //画点 3
//                    [DrawCommonMethod drawPoint:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice arr:A clr:[ChartColors drawColorByIndex:idx] lineWidth:.5 start:0 Radius:2];

                }else if ([dict[@"type"] intValue] == 6) {
                    //柱状图 如vol 6
//                    [DrawCommonMethod drawStickLine:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice arr:A clrPos:@[(__bridge id)Chart_Color(@"color_rise").CGColor, (__bridge id)Chart_Color(@"color_rise").CGColor] clrNeg:@[(__bridge id)Chart_Color(@"color_fall").CGColor, (__bridge id)Chart_Color(@"color_fall").CGColor] stickWidth:1 start:0];

                    __block NSMutableArray *macdArray = [[NSMutableArray alloc] init];
                    [A enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        StickModel *sModel = [[StickModel alloc] init];
                        sModel.value = [obj doubleValue];
                        sModel.color = sModel.value > 0 ? [ChartColors colorByKey:kChartColorKey_Rise] : sModel.value < 0 ? [ChartColors colorByKey:kChartColorKey_Fall] : [ChartColors colorByKey:kChartColorKey_Stay];
                        [macdArray addObject:sModel];
                    }];
                    CALayer *macdLayer = [LayerMaker getStickLine:self.baseConfig.showFrame total:self.baseConfig.currentShowNum top:self.baseConfig.topPrice bottom:self.baseConfig.bottomPrice models:macdArray start:0 lineWidth:1];
                    if (macdLayer) {
                        [self addSublayer:macdLayer];
                    }
                }else if ([dict[@"type"] intValue] == -1) {
                    //特色战法

                    UIImage *image;
                    NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PWChartLib.bundle"]];
                    BOOL isBuy;
                    if ([dict[@"sName"] isEqual:@"多"]) {
                        image = [UIImage imageNamed:@"chart_buy_arrow.png" inBundle:bundle compatibleWithTraitCollection:nil];
                        isBuy = YES;
                    }else{
                        image = [UIImage imageNamed:@"chart_sell_arrow.png" inBundle:bundle compatibleWithTraitCollection:nil];
                        isBuy = NO;
                    }
                    CALayer *tszfLayer = [LayerMaker drawImages:baseConfig.showFrame total:baseConfig.currentShowNum top:baseConfig.topPrice bottom:baseConfig.bottomPrice image:image array:A isBuy:isBuy];
                    if (tszfLayer) {
                        [self addSublayer:tszfLayer];
                    }
//                    [DrawCommonMethod drawTSZF0:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice image:image start:0 tszbs:A isBuy:isBuy];

                }
            }
        }];
    }
}

- (NSMutableArray *)correctArray:(NSMutableArray *)arr1{
    NSMutableArray *arr = _fxConfig ? (NSMutableArray *)_fxConfig.fxDatas : _zbConfig.fsConfig ? (NSMutableArray *)_zbConfig.fsConfig.fsDatas : (NSMutableArray *)_zbConfig.fxConfig.fxDatas;
    if (arr1.count > arr.count) {
        arr1 = [NSMutableArray arrayWithArray:[arr1 subarrayWithRange:NSMakeRange(arr1.count - arr.count, arr.count)]];
    }else if (arr1.count < arr.count){
    }
    return arr1;
}
@end
