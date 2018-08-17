//
//  ChartZBViewModel.m
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartZBViewModel.h"
#import "PWFSZBParam.h"
#import "PWFXZBParam.h"
#import "ChartTools.h"

@implementation ChartZBViewModel

- (instancetype)initWithBaseConfig:(ChartBaseViewModel *)baseConfig{
    self = [super init];
    if (self) {
        _baseConfig = baseConfig;
        _zbDatas = [[ChartZBDataModel alloc] init];
    }
    return self;
}

- (void)dealloc{
    _zbDatas = nil;
}

- (void)setFsConfig:(ChartFSViewModel *)fsConfig{
    _fsConfig = fsConfig;
    _fxConfig = nil;
    [self.baseConfig SyncParameter:_fsConfig.baseConfig];
    if (self.ftZBName) {
        [self setFtZBName:_ftZBName];
    }
}

- (void)setFxConfig:(ChartFXViewModel *)fxConfig{
    _fxConfig = fxConfig;
    _fsConfig = nil;
    [self.baseConfig SyncParameter:_fxConfig.baseConfig];
    if (self.ftZBName) {
        [self setFtZBName:_ftZBName];
    }
}

- (void)setFtZBName:(NSString *)ftZBName{
    if ([_ftZBName isEqualToString:ftZBName]) {
        return;
    }
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
    }
}

- (void)getZBData{
    NSMutableDictionary *dict;
    if (_fsConfig) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_fsConfig.fsDatas];
        (self.zbType == FTZBFSMACD) ? dict = [[PWFSZBParam shareFSZBParam] getMACDResult:array] : 0;
        (self.zbType == FTZBFSKDJ) ? dict = [[PWFSZBParam shareFSZBParam] getKDJResult:array] : 0;
    }else if (_fxConfig) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_fxConfig.fxDatas];
        (self.zbType == FTZBFXVOL) ? dict = [[PWFXZBParam shareFXZBParam] getVOLMAResult:array] : 0;
        (self.zbType == FTZBFXCCI) ? dict = [[PWFXZBParam shareFXZBParam] getCCIResult:array] : 0;
        (self.zbType == FTZBFXKDJ) ? dict = [[PWFXZBParam shareFXZBParam] getKDJResult:array] : 0;
        (self.zbType == FTZBFXMACD) ? dict = [[PWFXZBParam shareFXZBParam] getMACDResult:array] : 0;
        (self.zbType == FTZBFXRSI) ? dict = [[PWFXZBParam shareFXZBParam] getRSIResult:array] : 0;
        (self.zbType == FTZBFXWR) ? dict = [[PWFXZBParam shareFXZBParam] getWRResult:array] : 0;
        (self.zbType == FTZBFXOBV) ? dict = [[PWFXZBParam shareFXZBParam] getOBVResult:array] : 0;
        (self.zbType == FTZBFXASI) ? dict = [[PWFXZBParam shareFXZBParam] getASI2Result:array] : 0;
        (self.zbType == FTZBFXROC) ? dict = [[PWFXZBParam shareFXZBParam] getROCResult:array] : 0;
        (self.zbType == FTZBFXPSY) ? dict = [[PWFXZBParam shareFXZBParam] getPSYResult:array] : 0;
    }
    self.zbDatas.datas = dict;
}

- (void)chackTopAndBottomPrice{
    NSArray *dataArr;
    if (_fsConfig) {
        dataArr = _fsConfig.fsDatas;
    }else{
        dataArr = _fxConfig.fxDatas;
    }
    if (dataArr.count == 0) {
        return;
    }
    NSInteger start = _baseConfig.currentIndex;
    NSInteger end = _baseConfig.currentIndex + _baseConfig.currentShowNum;
    start = start < 0 ? 0 : start;
    end =  end > dataArr.count ? dataArr.count : end;
    if (end < start) {
        return;
    }
    __block CGFloat top = _baseConfig.topPrice;
    CGFloat bottom = _baseConfig.bottomPrice;
    if (self.zbType == FTZBFSVOL || self.zbType == FTZBFXVOL) {
        NSArray *arr = [dataArr subarrayWithRange:NSMakeRange(start, end - start)];
        if (arr.count > 0) {
            NSArray *array;
            if (self.fsConfig) {
                array = @[[arr valueForKeyPath:@"@max.nowVol.doubleValue"],
                          [arr valueForKeyPath:@"@min.nowVol.doubleValue"]];
            }else{
                array = @[[arr valueForKeyPath:@"@max.volume.doubleValue"],
                          [arr valueForKeyPath:@"@min.volume.doubleValue"]];
            }
            top = [[array valueForKeyPath:@"@max.self"] doubleValue];
            bottom = [[array valueForKeyPath:@"@min.self"] doubleValue];
            _baseConfig.topPrice = top;
            _baseConfig.bottomPrice = bottom;
            _baseConfig.bottomPrice = 0; 
        }
    }
    if (isnan(self.baseConfig.topPrice)) {
        NSLog(@"");
    }
    [self.zbDatas chackTopAndBottomPrice:_baseConfig];
    if (isnan(self.baseConfig.topPrice)) {
        NSLog(@"");
    }
}
@end
