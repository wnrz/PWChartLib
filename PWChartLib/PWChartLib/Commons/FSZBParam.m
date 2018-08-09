//
//  ZBParam.m
//  socketTest
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FSZBParam.h"
#import "ChartTools.h"

@implementation FSZBParam
@synthesize VOL_MAS;

static FSZBParam* shareZBP=nil;
+(FSZBParam*)shareFSZBParam{
    //同步防止多线程访问,这里本来想用instance来作为锁对象的，但是当instance为nil的时候不能作为锁对象
    @synchronized(self){
        if (!shareZBP) {
            shareZBP= [[FSZBParam alloc] init];
            shareZBP.VOL_MAS = @[@5,@10,@20,@60];
            
            shareZBP.MACD_Short = 12.0f;
            shareZBP.MACD_Long = 26.0f;
            shareZBP.MACD_Mid = 9.0f;
            
            shareZBP.KDJ_N = 55;
            shareZBP.KDJ_M1 = 34;
            shareZBP.KDJ_M2 = 21;
        }
    }
    
    return shareZBP;
}

#pragma mark -主图指标
//主图指标


#pragma mark -幅图指标
//幅图指标
@synthesize MACD_Short;
@synthesize MACD_Long;
@synthesize MACD_Mid;

- (NSMutableDictionary *)getMACDResult2:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *dif = [[NSMutableArray alloc] init];
    NSMutableArray *dea = [[NSMutableArray alloc] init];
    NSMutableArray *macd = [[NSMutableArray alloc] init];
    NSMutableArray *ema1array = [[NSMutableArray alloc] init];
    NSMutableArray *ema2array = [[NSMutableArray alloc] init];
    NSMutableArray *emaDeaArray = [[NSMutableArray alloc] init];
    
    [dict setObject:dif forKey:FSZBResult_MACD_DIF];
    [dict setObject:dea forKey:FSZBResult_MACD_DEA];
    [dict setObject:macd forKey:FSZBResult_MACD_MACD];
    
    for (int i = 0 ; i < [array count]; i++) {
        ChartFSDataModel *klm = [array objectAtIndex:i];
        
        float ema1 = 0;
        float ema1Old;
        float ema2 = 0;
        float ema2Old;
        float emaDea;
        float emaDeaOld;
        if (i > 0) {
            ema1Old = [[ema1array objectAtIndex:i - 1] doubleValue];
            ema2Old = [[ema2array objectAtIndex:i - 1] doubleValue];
            emaDeaOld = [[emaDeaArray objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * [klm.nowPrice doubleValue] + ema1Old * (MACD_Short - 1))/(MACD_Short + 1);
            ema2 = (2 * [klm.nowPrice doubleValue] + ema2Old * (MACD_Long - 1))/(MACD_Long + 1);
            emaDea = (2 * (ema1 - ema2) + emaDeaOld * (MACD_Mid - 1))/(MACD_Mid + 1);
        }else{
            ema1Old = [klm.nowPrice doubleValue];
            ema2Old = [klm.nowPrice doubleValue];
            emaDea = 0;
        }
        
        [ema1array addObject:[NSNumber numberWithFloat:ema1]];
        [ema2array addObject:[NSNumber numberWithFloat:ema2]];
        [emaDeaArray addObject:[NSNumber numberWithFloat:emaDea]];
        if (i == 0) {
            [dif addObject:[NSNumber numberWithFloat:0]];
            [dea addObject:[NSNumber numberWithFloat:0]];
            [macd addObject:[NSNumber numberWithFloat:0]];
        }else{
            [dif addObject:[NSNumber numberWithFloat:(ema1 - ema2)]];
            [dea addObject:[NSNumber numberWithFloat:emaDea]];
            [macd addObject:[NSNumber numberWithFloat:(((ema1 - ema2) - emaDea) * 2)]];
        }
        
    }
    
    
    return dict;
}

- (NSMutableDictionary *)getMACDResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *dif = [[NSMutableArray alloc] init];
    NSMutableArray *dea = [[NSMutableArray alloc] init];
    NSMutableArray *macd = [[NSMutableArray alloc] init];
    NSMutableArray *ema1array = [[NSMutableArray alloc] init];
    NSMutableArray *ema2array = [[NSMutableArray alloc] init];
    NSMutableArray *emaDeaArray = [[NSMutableArray alloc] init];
    
    [dict setObject:dif forKey:FSZBResult_MACD_DIF];
    [dict setObject:dea forKey:FSZBResult_MACD_DEA];
    [dict setObject:macd forKey:FSZBResult_MACD_MACD];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFSDataModel *klm = [array objectAtIndex:i];
        
        float ema1;
        float ema1Old;
        float ema2;
        float ema2Old;
        float emaDea;
        float emaDeaOld;
        if (i == 120){
            NSLog(@"");
        }
        if (i > 0) {
            ema1Old = [[ema1array objectAtIndex:i - 1] doubleValue];
            ema2Old = [[ema2array objectAtIndex:i - 1] doubleValue];
            emaDeaOld = [[emaDeaArray objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * [klm.nowPrice doubleValue] + ema1Old * (MACD_Short - 1))/(MACD_Short + 1);
            ema2 = (2 * [klm.nowPrice doubleValue] + ema2Old * (MACD_Long - 1))/(MACD_Long + 1);
            emaDea = (2 * (ema1 - ema2) + emaDeaOld * (MACD_Mid - 1))/(MACD_Mid + 1);
        }else{
            ema1 = [klm.nowPrice doubleValue];
            ema2 = [klm.nowPrice doubleValue];
            emaDea = 0;
        }
        
        [ema1array addObject:[NSNumber numberWithFloat:ema1]];
        [ema2array addObject:[NSNumber numberWithFloat:ema2]];
        [emaDeaArray addObject:[NSNumber numberWithFloat:emaDea]];
        if (i == 0) {
            [dif addObject:[NSNumber numberWithFloat:0]];
            [dea addObject:[NSNumber numberWithFloat:0]];
            [macd addObject:[NSNumber numberWithFloat:0]];
        }else{
            [dif addObject:[NSNumber numberWithFloat:(ema1 - ema2)]];
            [dea addObject:[NSNumber numberWithFloat:emaDea]];
            [macd addObject:[NSNumber numberWithFloat:(((ema1 - ema2) - emaDea) * 2)]];
        }
        
    }
    
    return dict;
}

- (NSMutableDictionary *)getVOLMAResult:(NSMutableArray *)array{
    NSMutableDictionary *vols;
    vols = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        for (int x = 0 ; x < VOL_MAS.count; x++) {
            float ma = [VOL_MAS[x] doubleValue];
            if (ma > 0) {
                NSMutableArray *tmpArray = vols[@(ma)];
                if (!tmpArray) {
                    tmpArray = [[NSMutableArray alloc] init];
                    [vols setObject:tmpArray forKey:@(ma)];
                }
                if (i >= ma - 1) {
                    float nowVol = 0.0f;
                    for (int j = i - (ma - 1); j <= i ; j++) {
                        ChartFSDataModel *klm = [array objectAtIndex:j];
                        nowVol = nowVol + [klm.nowVol doubleValue];
                    }
                    nowVol = nowVol/ma;
                    [tmpArray addObject:@(nowVol)];
                }else{
                    [tmpArray addObject:@(0)];
                }
            }
            
        }
    }
    return vols;
}
@synthesize KDJ_N;
@synthesize KDJ_M1;
@synthesize KDJ_M2;

- (NSMutableDictionary *)getKDJResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *k = [[NSMutableArray alloc] init];
    NSMutableArray *d = [[NSMutableArray alloc] init];
    NSMutableArray *j = [[NSMutableArray alloc] init];
    
    [dict setObject:k forKey:FSZBResult_KDJ_K];
    [dict setObject:d forKey:FSZBResult_KDJ_D];
    [dict setObject:j forKey:FSZBResult_KDJ_J];
    /*
     RSV=(NEW-LLV(NEW,N))/(HHV(NEW,N)-LLV(NEW,N))*100;
     a=SMA(RSV,M1,1);
     b=SMA(a,M2,1);
     e=3*a-2*b;
     K:a;
     D:b;
     J:e;
     */
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFSDataModel *klm = [array objectAtIndex:i];
        
        float llv = -1;
        float hhv = -1;
        float rsv;
        
        NSInteger start = i - KDJ_N + 1;
        if (KDJ_N == 0) {
            start = 0;
        }
        if (start < 0) {
            start = 0;
        }
        for ( NSInteger j = start; j <= i; j++) {
            ChartFSDataModel *klm2 = [array objectAtIndex:j];
            if (j == start) {
                llv = [klm2.nowPrice doubleValue];
                hhv = [klm2.nowPrice doubleValue];
            }
            
            if ([klm2.nowPrice doubleValue] < llv) {
                llv = [klm2.nowPrice doubleValue];
            }
            
            if ([klm2.nowPrice doubleValue] > hhv) {
                hhv = [klm2.nowPrice doubleValue];
            }
        }
        
        rsv = ([klm.nowPrice doubleValue] - llv)/(hhv - llv)*100;
        
        if (isnan(rsv) || isinf(rsv)) {
            rsv = 0;
        }
        float kOld = 50;
        float kNow = kOld;
        if (i > 0) {
            kOld = [[k objectAtIndex:i - 1] doubleValue];
            kNow = (rsv * 1 + kOld*(KDJ_M1 - 1))/KDJ_M1;
        }
        [k addObject:[NSNumber numberWithFloat:kNow]];
        
        float dOld = 50;
        float dNow = dOld;
        if (i > 0) {
            dOld = [[d objectAtIndex:i - 1] doubleValue];
            dNow = (kNow * 1 + dOld*(KDJ_M2 - 1))/KDJ_M2;
        }
        [d addObject:[NSNumber numberWithFloat:dNow]];
        
        float jNow = 3 * kNow - 2 *dNow;
        [j addObject:[NSNumber numberWithFloat:jNow]];
        if (i == [array count] - 1) {
            
        }
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"KDJ(%.0f,%.0f,%.0f)" , KDJ_N , KDJ_M1 , KDJ_M2] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:@{@"type":@0,
                     @"sName":@"K",
                     @"mArrBe":@{@"linesArray":k}
                     }];
    [arr addObject:@{@"type":@0,
                     @"sName":@"D",
                     @"mArrBe":@{@"linesArray":d}
                     }];
    [arr addObject:@{@"type":@0,
                     @"sName":@"J",
                     @"mArrBe":@{@"linesArray":j}
                     }];
    
    return result;
}
@end
