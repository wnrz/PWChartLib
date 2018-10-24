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
        ([ftZBName isEqualToString:@"VOL"]) ? self.zbType = PWFTZBFSVOL : 0;
        ([ftZBName isEqualToString:@"MACD"]) ? self.zbType = PWFTZBFSMACD : 0;
        ([ftZBName isEqualToString:@"KDJ"]) ? self.zbType = PWFTZBFSKDJ : 0;
    }else if (_fxConfig) {
        ([ftZBName isEqualToString:@"VOL"]) ? self.zbType = PWFTZBFXVOL : 0;
        ([ftZBName isEqualToString:@"CCI"]) ? self.zbType = PWFTZBFXCCI : 0;
        ([ftZBName isEqualToString:@"KDJ"]) ? self.zbType = PWFTZBFXKDJ : 0;
        ([ftZBName isEqualToString:@"MACD"]) ? self.zbType = PWFTZBFXMACD : 0;
        ([ftZBName isEqualToString:@"RSI"]) ? self.zbType = PWFTZBFXRSI : 0;
        ([ftZBName isEqualToString:@"WR"]) ? self.zbType = PWFTZBFXWR : 0;
        ([ftZBName isEqualToString:@"OBV"]) ? self.zbType = PWFTZBFXOBV : 0;
        ([ftZBName isEqualToString:@"ASI"]) ? self.zbType = PWFTZBFXASI : 0;
        ([ftZBName isEqualToString:@"ROC"]) ? self.zbType = PWFTZBFXROC : 0;
        ([ftZBName isEqualToString:@"PSY"]) ? self.zbType = PWFTZBFXPSY : 0;
    }
}

- (void)getZBData{
    NSMutableDictionary *dict;
    if (_fsConfig) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_fsConfig.fsDatas];
        (self.zbType == PWFTZBFSMACD) ? dict = [[PWFSZBParam shareFSZBParam] getMACDResult:array] : 0;
        (self.zbType == PWFTZBFSKDJ) ? dict = [[PWFSZBParam shareFSZBParam] getKDJResult:array] : 0;
    }else if (_fxConfig) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_fxConfig.fxDatas];
        (self.zbType == PWFTZBFXVOL) ? dict = [[PWFXZBParam shareFXZBParam] getVOLMAResult:array] : 0;
        (self.zbType == PWFTZBFXCCI) ? dict = [[PWFXZBParam shareFXZBParam] getCCIResult:array] : 0;
        (self.zbType == PWFTZBFXKDJ) ? dict = [[PWFXZBParam shareFXZBParam] getKDJResult:array] : 0;
        (self.zbType == PWFTZBFXMACD) ? dict = [[PWFXZBParam shareFXZBParam] getMACDResult:array] : 0;
        (self.zbType == PWFTZBFXRSI) ? dict = [[PWFXZBParam shareFXZBParam] getRSIResult:array] : 0;
        (self.zbType == PWFTZBFXWR) ? dict = [[PWFXZBParam shareFXZBParam] getWRResult:array] : 0;
        (self.zbType == PWFTZBFXOBV) ? dict = [[PWFXZBParam shareFXZBParam] getOBVResult:array] : 0;
        (self.zbType == PWFTZBFXASI) ? dict = [[PWFXZBParam shareFXZBParam] getASI2Result:array] : 0;
        (self.zbType == PWFTZBFXROC) ? dict = [[PWFXZBParam shareFXZBParam] getROCResult:array] : 0;
        (self.zbType == PWFTZBFXPSY) ? dict = [[PWFXZBParam shareFXZBParam] getPSYResult:array] : 0;
    }
    self.zbDatas.datas = dict;
}

- (void)checkTopAndBottomPrice{
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
    CGFloat top;// = _baseConfig.topPrice;
    CGFloat bottom;// = _baseConfig.bottomPrice;
    if (self.zbType == PWFTZBFSVOL || self.zbType == PWFTZBFXVOL) {
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
    [self.zbDatas checkTopAndBottomPrice:_baseConfig];
    if (isnan(self.baseConfig.topPrice)) {
        NSLog(@"");
    }
}
@end
