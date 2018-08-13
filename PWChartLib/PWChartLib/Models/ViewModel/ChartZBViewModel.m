//
//  ChartZBViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartZBViewModel.h"
#import "FSZBParam.h"
#import "FXZBParam.h"

@implementation ChartZBViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
    }
    return nil;
}

- (void)dealloc{
    _zbDatas = nil;
}

- (void)setFsConfig:(ChartFSViewModel *)fsConfig{
    _fsConfig = fsConfig;
    _fxConfig = nil;
}

- (void)setFxConfig:(ChartFXViewModel *)fxConfig{
    _fxConfig = fxConfig;
    _fsConfig = nil;
}

- (void)setFtZBName:(NSString *)ftZBName{
    _ftZBName = ftZBName;
    if (_fsConfig) {
        ([ftZBName isEqualToString:@"VOL"]) ? self.zbType = FTZBFSVOL : 0;
        ([ftZBName isEqualToString:@"MACD"]) ? self.zbType = FTZBFSMACD : 0;
        ([ftZBName isEqualToString:@"KDJ"]) ? self.zbType = FTZBFSKDJ : 0;
    }else if (_fxConfig) {
        ([ftZBName isEqualToString:@"VOL"]) ? self.zbType = FTZBFXVOL : 0;
        ([ftZBName isEqualToString:@"CCI"]) ? self.zbType = FTZBFXCCI : 0;
        ([ftZBName isEqualToString:@"KDJ"]) ? self.zbType = FTZBFXKDJ : 0;
        ([ftZBName isEqualToString:@"MACD"]) ? self.zbType = FTZBFXMACD : 0;
        ([ftZBName isEqualToString:@"RSI"]) ? self.zbType = FTZBFXRSI : 0;
        ([ftZBName isEqualToString:@"WR"]) ? self.zbType = FTZBFXWR : 0;
        ([ftZBName isEqualToString:@"OBV"]) ? self.zbType = FTZBFXOBV : 0;
        ([ftZBName isEqualToString:@"ASI"]) ? self.zbType = FTZBFXASI : 0;
        ([ftZBName isEqualToString:@"ROC"]) ? self.zbType = FTZBFXROC : 0;
        ([ftZBName isEqualToString:@"PSY"]) ? self.zbType = FTZBFXPSY : 0;
        ([ftZBName isEqualToString:@"特色"]) ? self.zbType = FTZBFXTSZF0 : 0;
    }
}

- (void)getZBData{
    ChartZBDataModel *model = _zbDatas;
    if (_fsConfig) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_fsConfig.fsDatas];
        (self.zbType == FTZBFSMACD) ? self.zbDatas.datas = [[FSZBParam shareFSZBParam] getMACDResult:array] : 0;
        (self.zbType == FTZBFSKDJ) ? self.zbDatas.datas = [[FSZBParam shareFSZBParam] getKDJResult:array] : 0;
    }else if (_fxConfig) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_fxConfig.fxDatas];
        (self.zbType == FTZBFXVOL) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getVOLMAResult:array] : 0;
        (self.zbType == FTZBFXCCI) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getCCIResult:array] : 0;
        (self.zbType == FTZBFXKDJ) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getKDJResult:array] : 0;
        (self.zbType == FTZBFXMACD) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getMACDResult:array] : 0;
        (self.zbType == FTZBFXRSI) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getRSIResult:array] : 0;
        (self.zbType == FTZBFXWR) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getWRResult:array] : 0;
        (self.zbType == FTZBFXOBV) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getOBVResult:array] : 0;
        (self.zbType == FTZBFXASI) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getASI2Result:array] : 0;
        (self.zbType == FTZBFXROC) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getROCResult:array] : 0;
        (self.zbType == FTZBFXTSZF0) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getTSZF0Result:array] : 0;
        (self.zbType == FTZBFXPSY) ? self.zbDatas.datas = [[FXZBParam shareFXZBParam] getPSYResult:array] : 0;
    }
}
@end
