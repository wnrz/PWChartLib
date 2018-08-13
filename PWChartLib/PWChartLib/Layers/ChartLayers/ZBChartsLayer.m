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
    NSArray *arr = _zbConfig.zbDatas.datas[@"linesArray"];
    if (chartIsValidArr(arr)) {
        NSMutableArray *dataArr = _zbConfig.fsConfig ? _zbConfig.fsConfig.fsDatas : _zbConfig.fxConfig.fxDatas;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;

            NSMutableArray *A;
            NSInteger num = 0;
            if (chartIsValidDic(dict) && chartIsValidDic(dict[@"mArrBe"]) && chartIsValidArr(dict[@"mArrBe"][@"linesArray"])) {
                A = [NSMutableArray arrayWithArray:dict[@"mArrBe"][@"linesArray"]];
                A = [self correctArray:A];
                num = (NSInteger)dataArr.count - (NSInteger)A.count;
                for (NSInteger i = 0 ; i < num ; i++) {
                    [A insertObject:@(0) atIndex:0];
                }
                NSInteger begin = self->_zbConfig.baseConfig.currentIndex > (NSInteger)A.count ? (NSInteger)A.count - 1 : self->_zbConfig.baseConfig.currentIndex;
                NSInteger end = self->_zbConfig.baseConfig.currentShowNum > (NSInteger)A.count - begin ? (NSInteger)A.count - begin : self->_zbConfig.baseConfig.currentShowNum;
                A = [NSMutableArray arrayWithArray:[A subarrayWithRange:NSMakeRange(begin, end)]];
            }
            if (A) {
                if ([dict[@"type"] intValue] == 0) {
                    //折线 0
//                    [DrawCommonMethod drawMALine:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice arr:A clr:[ChartColors drawColorByIndex:idx] lineWidth:.5 lineDash:NO shadow:NO start:((drawView.drawDataCon.currentIndex >= num) ? 0 : num - drawView.drawDataCon.currentIndex)];

                }else if ([dict[@"type"] intValue] == 3) {
                    //画点 3
//                    [DrawCommonMethod drawPoint:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice arr:A clr:[ChartColors drawColorByIndex:idx] lineWidth:.5 start:0 Radius:2];

                }else if ([dict[@"type"] intValue] == 6) {
                    //柱状图 如vol 6
//                    [DrawCommonMethod drawStickLine:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice arr:A clrPos:@[(__bridge id)Chart_Color(@"color_rise").CGColor, (__bridge id)Chart_Color(@"color_rise").CGColor] clrNeg:@[(__bridge id)Chart_Color(@"color_fall").CGColor, (__bridge id)Chart_Color(@"color_fall").CGColor] stickWidth:1 start:0];

                }else if ([dict[@"type"] intValue] == -1) {
                    //特色战法

                    UIImage *image;
                    NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ChartLib.bundle"]];
                    BOOL isBuy;
                    if ([dict[@"sName"] isEqual:@"多"]) {
                        image = [UIImage imageNamed:@"chart_buy_arrow.png" inBundle:bundle compatibleWithTraitCollection:nil];
                        isBuy = YES;
                    }else{
                        image = [UIImage imageNamed:@"chart_sell_arrow.png" inBundle:bundle compatibleWithTraitCollection:nil];
                        isBuy = NO;
                    }
//                    [DrawCommonMethod drawTSZF0:drawView.showFrame total:drawView.drawDataCon.currentShowNum top:drawView.drawDataCon.topPrice bottom:drawView.drawDataCon.bottomPrice image:image start:0 tszbs:A isBuy:isBuy];

                }
            }
        }];
    }
}

- (NSMutableArray *)correctArray:(NSMutableArray *)arr1{
    NSMutableArray *arr = _zbConfig.fsConfig ? _zbConfig.fsConfig.fsDatas : _zbConfig.fxConfig.fxDatas;
    if (arr1.count > arr.count) {
        arr1 = [NSMutableArray arrayWithArray:[arr1 subarrayWithRange:NSMakeRange(arr1.count - arr.count, arr.count)]];
    }else if (arr1.count < arr.count){
    }
    return arr1;
}
@end
