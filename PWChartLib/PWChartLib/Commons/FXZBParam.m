//
//  ZBParam.m
//  socketTest
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FXZBParam.h"
#import "ChartTools.h"

@implementation FXZBParam
@synthesize VOL_MAS;
@synthesize Pri_MAS;

static FXZBParam* shareZBP=nil;
+(FXZBParam*)shareFXZBParam{
    //同步防止多线程访问,这里本来想用instance来作为锁对象的，但是当instance为nil的时候不能作为锁对象
    @synchronized(self){
        if (!shareZBP) {
            shareZBP= [[FXZBParam alloc] init];
            shareZBP.VOL_MAS = @[@5,@10];//,@20,@60
            shareZBP.Pri_MAS = @[@5,@10,@20];//,@30
            
            shareZBP.MACD_Short = 12.0f;
            shareZBP.MACD_Long = 26.0f;
            shareZBP.MACD_Mid = 9.0f;
            
            shareZBP.KDJ_N = 9;
            shareZBP.KDJ_M1 = 3;
            shareZBP.KDJ_M2 = 3;
            
            shareZBP.DMI_N = 14;
            shareZBP.DMI_MM = 6;
            
            shareZBP.DMA_N1 = 10;
            shareZBP.DMA_N2 = 50;
            shareZBP.DMA_M = 10;
            
            shareZBP.TRIX_N = 12;
            shareZBP.TRIX_M = 9;
            
            shareZBP.BRAR_N = 26;
            
            shareZBP.CR_N = 26;
            shareZBP.CR_M1 = 10;
            shareZBP.CR_M2 = 20;
            shareZBP.CR_M3 = 40;
            shareZBP.CR_M4 = 62;
            
            shareZBP.VR_N = 26;
            shareZBP.VR_M = 6;
            
            shareZBP.OBV_M = 30;
            
            shareZBP.ASI_M = 6;
            
            shareZBP.EMV_N = 14;
            shareZBP.EMV_M = 9;
            
            shareZBP.RSI_N1 = 6;
            shareZBP.RSI_N2 = 12;
            shareZBP.RSI_N3 = 24;
            
            shareZBP.WR_N = 10;
            shareZBP.WR_N1 = 6;
            
            shareZBP.CCI_N = 14;
            
            shareZBP.ROC_N = 12;
            shareZBP.ROC_M = 6;
            
            shareZBP.MTM_N = 12;
            shareZBP.MTM_M = 6;
            
            shareZBP.BIAS_N1 = 6;
            shareZBP.BIAS_N2 = 12;
            shareZBP.BIAS_N3 = 24;
            
            shareZBP.BOLL_M = 20.0f;
            
            shareZBP.AROON_N = 25.0f;
        }
    }
    
    return shareZBP;
}

#pragma mark -主图指标
//主图指标
- (NSMutableDictionary *)getPriMAResult:(NSMutableArray *)array{
    NSMutableDictionary *vols;
    vols = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < array.count; i++) {
        for (int x = 0 ; x < Pri_MAS.count; x++) {
            int ma = [Pri_MAS[x] intValue];
            if (ma > 0) {
                NSMutableArray *tmpArray = vols[@(ma)];
                if (!tmpArray) {
                    tmpArray = [[NSMutableArray alloc] init];
                    [vols setObject:tmpArray forKey:@(ma)];
                }
                if (i >= ma - 1) {
                    float price = 0.0f;
                    for (int j = i - (ma - 1); j <= i ; j++) {
                        ChartFXDataModel *klm = [array objectAtIndex:j];
                        price = price + [klm.closePrice doubleValue];
                    }
                    price = price/ma;
                    [tmpArray addObject:@(price)];
                }else{
                    [tmpArray addObject:@(0)];
                }
            }
            
        }
    }
    return vols;
}

#pragma mark -幅图指标
//幅图指标
- (NSMutableDictionary *)getVOLMAResult:(NSMutableArray *)array{
    NSMutableDictionary *vols;
    vols = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < array.count; i++) {
        for (int x = 0 ; x < VOL_MAS.count; x++) {
            int ma = [VOL_MAS[x] intValue];
            if (ma > 0) {
                NSMutableArray *tmpArray = vols[@(ma)];
                if (!tmpArray) {
                    tmpArray = [[NSMutableArray alloc] init];
                    [vols setObject:tmpArray forKey:@(ma)];
                }
                if (i >= ma - 1) {
                    float price = 0.0f;
                    for (int j = i - (ma - 1); j <= i ; j++) {
                        ChartFXDataModel *klm = [array objectAtIndex:j];
                        price = price + [klm.volume doubleValue];
                    }
                    price = price/ma;
                    [tmpArray addObject:@(price)];
                }else{
                    [tmpArray addObject:@(0)];
                }
            }
            
        }
    }
    return vols;
}

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
    
    [dict setObject:dif forKey:FXZBResult_MACD_DIF];
    [dict setObject:dea forKey:FXZBResult_MACD_DEA];
    [dict setObject:macd forKey:FXZBResult_MACD_MACD];
    
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float ema1;
        float ema1Old;
        float ema2;
        float ema2Old;
        float emaDea;
        float emaDeaOld;
        if (i > 0) {
            ema1Old = [[ema1array objectAtIndex:i - 1] doubleValue];
            ema2Old = [[ema2array objectAtIndex:i - 1] doubleValue];
            emaDeaOld = [[emaDeaArray objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * [klm.closePrice doubleValue] + ema1Old * (MACD_Short - 1))/(MACD_Short + 1);
            ema2 = (2 * [klm.closePrice doubleValue] + ema2Old * (MACD_Long - 1))/(MACD_Long + 1);
            emaDea = (2 * (ema1 - ema2) + emaDeaOld * (MACD_Mid - 1))/(MACD_Mid + 1);
        }else{
            ema1Old = [klm.closePrice doubleValue];
            ema2Old = [klm.closePrice doubleValue];
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
    
    [dict setObject:dif forKey:FXZBResult_MACD_DIF];
    [dict setObject:dea forKey:FXZBResult_MACD_DEA];
    [dict setObject:macd forKey:FXZBResult_MACD_MACD];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
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
            ema1 = (2 * [klm.closePrice doubleValue] + ema1Old * (MACD_Short - 1))/(MACD_Short + 1);
            ema2 = (2 * [klm.closePrice doubleValue] + ema2Old * (MACD_Long - 1))/(MACD_Long + 1);
            emaDea = (2 * (ema1 - ema2) + emaDeaOld * (MACD_Mid - 1))/(MACD_Mid + 1);
        }else{
            ema1 = [klm.closePrice doubleValue];
            ema2 = [klm.closePrice doubleValue];
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


@synthesize KDJ_N;
@synthesize KDJ_M1;
@synthesize KDJ_M2;

- (NSMutableDictionary *)getKDJResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *k = [[NSMutableArray alloc] init];
    NSMutableArray *d = [[NSMutableArray alloc] init];
    NSMutableArray *j = [[NSMutableArray alloc] init];
    
    [dict setObject:k forKey:FXZBResult_KDJ_K];
    [dict setObject:d forKey:FXZBResult_KDJ_D];
    [dict setObject:j forKey:FXZBResult_KDJ_J];
    
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float llv = -1;
        float hhv = -1;
        float rsv;
        
        int start = i - KDJ_N + 1;
        if (KDJ_N == 0) {
            start = 0;
        }
        for ( int j = start; j <= i; j++) {
            if ( j < 0) {
                continue;
            }
            ChartFXDataModel *klm2 = [array objectAtIndex:j];
            if (j == start) {
                llv = [klm2.bottomPrice doubleValue];
                hhv = [klm2.topPrice doubleValue];
            }
            
            if ([klm2.bottomPrice doubleValue] < llv) {
                llv = [klm2.bottomPrice doubleValue];
            }
            
            if ([klm2.topPrice doubleValue] > hhv) {
                hhv = [klm2.topPrice doubleValue];
            }
        }
        
        rsv = ([klm.closePrice doubleValue] - llv)/(hhv - llv)*100;
        
        if (isnan(rsv)) {
            rsv = 0;
        }
        float kOld = 50;
        if (i > 0) {
            kOld = [[k objectAtIndex:i - 1] doubleValue];
        }
        float kNow = (rsv * 1 + kOld*(KDJ_M1 - 1))/KDJ_M1;
        [k addObject:[NSNumber numberWithFloat:kNow]];
        
        float dOld = 50;
        if (i > 0) {
            dOld = [[d objectAtIndex:i - 1] doubleValue];
        }
        float dNow = (kNow * 1 + dOld*(KDJ_M2 - 1))/KDJ_M2;
        [d addObject:[NSNumber numberWithFloat:dNow]];
        
        float jNow = 3 * kNow - 2 *dNow;
        [j addObject:[NSNumber numberWithFloat:jNow]];
        if (i == [array count] - 1) {
            
        }
    }
    
    return dict;
}


@synthesize DMI_N;
@synthesize DMI_MM;

- (NSMutableDictionary *)getDMIResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *PDI = [[NSMutableArray alloc] init];
    NSMutableArray *MDI = [[NSMutableArray alloc] init];
    NSMutableArray *ADX = [[NSMutableArray alloc] init];
    NSMutableArray *ADXR = [[NSMutableArray alloc] init];
    
    [dict setObject:PDI forKey:FXZBResult_DMI_PDI];
    [dict setObject:MDI forKey:FXZBResult_DMI_MDI];
    [dict setObject:ADX forKey:FXZBResult_DMI_ADX];
    [dict setObject:ADXR forKey:FXZBResult_DMI_ADXR];
    
    NSMutableArray *MTR = [[NSMutableArray alloc] init];
    NSMutableArray *DMP = [[NSMutableArray alloc] init];
    NSMutableArray *DMM = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
    
        float mtrOld = 0;
        float dmpOld = 0;
        float dmmOld = 0;
        float adxOld = 0;
        float adxrOld = 0;
        float lastClose = [klm.closePrice doubleValue];
        float lastTop = [klm.topPrice doubleValue];
        float lastBottom = [klm.bottomPrice doubleValue];
        if (i > 0) {
            ChartFXDataModel *klm2 = [array objectAtIndex:i - 1];
            lastClose = [klm2.closePrice doubleValue];
            lastTop = [klm2.topPrice doubleValue];
            lastBottom = [klm2.bottomPrice doubleValue];
            mtrOld = [[MTR objectAtIndex:i - 1] doubleValue];
            dmpOld = [[DMP objectAtIndex:i - 1] doubleValue];
            dmmOld = [[DMM objectAtIndex:i - 1] doubleValue];
            adxOld = [[ADX objectAtIndex:i - 1] doubleValue];
            adxrOld = [[ADXR objectAtIndex:i - 1] doubleValue];
        }
        float mtrX = MAX(MAX(([klm.topPrice doubleValue] - [klm.bottomPrice doubleValue]), fabs([klm.topPrice doubleValue] - lastClose)), fabs(lastClose - [klm.bottomPrice doubleValue]));
        float mtrNow = (2 * mtrX +(DMI_N - 1) * mtrOld)/(DMI_N + 1);
        [MTR addObject:[NSNumber numberWithFloat:mtrNow]];
        
        float HDNow = [klm.topPrice doubleValue] - lastTop;
        float LDNow = lastBottom - [klm.bottomPrice doubleValue];
        
        float dmpX = 0;
        if (HDNow > 0 && HDNow > LDNow) {
            dmpX = HDNow;
        }else{
            dmpX = 0;
        }
        
        float dmpNow = (2 * dmpX +(DMI_N - 1) * dmpOld)/(DMI_N + 1);
        [DMP addObject:[NSNumber numberWithFloat:dmpNow]];
        
        float dmmX = 0;
        if (LDNow > 0 && LDNow > HDNow) {
            dmmX = LDNow;
        }else{
            dmmX = 0;
        }
        
        float dmmNow = (2 * dmmX +(DMI_N - 1) * dmmOld)/(DMI_N + 1);
        [DMM addObject:[NSNumber numberWithFloat:dmmNow]];
        
        float pdiNow = dmpNow * 100 / mtrNow;
        [PDI addObject:[NSNumber numberWithFloat:pdiNow]];
        
        float mdiNow = dmmNow * 100 / mtrNow;
        [MDI addObject:[NSNumber numberWithFloat:mdiNow]];
        
        float adxNow = (2 * fabsf(mdiNow - pdiNow) / (mdiNow + pdiNow) * 100 +(DMI_MM - 1) * adxOld)/(DMI_MM + 1);
        if (isnan(adxNow)) {
            adxNow = 0;
        }
        [ADX addObject:[NSNumber numberWithFloat:adxNow]];
        
        float adxrNow = (2 * adxNow +(DMI_MM - 1) * adxrOld)/(DMI_MM + 1);
        if (isnan(adxrNow)) {
            adxrNow = 0;
        }
        [ADXR addObject:[NSNumber numberWithFloat:adxrNow]];        
    }
    
    return dict;
}

@synthesize DMA_N1;
@synthesize DMA_N2;
@synthesize DMA_M;

- (NSMutableDictionary *)getDMAResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *DIF = [[NSMutableArray alloc] init];
    NSMutableArray *DIFMA = [[NSMutableArray alloc] init];
    
    [dict setObject:DIF forKey:FXZBResult_DMA_DIF];
    [dict setObject:DIFMA forKey:FXZBResult_DMA_DIFMA];
    
    for (int i = 0 ; i < [array count]; i++) {
        int count = 0;
        float price1 = 0;
        float price2 = 0;
        float price3 = 0;
        for (int j = i - DMA_N1 + 1 ; j <= i; j++) {
            if (j >= 0) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                price1 = price1 + [klm2.closePrice doubleValue];
                count++;
            }
        }
        price1 = price1 / count;
        
        count = 0;
        for (int j = i - DMA_N2 + 1 ; j <= i; j++) {
            if (j >= 0) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                price2 = price2 + [klm2.closePrice doubleValue];
                count++;
            }
        }
        price2 = price2 / count;
        
        float difNow = price1 - price2;
        
        count = 0;
        [DIF addObject:[NSNumber numberWithFloat:difNow]];
        for (int j = i - DMA_M + 1 ; j <= i; j++) {
            if (j >= 0) {
                price3 = price3 + [[DIF objectAtIndex:j] doubleValue];
                count++;
            }
        }
        price3 = price3 / count;
        float difmaNow = price3;
        [DIFMA addObject:[NSNumber numberWithFloat:difmaNow]];
        
        
    }
    
    return dict;
}

@synthesize TRIX_N;
@synthesize TRIX_M;

- (NSMutableDictionary *)getTRIXResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *TRIX = [[NSMutableArray alloc] init];
    NSMutableArray *MATRIX = [[NSMutableArray alloc] init];
    NSMutableArray *MTR = [[NSMutableArray alloc] init];
    
    [dict setObject:TRIX forKey:FXZBResult_TRIX_TRIX];
    [dict setObject:MATRIX forKey:FXZBResult_TRIX_MATRIX];
    
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float ema;
        float emaOld;
        if (i > 0) {
            emaOld = [[MTR objectAtIndex:i - 1] doubleValue];
        }else{
            emaOld = 0;
        }
        ema = (2 * [klm.closePrice doubleValue] + emaOld * (TRIX_N - 1))/(TRIX_N + 1);
        [MTR addObject:[NSNumber numberWithFloat:ema]];
    
    }
    
    for (int i = 0; i < 2; i++) {
        for (int x = 0 ; x < [MTR count]; x++) {
            NSNumber *emaNum = [MTR objectAtIndex:x];
            
            float ema;
            float emaOld;
            if (x > 0) {
                emaOld = [[MTR objectAtIndex:x - 1] doubleValue];
            }else{
                emaOld = 0;
            }
            ema = (2 * [emaNum doubleValue] + emaOld * (TRIX_N - 1))/(TRIX_N + 1);
            [MTR replaceObjectAtIndex:x withObject:[NSNumber numberWithFloat:ema]];
            emaNum = nil;
        }
    }
    
    for (int i = 0 ; i < [MTR count]; i++) {
        float mtrNow = [[MTR objectAtIndex:i] doubleValue];
        
        float trixNow = 0;
        float mtrOld = [[MTR objectAtIndex:i] doubleValue];
        if (i > 0) {
            mtrOld = [[MTR objectAtIndex:i - 1] doubleValue];
        }
        trixNow = (mtrNow - mtrOld) / mtrOld * 100;
        [TRIX addObject:[NSNumber numberWithFloat:trixNow]];
        
        
    }
    
    for (int i = 0 ; i < [TRIX count]; i++) {
        float matrixNow = 0;
        int count = 0;
        for (int j = i - TRIX_M + 1; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            matrixNow = matrixNow + [[TRIX objectAtIndex:j] doubleValue];
            count++;
        }
        matrixNow = matrixNow / count;
        [MATRIX addObject:[NSNumber numberWithFloat:matrixNow]];
    }
    
    
    
    return dict;
}

@synthesize BRAR_N;

- (NSMutableDictionary *)getBRARResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *BR = [[NSMutableArray alloc] init];
    NSMutableArray *AR = [[NSMutableArray alloc] init];
    
    [dict setObject:BR forKey:FXZBResult_BRAR_BR];
    [dict setObject:AR forKey:FXZBResult_BRAR_AR];
    
    for (int i = 0 ; i < [array count]; i++) {
        float BR1 = 0;
        float BR2 = 0;
        float AR1 = 0;
        float AR2 = 0;
        int start = 0;
        if (BRAR_N > 0) {
            start = i - BRAR_N + 1;
        }
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            ChartFXDataModel *klm = [array objectAtIndex:j];
            float oldClose = [klm.closePrice doubleValue];
            if (j > 0) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j - 1];
                oldClose = [klm2.closePrice doubleValue];
            }
            BR1 = BR1 + MAX(0, [klm.topPrice doubleValue] - oldClose);
            BR2 = BR2 + MAX(0, oldClose - [klm.bottomPrice doubleValue]);
            AR1 = AR1 + [klm.topPrice doubleValue] - [klm.openPrice doubleValue];
            AR2 = AR2 + [klm.openPrice doubleValue] - [klm.bottomPrice doubleValue];
            
        }
        float brNow = BR1 / BR2 * 100;
        [BR addObject:[NSNumber numberWithFloat:brNow]];
        float arNow = AR1 / AR2 * 100;
        [AR addObject:[NSNumber numberWithFloat:arNow]];
    }
    
    return dict;
}

@synthesize CR_N;
@synthesize CR_M1;
@synthesize CR_M2;
@synthesize CR_M3;
@synthesize CR_M4;

- (NSMutableDictionary *)getCRResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *CR = [[NSMutableArray alloc] init];
    NSMutableArray *MA1 = [[NSMutableArray alloc] init];
    NSMutableArray *MA2 = [[NSMutableArray alloc] init];
    NSMutableArray *MA3 = [[NSMutableArray alloc] init];
    NSMutableArray *MA4 = [[NSMutableArray alloc] init];
    NSMutableArray *MID = [[NSMutableArray alloc] init];
    NSMutableArray *MACR1 = [[NSMutableArray alloc] init];
    NSMutableArray *MACR2 = [[NSMutableArray alloc] init];
    NSMutableArray *MACR3 = [[NSMutableArray alloc] init];
    NSMutableArray *MACR4 = [[NSMutableArray alloc] init];
    
    [dict setObject:CR forKey:FXZBResult_CR_CR];
    [dict setObject:MA1 forKey:FXZBResult_CR_MA1];
    [dict setObject:MA2 forKey:FXZBResult_CR_MA2];
    [dict setObject:MA3 forKey:FXZBResult_CR_MA3];
    [dict setObject:MA4 forKey:FXZBResult_CR_MA4];
    
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        float midNow = ([klm.topPrice doubleValue] + [klm.bottomPrice doubleValue])/2;
        if (i > 0) {
            ChartFXDataModel *klm2 = [array objectAtIndex:i - 1];
            midNow = ([klm2.topPrice doubleValue] + [klm2.bottomPrice doubleValue])/2;
        }
        [MID addObject:[NSNumber numberWithFloat:midNow]];
        
        int start = 0;
        float cr1 = 0;
        float cr2 = 0;
        if (CR_N > 0) {
            start = i - CR_N + 1;
        }
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            ChartFXDataModel *klm3 = [array objectAtIndex:j];
            float midNum = [[MID objectAtIndex:j] doubleValue];
            cr1 = cr1 + MAX(0, ([klm3.topPrice doubleValue] - midNum));
            cr2 = cr2 + MAX(0, (midNum - [klm3.bottomPrice doubleValue]));
        }
        float crNow = cr1 / cr2 * 100;
        [CR addObject:[NSNumber numberWithFloat:crNow]];
        
        start = i - CR_M1 + 1;
        int count = 0;
        float crNum = 0;
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
            count++;
        }
        crNum = crNum / count;
        [MACR1 addObject:[NSNumber numberWithFloat:crNum]];
        
        start = i - CR_M2 + 1;
        count = 0;
        crNum = 0;
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
            count++;
        }
        crNum = crNum / count;
        [MACR2 addObject:[NSNumber numberWithFloat:crNum]];
        
        start = i - CR_M3 + 1;
        count = 0;
        crNum = 0;
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
            count++;
        }
        crNum = crNum / count;
        [MACR3 addObject:[NSNumber numberWithFloat:crNum]];
        
        start = i - CR_M4 + 1;
        count = 0;
        crNum = 0;
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
            count++;
        }
        crNum = crNum / count;
        [MACR4 addObject:[NSNumber numberWithFloat:crNum]];
        
        float mNum = [[MACR1 objectAtIndex:i] doubleValue];
        int d = CR_M1 / 2.5;
        if (i > d) {
            mNum = [[MACR1 objectAtIndex:i - d - 1] doubleValue];
        }
        [MA1 addObject:[NSNumber numberWithFloat:mNum]];
        
        mNum = [[MACR2 objectAtIndex:i] doubleValue];
        d = CR_M2 / 2.5;
        if (i > d) {
            mNum = [[MACR2 objectAtIndex:i - d - 1] doubleValue];
        }
        [MA2 addObject:[NSNumber numberWithFloat:mNum]];
        
        mNum = [[MACR3 objectAtIndex:i] doubleValue];
        d = CR_M3 / 2.5;
        if (i > d) {
            mNum = [[MACR3 objectAtIndex:i - d - 1] doubleValue];
        }
        [MA3 addObject:[NSNumber numberWithFloat:mNum]];
        
        mNum = [[MACR4 objectAtIndex:i] doubleValue];
        d = CR_M4 / 2.5;
        if (i > d) {
            mNum = [[MACR4 objectAtIndex:i - d - 1] doubleValue];
        }
        [MA4 addObject:[NSNumber numberWithFloat:mNum]];
        
    }
    return dict;
}

@synthesize VR_N;
@synthesize VR_M;

- (NSMutableDictionary *)getVRResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *VR = [[NSMutableArray alloc] init];
    NSMutableArray *MAVR = [[NSMutableArray alloc] init];
    
    [dict setObject:VR forKey:FXZBResult_VR_VR];
    [dict setObject:MAVR forKey:FXZBResult_VR_MAVR];
    for (int i = 0 ; i < [array count]; i++) {
        int start = 0 ;
        float thNum = 0;
        float tlNum = 0;
        float tqNum = 0;
        if (VR_N > 0) {
            start = i - VR_N + 1;
            for (int j = start; j <= i ; j++) {
                if (j < 0) {
                    continue;
                }
                ChartFXDataModel *klm = [array objectAtIndex:j];
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                if (j > 0) {
                    klm2 = [array objectAtIndex:j - 1];
                }
                if ([klm.closePrice doubleValue] > [klm2.closePrice doubleValue]) {
                    thNum = thNum + [klm.volume doubleValue];
                }else if ([klm.closePrice doubleValue] < [klm2.closePrice doubleValue]){
                    tlNum = tlNum + [klm.volume doubleValue];
                }else{
                    tqNum = tqNum + [klm.volume doubleValue];
                }
            }
            float vrNum = 100 * (thNum * 2 + tqNum) / (tlNum * 2 + tqNum);
            [VR addObject:[NSNumber numberWithFloat:vrNum]];
            
            float mavrNum = 0;
            if (VR_M != 0) {
                float count = 0;
                start = i - VR_M + 1;
                for (int j = start; j <= i ; j++) {
                    if (j < 0) {
                        continue;
                    }
                    mavrNum = mavrNum + [[VR objectAtIndex:j] doubleValue];
                    count++;
                }
                mavrNum = mavrNum / count;
            }
            [MAVR addObject:[NSNumber numberWithFloat:mavrNum]];
        }
    
    }
    
    
    return dict;
}

@synthesize OBV_M;
- (NSMutableDictionary *)getOBVResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *OBV = [[NSMutableArray alloc] init];
    NSMutableArray *MAOBV = [[NSMutableArray alloc] init];
    NSMutableArray *VA = [[NSMutableArray alloc] init];
    
    [dict setObject:OBV forKey:FXZBResult_OBV_OBV];
    [dict setObject:MAOBV forKey:FXZBResult_OBV_MAOBV];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        
        float vaNum = [klm.volume doubleValue];
        if ([klm2.closePrice doubleValue] > [klm.closePrice doubleValue]) {
            vaNum = 0 - [klm.volume doubleValue];
        }
        [VA addObject:[NSNumber numberWithFloat:vaNum]];
        
        float obvNum = 0;
        for (int j = 0 ; j <= i ; j++) {
            ChartFXDataModel *klm3 = [array objectAtIndex:j];
            ChartFXDataModel *klm4 = [array objectAtIndex:j];
            if (j > 0) {
                klm4 = [array objectAtIndex:j - 1];
            }
            if ([klm3.closePrice doubleValue] == [klm4.closePrice doubleValue]) {
                obvNum = obvNum + 0 ;
            }else{
                obvNum = obvNum + [[VA objectAtIndex:j] doubleValue];
            }
        }
        [OBV addObject:[NSNumber numberWithFloat:obvNum]];
        
        int count = 0;
        float maobvNum = 0;
        for (int x = i - OBV_M + 1 ; x <= i ; x++) {
            if (x < 0) {
                continue;
            }
            maobvNum = maobvNum + [[OBV objectAtIndex:x] doubleValue];
            count++;
        }
        maobvNum = maobvNum / count;
        [MAOBV addObject:[NSNumber numberWithFloat:maobvNum]];
        
    }
    
    return dict;
}

@synthesize ASI_M;
- (NSMutableDictionary *)getASIResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *ASI = [[NSMutableArray alloc] init];
    NSMutableArray *MAASI = [[NSMutableArray alloc] init];
    NSMutableArray *SI = [[NSMutableArray alloc] init];
    
    [dict setObject:ASI forKey:FXZBResult_ASI_ASI];
    [dict setObject:MAASI forKey:FXZBResult_ASI_MAASI];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        float lcNum = [klm2.closePrice doubleValue];
        float aaNum = fabsf([klm.topPrice doubleValue] - lcNum);
        float bbNum = fabsf([klm.bottomPrice doubleValue] - lcNum);
        float ccNum = fabsf([klm.topPrice doubleValue] - [klm2.bottomPrice doubleValue]);
        float ddNum = fabsf(lcNum - [klm2.openPrice doubleValue]);
        float rNum = 0;
        if (aaNum > bbNum && aaNum > ccNum) {
            rNum = aaNum + bbNum / 2 + ddNum / 4;
        }else if (bbNum > ccNum && bbNum > aaNum){
            rNum = bbNum + aaNum / 2 + ddNum / 4;
        }else{
            rNum = ccNum + ddNum / 4;
        }
        float xNum = ([klm.closePrice doubleValue] - lcNum + ([klm.closePrice doubleValue] - [klm.openPrice doubleValue]) / 2 + lcNum - [klm2.openPrice doubleValue]);
        float siNum = 8 * xNum / rNum * MAX(aaNum, bbNum);
        [SI addObject:[NSNumber numberWithFloat:siNum]];
        
        float asiNum = 0;
        for (int j = 0; j <= i; j++) {
            asiNum = asiNum + [[SI objectAtIndex:j] doubleValue];
        }
        [ASI addObject:[NSNumber numberWithFloat:asiNum]];
        
        int count = 0;
        float maasiNum = 0;
        for (int x = i - ASI_M + 1 ; x <= i ; x++) {
            if (x < 0) {
                continue;
            }
            maasiNum = maasiNum + [[ASI objectAtIndex:x] doubleValue];
            count++;
        }
        maasiNum = maasiNum / count;
        [MAASI addObject:[NSNumber numberWithFloat:maasiNum]];
        
    }
    
    return dict;
}

@synthesize EMV_N;
@synthesize EMV_M;
- (NSMutableDictionary *)getEMVResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *EMV = [[NSMutableArray alloc] init];
    NSMutableArray *MAEMV = [[NSMutableArray alloc] init];
    NSMutableArray *VOL = [[NSMutableArray alloc] init];
    NSMutableArray *MID = [[NSMutableArray alloc] init];
    
    [dict setObject:EMV forKey:FXZBResult_EMV_EMV];
    [dict setObject:MAEMV forKey:FXZBResult_EMV_MAEMV];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        float volNum = 0;
        int count = 0;
        for (int j = i - EMV_N + 1; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            ChartFXDataModel *klm3 = [array objectAtIndex:j];
            volNum = volNum + [klm3.volume doubleValue];
            count++;
        }
        volNum = volNum / count / [klm.volume doubleValue];
        [VOL addObject:[NSNumber numberWithFloat:volNum]];
        
        float midNum = 100 * ([klm.topPrice doubleValue] + [klm.bottomPrice doubleValue] - ([klm2.topPrice doubleValue] + [klm2.bottomPrice doubleValue])) / ([klm.topPrice doubleValue] + [klm.bottomPrice doubleValue]);
        [MID addObject:[NSNumber numberWithFloat:midNum]];
        
        count = 0;
        float emvNum1 = 0;
        for (int j = i - EMV_N + 1; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            ChartFXDataModel *klm3 = [array objectAtIndex:j];
            emvNum1 = emvNum1 +  [klm3.topPrice doubleValue] - [klm3.bottomPrice doubleValue];
            count++;
        }
        emvNum1 = emvNum1 / count;
        
        count = 0;
        float emvNum = 0;
        for (int j = i - EMV_N + 1; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            float midNow = [[MID objectAtIndex:j] doubleValue];
            float volNow = [[VOL objectAtIndex:j] doubleValue];
            ChartFXDataModel *klm3 = [array objectAtIndex:j];
            emvNum = emvNum + midNow * volNow * ([klm3.topPrice doubleValue] - [klm3.bottomPrice doubleValue]) / emvNum1;
            count++;
        }
        emvNum = emvNum / count;
        [EMV addObject:[NSNumber numberWithFloat:emvNum]];
        
        count = 0;
        float maemvNum = 0;
        for (int j = i - EMV_M + 1; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            float emvNow = [[EMV objectAtIndex:j] doubleValue];
            maemvNum = maemvNum + emvNow;
            count++;
        }
        maemvNum = maemvNum / count;
        [MAEMV addObject:[NSNumber numberWithFloat:maemvNum]];
        
    }
    
    return dict;
}

@synthesize RSI_N1;
@synthesize RSI_N2;
@synthesize RSI_N3;
- (NSMutableDictionary *)getRSIResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *RSI1 = [[NSMutableArray alloc] init];
    NSMutableArray *RSI2 = [[NSMutableArray alloc] init];
    NSMutableArray *RSI3 = [[NSMutableArray alloc] init];
    
    NSMutableArray *RSI11 = [[NSMutableArray alloc] init];
    NSMutableArray *RSI21 = [[NSMutableArray alloc] init];
    NSMutableArray *RSI31 = [[NSMutableArray alloc] init];
    
    NSMutableArray *RSI12 = [[NSMutableArray alloc] init];
    NSMutableArray *RSI22 = [[NSMutableArray alloc] init];
    NSMutableArray *RSI32 = [[NSMutableArray alloc] init];
    
    
    [dict setObject:RSI1 forKey:FXZBResult_RSI_RSI1];
    [dict setObject:RSI2 forKey:FXZBResult_RSI_RSI2];
    [dict setObject:RSI3 forKey:FXZBResult_RSI_RSI3];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        float lcNum = [klm2.closePrice doubleValue];
        
        float rsi11Old = 0;
        float rsi21Old = 0;
        float rsi31Old = 0;
        
        float rsi12Old = 0;
        float rsi22Old = 0;
        float rsi32Old = 0;
        if (i > 0) {
            rsi11Old = [[RSI11 objectAtIndex:i - 1] doubleValue];
            rsi21Old = [[RSI21 objectAtIndex:i - 1] doubleValue];
            rsi31Old = [[RSI31 objectAtIndex:i - 1] doubleValue];
            
            rsi12Old = [[RSI12 objectAtIndex:i - 1] doubleValue];
            rsi22Old = [[RSI22 objectAtIndex:i - 1] doubleValue];
            rsi32Old = [[RSI32 objectAtIndex:i - 1] doubleValue];
        }
        float rsi11Now = (MAX([klm.closePrice doubleValue] - lcNum, 0) + rsi11Old * (RSI_N1 - 1)) / RSI_N1;
        float rsi21Now = (MAX([klm.closePrice doubleValue] - lcNum, 0) + rsi21Old * (RSI_N2 - 1)) / RSI_N2;
        float rsi31Now = (MAX([klm.closePrice doubleValue] - lcNum, 0) + rsi31Old * (RSI_N3 - 1)) / RSI_N3;
        [RSI11 addObject:[NSNumber numberWithFloat:rsi11Now]];
        [RSI21 addObject:[NSNumber numberWithFloat:rsi21Now]];
        [RSI31 addObject:[NSNumber numberWithFloat:rsi31Now]];
        
        float rsi12Now = (fabs([klm.closePrice doubleValue] - lcNum) + rsi12Old * (RSI_N1 - 1)) / RSI_N1;
        float rsi22Now = (fabs([klm.closePrice doubleValue] - lcNum) + rsi22Old * (RSI_N2 - 1)) / RSI_N2;
        float rsi32Now = (fabs([klm.closePrice doubleValue] - lcNum) + rsi32Old * (RSI_N3 - 1)) / RSI_N3;
        [RSI12 addObject:[NSNumber numberWithFloat:rsi12Now]];
        [RSI22 addObject:[NSNumber numberWithFloat:rsi22Now]];
        [RSI32 addObject:[NSNumber numberWithFloat:rsi32Now]];
        
        float rsi1Num = rsi11Now / rsi12Now * 100;
        float rsi2Num = rsi21Now / rsi22Now * 100;
        float rsi3Num = rsi31Now / rsi32Now * 100;
        [RSI1 addObject:[NSNumber numberWithFloat:rsi1Num]];
        [RSI2 addObject:[NSNumber numberWithFloat:rsi2Num]];
        [RSI3 addObject:[NSNumber numberWithFloat:rsi3Num]];
    }
    return dict;
}

@synthesize WR_N;
@synthesize WR_N1;
- (NSMutableDictionary *)getWRResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *WR1 = [[NSMutableArray alloc] init];
    NSMutableArray *WR2 = [[NSMutableArray alloc] init];
    
    
    [dict setObject:WR1 forKey:FXZBResult_WR_WR1];
    [dict setObject:WR2 forKey:FXZBResult_WR_WR2];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        float hhv1Num = -1000000;
        float hhv2Num = -1000000;
        float llv1Num = 1000000;
        float llv2Num = 1000000;
        
        int start = 0;
        if (WR_N > 0) {
            start = i - WR_N + 1;
        }
        for (int j = start; j <= i ; j++) {
            if (j < 0) {
                continue;
            }
            ChartFXDataModel *klm2 = [array objectAtIndex:j];
            if ([klm2.topPrice doubleValue] > hhv1Num) {
                hhv1Num = [klm2.topPrice doubleValue];
            }
            
            if ([klm2.bottomPrice doubleValue] < llv1Num) {
                llv1Num = [klm2.bottomPrice doubleValue];
            }
        }
        
        start = 0;
        if (WR_N1 > 0) {
            start = i - WR_N1 + 1;
        }
        for (int j = start; j <= i ; j++) {
            if (j < 0) {
                continue;
            }
            ChartFXDataModel *klm2 = [array objectAtIndex:j];
            if ([klm2.topPrice doubleValue] > hhv2Num) {
                hhv2Num = [klm2.topPrice doubleValue];
            }
            
            if ([klm2.bottomPrice doubleValue] < llv2Num) {
                llv2Num = [klm2.bottomPrice doubleValue];
            }
        }
        
        float wr1Num = 100 * (hhv1Num - [klm.closePrice doubleValue]) / (hhv1Num - llv1Num);
        
        [WR1 addObject:[NSNumber numberWithFloat:chartValid(wr1Num)]];
        
        float wr2Num = 100 * (hhv2Num - [klm.closePrice doubleValue]) / (hhv2Num - llv2Num);
        
        [WR2 addObject:[NSNumber numberWithFloat:chartValid(wr2Num)]];
    }
    return dict;
    
}

@synthesize CCI_N;
- (NSMutableDictionary *)getCCIResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *CCI = [[NSMutableArray alloc] init];
    NSMutableArray *TYP = [[NSMutableArray alloc] init];
    
    
    [dict setObject:CCI forKey:FXZBResult_CCI_CCI];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        float typNum = ([klm.topPrice doubleValue] + [klm.bottomPrice doubleValue] + [klm.closePrice doubleValue]) / 3;
        [TYP addObject:[NSNumber numberWithFloat:typNum]];
        
        float avedevNum = 0;
        int start = 0;
        if (CCI_N > 0) {
            start = i - CCI_N + 1;
        }
        int avedevCount = 0;
        for (int j = start ; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            avedevNum = avedevNum + [[TYP objectAtIndex:j] doubleValue];
            avedevCount++;
        }
        avedevNum = avedevNum / avedevCount;
        float avedevNow = 0;
        avedevCount = 0;
        for (int j = start ; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            avedevNow = avedevNow + fabsf([[TYP objectAtIndex:j] doubleValue] - avedevNum);
            avedevCount++;
        }
        avedevNow = avedevNow / avedevCount;
        
        float cciNum = (typNum - avedevNum) / (0.015 * avedevNow);
        [CCI addObject:[NSNumber numberWithFloat:cciNum]];
    }
    return dict;
}

@synthesize ROC_N;
@synthesize ROC_M;
- (NSMutableDictionary *)getROCResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *ROC = [[NSMutableArray alloc] init];
    NSMutableArray *MAROC = [[NSMutableArray alloc] init];
    
    
    [dict setObject:ROC forKey:FXZBResult_ROC_ROC];
    [dict setObject:MAROC forKey:FXZBResult_ROC_MAROC];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:0];
        if (i >= ROC_N) {
            klm2 = [array objectAtIndex:i - ROC_N];
        }
        float rocNum = 100 * ([klm.closePrice doubleValue] - [klm2.closePrice doubleValue]) / [klm2.closePrice doubleValue];
        [ROC addObject:[NSNumber numberWithFloat:rocNum]];
        
        int start = 0;
        int count = 0;
        float marocNum = 0;
        if (ROC_M > 0) {
            start = i - ROC_M + 1;
        }
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            marocNum = marocNum + [[ROC objectAtIndex:j] doubleValue];
            count++;
        }
        marocNum = marocNum / count;
        [MAROC addObject:[NSNumber numberWithFloat:marocNum]];
    }
    return dict;
}

@synthesize MTM_N;
@synthesize MTM_M;
- (NSMutableDictionary *)getMTMResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *MTM = [[NSMutableArray alloc] init];
    NSMutableArray *MAMTM = [[NSMutableArray alloc] init];
    
    
    [dict setObject:MTM forKey:FXZBResult_MTM_MTM];
    [dict setObject:MAMTM forKey:FXZBResult_MTM_MAMTM];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:0];
        if (i >= MTM_N) {
            klm2 = [array objectAtIndex:i - MTM_N];
        }
        float mtmNum = ([klm.closePrice doubleValue] - [klm2.closePrice doubleValue]);
        [MTM addObject:[NSNumber numberWithFloat:mtmNum]];
        
        int start = 0;
        int count = 0;
        float mamtmNum = 0;
        if (MTM_M > 0) {
            start = i - MTM_M + 1;
        }
        for (int j = start; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            mamtmNum = mamtmNum + [[MTM objectAtIndex:j] doubleValue];
            count++;
        }
        mamtmNum = mamtmNum / count;
        [MAMTM addObject:[NSNumber numberWithFloat:mamtmNum]];
    }
    /*
     MTM:CLOSE-REF(CLOSE,N);
     MTMMA:MA(MTM,M);
     */
    return dict;
}

@synthesize BIAS_N1;
@synthesize BIAS_N2;
@synthesize BIAS_N3;
- (NSMutableDictionary *)getBIASResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *BIAS1 = [[NSMutableArray alloc] init];
    NSMutableArray *BIAS2 = [[NSMutableArray alloc] init];
    NSMutableArray *BIAS3 = [[NSMutableArray alloc] init];
    
    
    [dict setObject:BIAS1 forKey:FXZBResult_BIAS_BIAS1];
    [dict setObject:BIAS2 forKey:FXZBResult_BIAS_BIAS2];
    [dict setObject:BIAS3 forKey:FXZBResult_BIAS_BIAS3];
    for (int i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float price = 0;
        int count = 0;
        for ( int j = i - BIAS_N1 + 1; j <= i; j++) {
            if (j >= 0 ) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                count++;
                price = price + [klm2.closePrice doubleValue];
            }
        }
        price = price / count;
        if (price == 0) {
            [BIAS1 addObject:[NSNumber numberWithFloat:0]];
        }else{
            price = ([klm.closePrice doubleValue] - price) / price * 100;
            [BIAS1 addObject:[NSNumber numberWithFloat:price]];
        }
        
        
        price = 0;
        count = 0;
        for ( int j = i - BIAS_N2 + 1; j <= i; j++) {
            if (j >= 0 ) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                count++;
                price = price + [klm2.closePrice doubleValue];
            }
        }
        price = price / count;
        if (price == 0) {
            [BIAS2 addObject:[NSNumber numberWithFloat:0]];
        }else{
            price = ([klm.closePrice doubleValue] - price) / price * 100;
            [BIAS2 addObject:[NSNumber numberWithFloat:price]];
        }
        
        price = 0;
        count = 0;
        for ( int j = i - BIAS_N3 + 1; j <= i; j++) {
            if (j >= 0 ) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                count++;
                price = price + [klm2.closePrice doubleValue];
            }
        }
        price = price / count;
        if (price == 0) {
            [BIAS3 addObject:[NSNumber numberWithFloat:0]];
        }else{
            price = ([klm.closePrice doubleValue] - price) / price * 100;
            [BIAS3 addObject:[NSNumber numberWithFloat:price]];
        }
        
        
        
//        if (i >= MTM_N) {
//            klm2 = [array objectAtIndex:i - MTM_N];
//        }
//        float mtmNum = ([klm.closePrice doubleValue] - [klm2.closePrice doubleValue]);
//        [MTM addObject:[NSNumber numberWithFloat:mtmNum]];
//        
//        int start = 0;
//        int count = 0;
//        float mamtmNum = 0;
//        if (MTM_M > 0) {
//            start = i - MTM_M + 1;
//        }
//        for (int j = start; j <= i; j++) {
//            if (j < 0) {
//                continue;
//            }
//            mamtmNum = mamtmNum + [[MTM objectAtIndex:j] doubleValue];
//            count++;
//        }
//        mamtmNum = mamtmNum / count;
//        [MAMTM addObject:[NSNumber numberWithFloat:mamtmNum]];
    }
    /*
     MTM:CLOSE-REF(CLOSE,N);
     MTMMA:MA(MTM,M);
     */
    return dict;
}

@synthesize BOLL_M;
- (NSMutableDictionary *)getBOLLResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *BOLL = [[NSMutableArray alloc] init];
    NSMutableArray *UB = [[NSMutableArray alloc] init];
    NSMutableArray *LB = [[NSMutableArray alloc] init];
    
    
    [dict setObject:BOLL forKey:FXZBResult_BOLL_BOLL1];
    [dict setObject:UB forKey:FXZBResult_BOLL_BOLL2];
    [dict setObject:LB forKey:FXZBResult_BOLL_BOLL3];
    
    for (int i = 0 ; i < array.count; i++) {
        float num = 0;
        if (i >= BOLL_M - 1) {
            for (int j = i - BOLL_M + 1 ; j <= i; j++) {
                ChartFXDataModel *model = [array objectAtIndex:j];
                num = num + [model.closePrice doubleValue];
            }
        }
        [BOLL addObject:[NSNumber numberWithFloat:num / BOLL_M]];
        
        float num2 = 0;
        if (i >= BOLL_M - 1) {
            for (int j = i - BOLL_M + 1 ; j <= i; j++) {
                ChartFXDataModel *model = [array objectAtIndex:j];
                num2 = num2 + pow([model.closePrice doubleValue] - num / BOLL_M , 2);
            }
        }
        [UB addObject:[NSNumber numberWithFloat:num / BOLL_M + 2 * sqrtf(num2 / BOLL_M)]];
        [LB addObject:[NSNumber numberWithFloat:num / BOLL_M - 2 * sqrtf(num2 / BOLL_M)]];
    }
    return dict;
}

@synthesize AROON_N;
- (NSMutableDictionary*)getAROONResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *H = [[NSMutableArray alloc] init];
    NSMutableArray *L = [[NSMutableArray alloc] init];
    
    
    [dict setObject:H forKey:FXZBResult_AROON_H];
    [dict setObject:L forKey:FXZBResult_AROON_L];
    
    for (int i = 0 ; i < array.count; i++) {
        float maxNum = 0;
        int maxI = 0;
        float minNum = MAXFLOAT;
        int minI = 0;
        for (int j = i - AROON_N + 1 ; j <= i; j++) {
            if (j >= 0) {
                ChartFXDataModel *model = [array objectAtIndex:j];
                if ([model.topPrice doubleValue] > maxNum) {
                    maxNum = [model.topPrice doubleValue];
                    maxI = i - j;
                }
                if ([model.topPrice doubleValue] < minNum) {
                    minNum = [model.topPrice doubleValue];
                    minI = i - j;
                }
            }
        }
        [H addObject:@((AROON_N - maxI) / AROON_N * 100.0f)];
        [L addObject:@((AROON_N - minI) / AROON_N * 100.0f)];
    }
    return dict;
}

//@synthesize CYZB_Value;
//- (NSMutableDictionary*)getCYZBResult:(NSMutableArray *)array datas:(NSMutableArray *)datas{
//    NSMutableDictionary *dict;
//    dict = [[NSMutableDictionary alloc] init];
//
//    NSMutableArray *Values = [[NSMutableArray alloc] init];
//
//
//    [dict setObject:Values forKey:FXZBResult_CYZB_Values];
//
//    NSString *tmp = @"0";
//    for (int i = 0 ; i < datas.count; i++) {
//        NSString *value = @"0";
//        FXDataModel *model1 = [datas objectAtIndex:i];
//        for (int j = 0; j < array.count; j++) {
//            cyzbModel *model2 = [array objectAtIndex:j];
//            if ([model2[kStr_CYZB_Date] isEqual:model1[kStr_FX_Date]] && [model2[kStr_CYZB_Time] isEqual:model1[kStr_FX_Time]]) {
//                value = model2[kStr_CYZB_Value];
//                break;
//            }
//        }
//        if ([value isEqual:tmp]) {
//            value = @"0";
//        }
//        if (![value isEqual:@"0"]) {
//            tmp = value;
//        }
//        [Values addObject:value];
//
//    }
//    return dict;
//}
@end
