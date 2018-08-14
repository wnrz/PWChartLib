//
//  FXDataBridge.m
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/10.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "FXDataBridge.h"
#import <BaseUtils/GTPortDefine.h>
#import <NetworkController/NetworkController.h>
#import <BaseUtils/BaseUtils.h>
#import <BaseUtils/BaseTool.h>
#import <PWChartLib/ChartHQDataModel.h>
#import <PWChartLib/ChartFXDataModel.h>
#import <PWChartLib/ChartZBView.h>


@interface FXDataBridge () {
    BOOL isLoadingMore;
}

@end

@implementation FXDataBridge

- (void)dealloc{
    [_fxView.baseConfig removeBridgeObserver:self];
    [self removeTopic];
    _codeId = nil;
}

- (void)setCodeId:(NSString *)codeId{
    [self removeTopic];
    _codeId = codeId;
    if (_fxView) {
        _fxView.baseConfig.digit = [QuoteHelper getSingleQuoteDigits:@"quotationcode" With:_codeId];
    }
    [self addTopic];
    [self loadFX:0];
    [self autoLoadFX];
}

- (void)setFxView:(ChartFXView *)fxView{
    [_fxView.baseConfig removeBridgeObserver:self];
    _fxView = fxView;
    [_fxView.baseConfig addBridgeObserver:self forKeyPath:@"currentIndex" action:@selector(loadMore)];
    if (_codeId) {
        fxView.baseConfig.digit = [QuoteHelper getSingleQuoteDigits:@"quotationcode" With:_codeId];
    }
}

- (void)addTopic{
    if (_codeId) {
        [self removeTopic];
        
        NSString *kTopic = [NSString stringWithFormat:@"%@%@",Funcion5004,_codeId];
        [[NCMQTTNetwork shareManager] zshbind:kTopic];
        [PWMessageCenter addBridgeObserver:self forTopic:kTopic action:@selector(Funcion5004:)];
    }
}

- (void)removeTopic{
    if (_codeId) {
        
        NSString *kTopic = [NSString stringWithFormat:@"%@%@",Funcion5004,_codeId];
        [[NCMQTTNetwork shareManager] zshunbind:kTopic];
    }
    [PWMessageCenter removeBridgeObserver:self];
}

- (void)loadMore{
    if (_fxView.baseConfig.currentIndex < 50) {
        if (isLoadingMore) {
            return;
        }
        isLoadingMore = YES;
        [self loadFX:1];
    }
}

- (void)loadLast{
    [self loadFX:2];
}

- (void)autoLoadFX{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoLoadFX) object:nil];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadLast) object:nil];
    [self performSelector:@selector(autoLoadFX) withObject:nil afterDelay:10];
    [self performSelector:@selector(loadLast) withObject:nil afterDelay:2];
}
//type 0:加载最新 1:加载更多 2:加载最后一根
- (void)loadFX:(int)type{
    float pageSize = 300.0f;
    BOOL more = (type == 1);
    BOOL last = (type == 2);
    if (!_fxView) {
        return;
    }
    NSString *period = [self getPeriod];
    NSInteger pageNum = last ? 1 : more ? floor(_fxView.fxConfig.fxDatas.count / pageSize) + 1 : 1;
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"access_token"] = @"";
    requestDic[@"codeitem"] = _codeId;
    requestDic[@"makettype"] = @1;
    requestDic[@"page_size"] = last ? (_fxView.fxConfig.fxLinetype < KLineType_DAY ? @10 : @2) : @(pageSize);
    requestDic[@"page_no"] = @(pageNum);
    requestDic[@"direction"] = @1;
    
    __weak typeof(self) weakSelf = self;
    __block NSInteger zq = _fxView.fxConfig.fxLinetype;
    requestDic[@"period"] = period;
    [[NCHttpNetwork shareManager] sendRequest:GT_SINGLE_KLINE_QUOTE_LIST withDictionary:requestDic completionHandler:^(NSString *errorNo, NSDictionary *dict) {
        if (type == 1) {
            self->isLoadingMore = NO;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (zq != strongSelf->_fxView.fxConfig.fxLinetype) {
            return;
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSArray *array = dict[@"result"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *data = obj;
            ChartFXDataModel *model = [[ChartFXDataModel alloc] init];
            [arr addObject:model];
            model.openPrice = [NSString stringWithFormat:@"%@" , data[@"open"]];
            model.topPrice = [NSString stringWithFormat:@"%@" , data[@"high"]];
            model.bottomPrice = [NSString stringWithFormat:@"%@" , data[@"low"]];
            model.closePrice = [NSString stringWithFormat:@"%@" , data[@"close"]];
            model.volume = [NSString stringWithFormat:@"%@" , data[@"volumn"]];
            model.time = [NSString stringWithFormat:@"%@" , data[@"kTime"]];
            model.date = [NSString stringWithFormat:@"%@" , data[@"kDate"]];
            
            NSString *dayTime = [NSString stringWithFormat:@"%08zd%04zd" , [data[@"kDate"] integerValue] , [data[@"kTime"] integerValue]];
            model.timeStamp = [BaseTool date2SstringStamp:dayTime format:@"yyyyMMddHHmm"];
        }];
        [self.fxView saveDatas:arr];
    }];
}

- (void)Funcion5004:(NSDictionary *)dict{
    [self autoLoadFX];
    NSDictionary *d = dict[@"Data"];
    if (![d[@"quotaCode"] isEqual:_codeId] || _fxView.fxConfig.fxDatas.count == 0) {
        return;
    }
    if ([d[@"KType"] isEqual:[self getPeriod]]) {
        ChartFXDataModel *model = [[ChartFXDataModel alloc] init];
        model.openPrice = [NSString stringWithFormat:@"%@" , d[@"open"]];
        model.topPrice = [NSString stringWithFormat:@"%@" , d[@"high"]];
        model.bottomPrice = [NSString stringWithFormat:@"%@" , d[@"low"]];
        model.closePrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
        model.volume = [NSString stringWithFormat:@"%@" , d[@"volumn"]];
        model.time = [NSString stringWithFormat:@"%@" , d[@"kTime"]];
        model.date = [NSString stringWithFormat:@"%@" , d[@"kDate"]];
        
        NSString *dayTime = [NSString stringWithFormat:@"%08zd%04zd" , [d[@"kDate"] integerValue] , [d[@"kTime"] integerValue]];
        model.timeStamp = [BaseTool date2SstringStamp:dayTime format:@"yyyyMMddHHmm"];
        
        [self.fxView saveDatas:@[model]];
    }
}

- (NSString *)getPeriod{
    NSString *period = @"";
    switch (_fxView.fxConfig.fxLinetype) {
        case KLineType_1Min:
            period = @"MIN01";
            break;
        case KLineType_5Min:
            period = @"MIN05";
            break;
        case KLineType_30Min:
            period = @"MIN30";
            break;
        case KLineType_60Min:
            period = @"MIN60";
            break;
        case KLineType_DAY:
            period = @"DAY";
            break;
        case KLineType_WEEK:
            period = @"WEEK";
            break;
        case KLineType_MONTH:
            period = @"MONTH";
            break;
        default:
            period = @"DAY";
            break;
    }
    return period;
}
@end
