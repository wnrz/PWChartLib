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
@end
