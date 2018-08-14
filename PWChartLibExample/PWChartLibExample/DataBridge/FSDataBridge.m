//
//  FSDataBridge.m
//  PWChartLibExample
//
//  Created by 王宁 on 2018/8/10.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "FSDataBridge.h"
#import <BaseUtils/GTPortDefine.h>
#import <NetworkController/NetworkController.h>
#import <BaseUtils/BaseUtils.h>
#import <BaseUtils/BaseTool.h>
#import <PWChartLib/ChartHQDataModel.h>
#import <PWChartLib/ChartFSDataModel.h>
#import <PWChartLib/ChartZBView.h>


@interface FSDataBridge () {
}

@end

@implementation FSDataBridge

- (void)dealloc{
    [self removeTopic];
    _codeId = nil;
}

- (void)setCodeId:(NSString *)codeId{
    [self removeTopic];
    _codeId = codeId;
    if (_fsView) {
        _fsView.baseConfig.digit = [QuoteHelper getSingleQuoteDigits:@"quotationcode" With:_codeId];
    }
    [self addTopic];
    [self loadOneProduct];
    [self loadTime];
    [self loadFS];
    [self autoLoadFS];
}

- (void)setMarketCode:(NSString *)marketCode{
    _marketCode = marketCode;
    [self loadOneProduct];
}

- (void)setFsView:(ChartFSView *)fsView{
    _fsView = fsView;
    if (_codeId) {
        fsView.baseConfig.digit = [QuoteHelper getSingleQuoteDigits:@"quotationcode" With:_codeId];
    }
}

- (void)addTopic{
    if (_codeId) {
        [self removeTopic];
        NSString *topic5001 = [NSString stringWithFormat:@"%@/%@",Funcion5001,_codeId];
        [[NCMQTTNetwork shareManager] zshbind:topic5001];
        [PWMessageCenter addBridgeObserver:self forTopic:topic5001 action:@selector(Funcion5001:)];
        
        NSString *timeTopic = [NSString stringWithFormat:@"%@%@",Funcion5002,_codeId];
        [[NCMQTTNetwork shareManager] zshbind:timeTopic];
        [PWMessageCenter addBridgeObserver:self forTopic:timeTopic action:@selector(Funcion5002:)];
    }
}

- (void)removeTopic{
    if (_codeId) {
        NSString *topic5001 = [NSString stringWithFormat:@"%@/%@",Funcion5001,_codeId];
        [[NCMQTTNetwork shareManager] zshunbind:topic5001];
        
        NSString *topic = [NSString stringWithFormat:@"%@%@",Funcion5002,_codeId];
        [[NCMQTTNetwork shareManager] zshunbind:topic];
    }
    [PWMessageCenter removeBridgeObserver:self];
}

- (void)loadOneProduct{
    if (!_codeId || !_marketCode) {
        return;
    }
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    parma[@"instid"] = _codeId;
    parma[@"market_code"] = _marketCode;
    __weak typeof(self) weakSelf = self;
    [[NCHttpNetwork shareManager] sendRequest:GT_SINGLE_TD_QUOTE_LIST withDictionary:parma  completionHandler:^(NSString* errorNo, NSDictionary *dict) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([errorNo isEqualToString:@"0"] && IsValidateDic(dict)) {
            if ([dict[@"closeprice"] doubleValue] == 0 && [dict[@"ytdsettlementprice"] doubleValue] == 0) {
                return;
            }
            ChartHQDataModel *hqinfo = [[ChartHQDataModel alloc] init];
            hqinfo.digit = [QuoteHelper getSingleQuoteDigits:@"prodcode" With:dict[@"prodcode"]];
            hqinfo.name = [NSString stringWithFormat:@"%@" , dict[@"chinesename"]];
            hqinfo.closePrice = [NSString stringWithFormat:@"%@" , dict[@"closeprice"]];
            hqinfo.yclosePrice = [NSString stringWithFormat:@"%@" , dict[@"ytdsettlementprice"]];
            if ([dict[@"prodcode"] containsString:@"T+D"]) {
                hqinfo.closePrice = [NSString stringWithFormat:@"%@" , dict[@"ytdsettlementprice"]];
            }
            hqinfo.openPrice = [NSString stringWithFormat:@"%@" , dict[@"openprice"]];
            hqinfo.nowPrice = [NSString stringWithFormat:@"%@" , dict[@"dealprice"]];
            hqinfo.topPrice = [NSString stringWithFormat:@"%@" , dict[@"highprice"]];
            hqinfo.bottomPrice = [NSString stringWithFormat:@"%@" , dict[@"lowprice"]];
            hqinfo.volume = [NSString stringWithFormat:@"%@" , dict[@"totaltrade"]];
            hqinfo.amount = [NSString stringWithFormat:@"%@" , dict[@"totaltradeamount"]];
            [strongSelf.fsView updateTopAndBottomTimeByHQData:hqinfo];
            [strongSelf.fsView startDraw];
        }
    }];
}

- (void)autoLoadFS{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoLoadFS) object:nil];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadFS) object:nil];
    [self performSelector:@selector(autoLoadFS) withObject:nil afterDelay:10];
    [self performSelector:@selector(loadFS) withObject:nil afterDelay:2];
}

- (void)loadFS{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"access_token"] = @"";
    requestDic[@"codeitem"] = _codeId;
    requestDic[@"makettype"] = @1;
    requestDic[@"start"] = @(-1);
    requestDic[@"end"] = @(-1);
    
    __weak typeof(self) weakSelf = self;
    [[NCHttpNetwork shareManager] sendRequest:GT_SINGLE_TIMELINE_QUOTE_LIST withDictionary:requestDic completionHandler:^(NSString *errorNo, NSDictionary *dict) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.fsView) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSArray *arr = dict[@"Data"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *d = obj;
                ChartFSDataModel *model = [[ChartFSDataModel alloc] init];
                model.avgPrice = d[@"avgPrice"];
                model.nowPrice = d[@"minPrice"];
                model.nowVol = d[@"minVol"];
                model.time = d[@"dMin"];
                model.timeStamp = d[@"dMin"];
                [array addObject:model];
            }];
            [strongSelf.fsView saveDatas:array];
            
            ChartHQDataModel *hqinfo = [[ChartHQDataModel alloc] init];
            hqinfo.digit = [QuoteHelper getSingleQuoteDigits:@"prodcode" With:dict[@"prodcode"]];
            hqinfo.closePrice = [NSString stringWithFormat:@"%@" , dict[@"closeprice"]];
            hqinfo.topPrice = [NSString stringWithFormat:@"%@" , dict[@"highprice"]];
            hqinfo.bottomPrice = [NSString stringWithFormat:@"%@" , dict[@"lowprice"]];
            hqinfo.nowPrice = [NSString stringWithFormat:@"%@" , dict[@"closeprice"]];
            [strongSelf.fsView updateTopAndBottomTimeByHQData:hqinfo];
            [strongSelf.fsView startDraw];
        }
    }];
}

- (void)Funcion5001:(NSDictionary *)dict{
    NSDictionary *d = dict[@"Data"];
    if (IsValidateDic(d)) {
        ChartHQDataModel *hqinfo = [[ChartHQDataModel alloc] init];
        hqinfo.digit = [QuoteHelper getSingleQuoteDigits:@"prodcode" With:d[@"prodcode"]];
        hqinfo.name = [NSString stringWithFormat:@"%@" , d[@"chinesename"]];
        hqinfo.closePrice = [NSString stringWithFormat:@"%@" , d[@"closeprice"]];
        hqinfo.yclosePrice = [NSString stringWithFormat:@"%@" , d[@"ytdsettlementprice"]];
        if ([d[@"prodcode"] containsString:@"T+D"]) {
            hqinfo.closePrice = [NSString stringWithFormat:@"%@" , d[@"ytdsettlementprice"]];
        }
        hqinfo.openPrice = [NSString stringWithFormat:@"%@" , d[@"openprice"]];
        hqinfo.nowPrice = [NSString stringWithFormat:@"%@" , d[@"dealprice"]];
        hqinfo.topPrice = [NSString stringWithFormat:@"%@" , d[@"highprice"]];
        hqinfo.bottomPrice = [NSString stringWithFormat:@"%@" , d[@"lowprice"]];
        hqinfo.volume = [NSString stringWithFormat:@"%@" , d[@"totaltrade"]];
        hqinfo.amount = [NSString stringWithFormat:@"%@" , d[@"totaltradeamount"]];
        [self.fsView updateTopAndBottomTimeByHQData:hqinfo];
        [self.fsView startDraw];
    }
}

- (void)Funcion5002:(NSDictionary *)dict{
    [self autoLoadFS];
    NSDictionary *d = dict[@"Data"];
    
    ChartHQDataModel *hqinfo = [[ChartHQDataModel alloc] init];
    hqinfo.digit = [QuoteHelper getSingleQuoteDigits:@"prodcode" With:d[@"quotaCode"]];
    hqinfo.closePrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
    hqinfo.yclosePrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
    if ([d[@"prodcode"] containsString:@"T+D"]) {
        hqinfo.closePrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
    }
    hqinfo.openPrice = [NSString stringWithFormat:@"%@" , d[@"open"]];
    hqinfo.nowPrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
    hqinfo.topPrice = [NSString stringWithFormat:@"%@" , d[@"high"]];
    hqinfo.bottomPrice = [NSString stringWithFormat:@"%@" , d[@"low"]];
    hqinfo.volume = [NSString stringWithFormat:@"%@" , d[@"volumn"]];
    [self.fsView updateTopAndBottomTimeByHQData:hqinfo];
    [self.fsView startDraw];
    
    if (![d[@"quotaCode"] isEqual:_codeId]) {
        return;
    }
    if ([[d allKeys] containsObject:@"type"] && [d[@"type"] intValue] == 0) {
        if (_fsView.fsConfig.fsDatas.count > 0) {
            [_fsView.fsConfig.fsDatas removeAllObjects];
            NSArray *arr = [NSArray arrayWithArray:_fsView.ftViews];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ChartZBView *zbView = obj;
                [zbView.config getZBData];
                [zbView startDraw];
            }];
            [_fsView startDraw];
        }
        return;
    }
    if ([[d allKeys] containsObject:@"type"] && [d[@"type"] intValue] == 0) {
        if (_fsView.fsConfig.fsDatas.count > 0) {
            [_fsView.fsConfig.fsDatas removeAllObjects];
            [_fsView startDraw];
            
            [_fsView.ftViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ChartZBView *view = obj;
                [view startDraw];
            }];
        }
        return;
    }else{
        if (_fsView.fsConfig.fsDatas.count == 0) {
            return;
        }
        ChartFSDataModel *model = [[ChartFSDataModel alloc] init];
        model.avgPrice = [NSString stringWithFormat:@"%@" , d[@"avgMin01"]];
        model.time = [NSString stringWithFormat:@"%@" , d[@"kTime"]];
        model.date = [NSString stringWithFormat:@"%@" , d[@"kDate"]];
        model.nowPrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
        
        self.fsView.baseConfig.hqData.nowPrice = [NSString stringWithFormat:@"%@" , d[@"close"]];
        self.fsView.baseConfig.hqData.openPrice = [NSString stringWithFormat:@"%@" , d[@"open"]];
        self.fsView.baseConfig.hqData.topPrice = [NSString stringWithFormat:@"%@" , d[@"high"]];
        self.fsView.baseConfig.hqData.bottomPrice = [NSString stringWithFormat:@"%@" , d[@"low"]];
        [self.fsView saveDatas:@[model]];
        [self.fsView startDraw];
    }
}

- (void)loadTime{
    NSString *times = [QuoteHelper getSingleQuoteTimeP:@"quotationcode" With:_codeId];
    if (times.length == 0) {
        return;
    }
    NSArray *array = [times componentsSeparatedByString:@"|"];
    NSInteger count = 0;
    NSString *string = @"";
    NSMutableArray *timesArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < array.count ; i++) {
        ChartFSTimeModel *model = [[ChartFSTimeModel alloc] init];
        NSString *string2 = array[i];
        NSArray *arr = [string2 componentsSeparatedByString:@"-"];
        if (arr.count == 2) {
            i > 0 ? string = [string stringByAppendingString:@","] : 0;
            int start =  [[BaseTool timeToMinute:arr[0]] intValue];
            int end =  [[BaseTool timeToMinute:arr[1]] intValue];
            end < start ? end = end + 24 * 60 : 0;
            string = [NSString stringWithFormat:@"%@%d-%d" ,string , start , end];
            count = count + end - start;
            
            model.start = start;
            model.end = end;
        }
        [timesArr addObject:model];
    }
    string = [NSString stringWithFormat:@"%ld,%@" , (long)count , string];
    [self.fsView setTimes:timesArr];
    [self.fsView startDraw];
}
@end
