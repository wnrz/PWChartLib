//
//  ZBParam.m
//  socketTest
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PWFXZBParam.h"
#import "ChartTools.h"
#import "PWChartColors.h"

@implementation PWFXZBParam
@synthesize VOL_MAS;
@synthesize Pri_MAS;

static PWFXZBParam* shareZBP=nil;
+(PWFXZBParam*)shareFXZBParam{
    //同步防止多线程访问,这里本来想用instance来作为锁对象的，但是当instance为nil的时候不能作为锁对象
    @synchronized(self){
        if (!shareZBP) {
            shareZBP= [[PWFXZBParam alloc] init];
            shareZBP.VOL_MAS = @[@5,@10,@20];//,@20,@60
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
            
            shareZBP.ASI_M1 = 26;
            shareZBP.ASI_M2 = 10;
            
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
            
            shareZBP.PSY_N = 12;
            shareZBP.PSY_M = 6;
            
            shareZBP.MTM_N = 12;
            shareZBP.MTM_M = 6;
            
            shareZBP.BIAS_N1 = 6;
            shareZBP.BIAS_N2 = 12;
            shareZBP.BIAS_N3 = 24;
            
            shareZBP.BOLL_M = 20.0f;
            shareZBP.BOLL_N = 2.0f;
            
            shareZBP.AROON_N = 25.0f;
        }
    }
    
    return shareZBP;
}

#pragma mark -主图指标
//主图指标
- (NSMutableDictionary *)getPriMAResult:(NSMutableArray *)array{
    NSMutableDictionary *mas;
    /*
     @{@"sName":NAME,
     @"linesArray":@[@{@"sName":name,@"type":type,@"mArrBe":@{@"linesArray":@[]}}]
     }
     */
    mas = [[NSMutableDictionary alloc] init];
    NSString *time = @"";
    for (NSInteger x = 0 ; x < Pri_MAS.count; x++) {
        NSInteger ma = [Pri_MAS[x] intValue];
        time.length > 0 ? time = [time stringByAppendingString:@","] : 0;
        time = [time stringByAppendingFormat:@"%.0ld" , (long)ma];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        for (NSInteger x = 0 ; x < Pri_MAS.count; x++) {
            NSInteger ma = [Pri_MAS[x] intValue];
            if (ma > 0) {
                NSMutableArray *tmpArray = mas[[NSString stringWithFormat:@"%@" , @(ma)]];
                if (!tmpArray) {
                    tmpArray = [[NSMutableArray alloc] init];
                    [mas setObject:tmpArray forKey:[NSString stringWithFormat:@"%@" , @(ma)]];
                }
                if (i >= ma - 1) {
                    float price = 0.0f;
                    for (NSInteger j = i - (ma - 1); j <= i ; j++) {
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
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"MA(%@)" , time] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [Pri_MAS enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [NSString stringWithFormat:@"%@" , obj];
        
        NSMutableDictionary *zbDict = [[NSMutableDictionary alloc] init];
        [zbDict setObject:@"0" forKey:@"type"];
        [zbDict setObject:[NSString stringWithFormat:@"MA%@" , key] forKey:@"sName"];
        [zbDict setObject:mas[key] forKey:@"linesArray"];
        [zbDict setObject:@([key integerValue] - 1) forKey:@"start"];
        [arr addObject:zbDict];
    }];
//    [mas enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSMutableDictionary *zbDict = [[NSMutableDictionary alloc] init];
//        [zbDict setObject:@"0" forKey:@"type"];
//        [zbDict setObject:[NSString stringWithFormat:@"MA%@" , key] forKey:@"sName"];
//        [zbDict setObject:obj forKey:@"linesArray"];
//        [zbDict setObject:@([key integerValue] - 1) forKey:@"start"];
//        [arr addObject:zbDict];
//    }];
    
    return result;
}

#pragma mark -幅图指标
//幅图指标
- (NSMutableDictionary *)getVOLMAResult:(NSMutableArray *)array{
    NSMutableDictionary *vols;
    vols = [[NSMutableDictionary alloc] init];
    NSString *time = @"";
    for (NSInteger x = 0 ; x < VOL_MAS.count; x++) {
        NSInteger ma = [VOL_MAS[x] intValue];
        time.length > 0 ? time = [time stringByAppendingString:@","] : 0;
        time = [time stringByAppendingFormat:@"%.0ld" , (long)ma];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        for (NSInteger x = 0 ; x < VOL_MAS.count; x++) {
            NSInteger ma = [VOL_MAS[x] intValue];
            if (ma > 0) {
                NSMutableArray *tmpArray = vols[[NSString stringWithFormat:@"%@" , @(ma)]];
                if (!tmpArray) {
                    tmpArray = [[NSMutableArray alloc] init];
                    [vols setObject:tmpArray forKey:[NSString stringWithFormat:@"%@" , @(ma)]];
                }
                if (i >= ma - 1) {
                    float price = 0.0f;
                    for (NSInteger j = i - (ma - 1); j <= i ; j++) {
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
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"MA(%@)" , time] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [VOL_MAS enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [NSString stringWithFormat:@"%@" , obj];
        
        NSMutableDictionary *zbDict = [[NSMutableDictionary alloc] init];
        [zbDict setObject:@"0" forKey:@"type"];
        [zbDict setObject:[NSString stringWithFormat:@"MA%@" , key] forKey:@"sName"];
        [zbDict setObject:vols[key] forKey:@"linesArray"];
        [zbDict setObject:@([key integerValue] - 1) forKey:@"start"];
        [arr addObject:zbDict];
    }];
//    [vols enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSMutableDictionary *zbDict = [[NSMutableDictionary alloc] init];
//        [zbDict setObject:@"0" forKey:@"type"];
//        [zbDict setObject:[NSString stringWithFormat:@"MA%@" , key] forKey:@"sName"];
//        [zbDict setObject:obj forKey:@"linesArray"];
//        [zbDict setObject:@([key integerValue] - 1) forKey:@"start"];
//        [arr addObject:zbDict];
//    }];
    
    return result;
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float ema1 = 0;
        float ema1Old = 0;
        float ema2 = 0;
        float ema2Old = 0;
        float emaDea = 0;
        float emaDeaOld = 0;
        if (i > 0) {
            ema1Old = [[ema1array objectAtIndex:i - 1] doubleValue];
            ema2Old = [[ema2array objectAtIndex:i - 1] doubleValue];
            emaDeaOld = [[emaDeaArray objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * [klm.closePrice doubleValue] + ema1Old * (MACD_Short - 1))/(MACD_Short + 1);
            ema2 = (2 * [klm.closePrice doubleValue] + ema2Old * (MACD_Long - 1))/(MACD_Long + 1);
            emaDea = (2 * (ema1 - ema2) + emaDeaOld * (MACD_Mid - 1))/(MACD_Mid + 1);
        }else{
//            ema1Old = [klm.closePrice doubleValue];
//            ema2Old = [klm.closePrice doubleValue];
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float ema1;
        float ema1Old;
        float ema2;
        float ema2Old;
        float emaDea;
        float emaDeaOld;
        if (i == 120){
            //            NSLog(@"");
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
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"MACD(%.0f,%.0f,%.0f)" , MACD_Short , MACD_Long , MACD_Mid] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"DIF" linesArray:dif start:@0 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"DEA" linesArray:dea start:@0 color:[PWChartColors drawColorByIndex:1]]];
    [arr addObject:[PWFXZBParam makeZBData:@6 sName:@"MACD" linesArray:macd start:@0 color:[PWChartColors drawColorByIndex:2]]];
    return result;
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
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
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
        
        if (isnan(rsv) || isinf(rsv)) {
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
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"KDJ(%.0f,%.0f,%.0f)" , KDJ_N , KDJ_M1 , KDJ_M2] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"K" linesArray:k start:@0 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"D" linesArray:d start:@0 color:[PWChartColors drawColorByIndex:1]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"J" linesArray:j start:@0 color:[PWChartColors drawColorByIndex:2]]];
    
    return result;
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
        NSInteger count = 0;
        float price1 = 0;
        float price2 = 0;
        float price3 = 0;
        for (NSInteger j = i - DMA_N1 + 1 ; j <= i; j++) {
            if (j >= 0) {
                ChartFXDataModel *klm2 = [array objectAtIndex:j];
                price1 = price1 + [klm2.closePrice doubleValue];
                count++;
            }
        }
        price1 = price1 / count;
        
        count = 0;
        for (NSInteger j = i - DMA_N2 + 1 ; j <= i; j++) {
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
        for (NSInteger j = i - DMA_M + 1 ; j <= i; j++) {
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
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
    
    for (NSInteger i = 0; i < 2; i++) {
        for (NSInteger x = 0 ; x < [MTR count]; x++) {
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
    
    for (NSInteger i = 0 ; i < [MTR count]; i++) {
        float mtrNow = [[MTR objectAtIndex:i] doubleValue];
        
        float trixNow = 0;
        float mtrOld = [[MTR objectAtIndex:i] doubleValue];
        if (i > 0) {
            mtrOld = [[MTR objectAtIndex:i - 1] doubleValue];
        }
        trixNow = (mtrNow - mtrOld) / mtrOld * 100;
        [TRIX addObject:[NSNumber numberWithFloat:trixNow]];
        
        
    }
    
    for (NSInteger i = 0 ; i < [TRIX count]; i++) {
        float matrixNow = 0;
        NSInteger count = 0;
        for (NSInteger j = i - TRIX_M + 1; j <= i; j++) {
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
        float BR1 = 0;
        float BR2 = 0;
        float AR1 = 0;
        float AR2 = 0;
        NSInteger start = 0;
        if (BRAR_N > 0) {
            start = i - BRAR_N + 1;
        }
        for (NSInteger j = start; j <= i; j++) {
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArr2 = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArr3 = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArr4 = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        float midNow = ([klm.topPrice doubleValue] + [klm.bottomPrice doubleValue])/2;
        if (i > 0) {
            ChartFXDataModel *klm2 = [array objectAtIndex:i - 1];
            midNow = ([klm2.topPrice doubleValue] + [klm2.bottomPrice doubleValue])/2;
        }
        [MID addObject:[NSNumber numberWithFloat:midNow]];
        
        NSInteger start = 0;
        float cr1 = 0;
        float cr2 = 0;
        if (CR_N > 0) {
            start = i - CR_N + 1;
        }
        for (NSInteger j = start; j <= i; j++) {
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
        
        [tmpArr addObject:@(crNow)];
        if (tmpArr.count > CR_M1) {
            [tmpArr removeObjectAtIndex:0];
        }
        double maNum = 0;
        if (tmpArr.count > 0 && tmpArr.count <= CR_M1) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            maNum = sum / tmpArr.count;
        }
        [MACR1 addObject:[NSNumber numberWithFloat:maNum]];
        
        //        start = i - CR_M1 + 1;
        //        NSInteger count = 0;
        //        float crNum = 0;
        //        for (NSInteger j = start; j <= i; j++) {
        //            if (j < 0) {
        //                continue;
        //            }
        //            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
        //            count++;
        //        }
        //        crNum = crNum / count;
        //        [MACR1 addObject:[NSNumber numberWithFloat:crNum]];
        
        
        [tmpArr2 addObject:@(crNow)];
        if (tmpArr2.count > CR_M2) {
            [tmpArr2 removeObjectAtIndex:0];
        }
        double maNum2 = 0;
        if (tmpArr2.count > 0 && tmpArr2.count <= CR_M2) {
            double sum = [[tmpArr2 valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            maNum2 = sum / tmpArr2.count;
        }
        [MACR2 addObject:[NSNumber numberWithFloat:maNum2]];
        //        start = i - CR_M2 + 1;
        //        count = 0;
        //        crNum = 0;
        //        for (NSInteger j = start; j <= i; j++) {
        //            if (j < 0) {
        //                continue;
        //            }
        //            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
        //            count++;
        //        }
        //        crNum = crNum / count;
        //        [MACR2 addObject:[NSNumber numberWithFloat:crNum]];
        
        
        [tmpArr3 addObject:@(crNow)];
        if (tmpArr3.count > CR_M3) {
            [tmpArr3 removeObjectAtIndex:0];
        }
        double maNum3 = 0;
        if (tmpArr3.count > 0 && tmpArr3.count <= CR_M3) {
            double sum = [[tmpArr3 valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            maNum3 = sum / tmpArr3.count;
        }
        [MACR3 addObject:[NSNumber numberWithFloat:maNum3]];
        //        start = i - CR_M3 + 1;
        //        count = 0;
        //        crNum = 0;
        //        for (NSInteger j = start; j <= i; j++) {
        //            if (j < 0) {
        //                continue;
        //            }
        //            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
        //            count++;
        //        }
        //        crNum = crNum / count;
        //        [MACR3 addObject:[NSNumber numberWithFloat:crNum]];
        
        
        [tmpArr4 addObject:@(crNow)];
        if (tmpArr4.count > CR_M4) {
            [tmpArr4 removeObjectAtIndex:0];
        }
        double maNum4 = 0;
        if (tmpArr4.count > 0 && tmpArr4.count <= CR_M4) {
            double sum = [[tmpArr4 valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            maNum4 = sum / tmpArr4.count;
        }
        [MACR4 addObject:[NSNumber numberWithFloat:maNum4]];
        
        //        start = i - CR_M4 + 1;
        //        count = 0;
        //        crNum = 0;
        //        for (NSInteger j = start; j <= i; j++) {
        //            if (j < 0) {
        //                continue;
        //            }
        //            crNum = crNum + [[CR objectAtIndex:j] doubleValue];
        //            count++;
        //        }
        //        crNum = crNum / count;
        //        [MACR4 addObject:[NSNumber numberWithFloat:crNum]];
        
        float mNum = [[MACR1 objectAtIndex:i] doubleValue];
        NSInteger d = CR_M1 / 2.5;
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        NSInteger start = 0 ;
        float thNum = 0;
        float tlNum = 0;
        float tqNum = 0;
        if (VR_N > 0) {
            start = i - VR_N + 1;
            for (NSInteger j = start; j <= i ; j++) {
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
            
            [tmpArr addObject:@(vrNum)];
            if (tmpArr.count > VR_M) {
                [tmpArr removeObjectAtIndex:0];
            }
            double maNum = 0;
            if (tmpArr.count > 0 && tmpArr.count <= VR_M) {
                double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
                maNum = sum / tmpArr.count;
            }
            [MAVR addObject:[NSNumber numberWithFloat:maNum]];
            
            //            float mavrNum = 0;
            //            if (VR_M != 0) {
            //                float count = 0;
            //                start = i - VR_M + 1;
            //                for (NSInteger j = start; j <= i ; j++) {
            //                    if (j < 0) {
            //                        continue;
            //                    }
            //                    mavrNum = mavrNum + [[VR objectAtIndex:j] doubleValue];
            //                    count++;
            //                }
            //                mavrNum = mavrNum / count;
            //            }
            //            [MAVR addObject:[NSNumber numberWithFloat:mavrNum]];
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        
        float vaNum = 0;
        if ([klm2.closePrice doubleValue] < [klm.closePrice doubleValue]) {
            vaNum = [klm.volume doubleValue];
        }else if ([klm2.closePrice doubleValue] > [klm.closePrice doubleValue]) {
            vaNum = 0 - [klm.volume doubleValue];
        }
        [VA addObject:[NSNumber numberWithFloat:vaNum]];
        
        float obvNum = 0;
        for (NSInteger j = 0 ; j <= i ; j++) {
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
        [tmpArr addObject:@(obvNum)];
        if (tmpArr.count > OBV_M) {
            [tmpArr removeObjectAtIndex:0];
        }
        if (tmpArr.count > 0 && tmpArr.count <= OBV_M) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            double maobvNum = sum / tmpArr.count;
            [MAOBV addObject:[NSNumber numberWithFloat:maobvNum]];
        }
        //            NSInteger count = 0;
        //            float maobvNum = 0;
        //            for (NSInteger x = i - OBV_M + 1 ; x <= i ; x++) {
        //                if (x < 0) {
        //                    continue;
        //                }
        //                maobvNum = maobvNum + [[OBV objectAtIndex:x] doubleValue];
        //                count++;
        //            }
        //            maobvNum = maobvNum / count;
        //            [MAOBV addObject:[NSNumber numberWithFloat:maobvNum]];
        
    }
    
    OBV = [ChartTools SUM:VA d:0 block:^double(double num, NSInteger index) {
        return num / 10000.0f;
    }];
    
    MAOBV = [ChartTools MA:OBV d:30 block:nil];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"OBV(%.0f)" , OBV_M] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"OBV" linesArray:OBV start:@0 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"MAOBV" linesArray:MAOBV start:@0 color:[PWChartColors drawColorByIndex:1]]];
    
    return result;
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        float lcNum = [klm2.closePrice doubleValue];
        float aaNum = fabs([klm.topPrice doubleValue] - lcNum);
        float bbNum = fabs([klm.bottomPrice doubleValue] - lcNum);
        float ccNum = fabs([klm.topPrice doubleValue] - [klm2.bottomPrice doubleValue]);
        float ddNum = fabs(lcNum - [klm2.openPrice doubleValue]);
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
        siNum = isnan(siNum) && SI.count > 0 ? [[SI lastObject] floatValue] : siNum;
        [SI addObject:[NSNumber numberWithFloat:siNum]];
        
        float asiNum = 0;
        for (NSInteger j = 0; j <= i; j++) {
            asiNum = asiNum + [[SI objectAtIndex:j] doubleValue];
        }
        [ASI addObject:[NSNumber numberWithFloat:asiNum]];
        
        [tmpArr addObject:@(asiNum)];
        if (tmpArr.count > ASI_M) {
            [tmpArr removeObjectAtIndex:0];
        }
        if (tmpArr.count > 0 && tmpArr.count <= ASI_M) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            double maasiNum = sum / tmpArr.count;
            [MAASI addObject:[NSNumber numberWithFloat:maasiNum]];
        }
        
        //            NSInteger count = 0;
        //            float maasiNum = 0;
        //            for (NSInteger x = i - ASI_M + 1 ; x <= i ; x++) {
        //                if (x < 0) {
        //                    continue;
        //                }
        //                maasiNum = maasiNum + [[ASI objectAtIndex:x] doubleValue];
        //                count++;
        //            }
        //            maasiNum = maasiNum / count;
        //            [MAASI addObject:[NSNumber numberWithFloat:maasiNum]];
        
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"ASI(%.0f)" , ASI_M] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"ASI" linesArray:ASI start:@0 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"MAASI" linesArray:MAASI start:@0 color:[PWChartColors drawColorByIndex:1]]];
    
    return result;
}

@synthesize ASI_M1;
@synthesize ASI_M2;
- (NSMutableDictionary *)getASI2Result:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *ASI = [[NSMutableArray alloc] init];
    NSMutableArray *MAASI = [[NSMutableArray alloc] init];
    NSMutableArray *SI = [[NSMutableArray alloc] init];
    
    [dict setObject:ASI forKey:FXZBResult_ASI_ASI];
    [dict setObject:MAASI forKey:FXZBResult_ASI_MAASI];
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        float lcNum = [klm2.closePrice doubleValue];
        float aaNum = fabs([klm.topPrice doubleValue] - lcNum);
        float bbNum = fabs([klm.bottomPrice doubleValue] - lcNum);
        float ccNum = fabs([klm.topPrice doubleValue] - [klm2.bottomPrice doubleValue]);
        float ddNum = fabs(lcNum - [klm2.openPrice doubleValue]);
        float rNum = 0;
        if (aaNum > bbNum && aaNum > ccNum) {
            rNum = aaNum + bbNum / 2 + ddNum / 4;
        }else if (bbNum > ccNum && bbNum > aaNum){
            rNum = bbNum + aaNum / 2 + ddNum / 4;
        }else{
            rNum = ccNum + ddNum / 4;
        }
        float xNum = ([klm.closePrice doubleValue] - lcNum + ([klm.closePrice doubleValue] - [klm.openPrice doubleValue]) / 2 + lcNum - [klm2.openPrice doubleValue]);
        float siNum = 16 * xNum / rNum * MAX(aaNum, bbNum);
        siNum = isnan(siNum) && SI.count > 0 ? [[SI lastObject] floatValue] : siNum;
        siNum = isnan(siNum) || isinf(siNum) ? 0 : siNum;
        [SI addObject:[NSNumber numberWithFloat:siNum]];
    }
    ASI = [ChartTools SUM:SI d:ASI_M1 block:nil];
    MAASI = [ChartTools MA:ASI d:ASI_M2 block:nil];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"ASI(%.0f,%.0f)" , ASI_M1 , ASI_M2] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"ASI" linesArray:ASI start:@0 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"MAASI" linesArray:MAASI start:@0 color:[PWChartColors drawColorByIndex:1]]];
    
    return result;
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:i];
        if (i > 0) {
            klm2 = [array objectAtIndex:i - 1];
        }
        float volNum = 0;
        NSInteger count = 0;
        for (NSInteger j = i - EMV_N + 1; j <= i; j++) {
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
        for (NSInteger j = i - EMV_N + 1; j <= i; j++) {
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
        for (NSInteger j = i - EMV_N + 1; j <= i; j++) {
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
        
        [tmpArr addObject:@(emvNum)];
        if (tmpArr.count > EMV_M) {
            [tmpArr removeObjectAtIndex:0];
        }
        double maNum = 0;
        if (tmpArr.count > 0 && tmpArr.count <= EMV_M) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            maNum = sum / tmpArr.count;
        }
        [MAEMV addObject:[NSNumber numberWithFloat:maNum]];
        
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
    
    for (NSInteger i = 0 ; i < [array count]; i++) {
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
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"RSI(%.0f,%.0f,%.0f)" , RSI_N1 , RSI_N2 , RSI_N3] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"RSI1" linesArray:RSI1 start:@3 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"RSI2" linesArray:RSI2 start:@3 color:[PWChartColors drawColorByIndex:1]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"RSI3" linesArray:RSI3 start:@3 color:[PWChartColors drawColorByIndex:2]]];
    
    return result;
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
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        float hhv1Num = -1000000;
        float hhv2Num = -1000000;
        float llv1Num = 1000000;
        float llv2Num = 1000000;
        
        NSInteger start = 0;
        if (WR_N > 0) {
            start = i - WR_N + 1;
        }
        for (NSInteger j = start; j <= i ; j++) {
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
        for (NSInteger j = start; j <= i ; j++) {
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
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"WR(%.0f,%.0f)" , WR_N , WR_N1] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"WR1" linesArray:WR1 start:@0 color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"WR2" linesArray:WR2 start:@0 color:[PWChartColors drawColorByIndex:1]]];
    
    return result;
}

@synthesize CCI_N;
- (NSMutableDictionary *)getCCIResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *CCI = [[NSMutableArray alloc] init];
    NSMutableArray *TYP = [[NSMutableArray alloc] init];
    
    
    [dict setObject:CCI forKey:FXZBResult_CCI_CCI];
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        float typNum = ([klm.topPrice doubleValue] + [klm.bottomPrice doubleValue] + [klm.closePrice doubleValue]) / 3;
        [TYP addObject:[NSNumber numberWithFloat:typNum]];
        
        [tmpArr addObject:@(typNum)];
        if (tmpArr.count > CCI_N) {
            [tmpArr removeObjectAtIndex:0];
        }
        float avedevNum = 0;
        if (tmpArr.count > 0 && tmpArr.count <= CCI_N) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            avedevNum = sum / tmpArr.count;
        }
        
        NSInteger start = 0;
        if (CCI_N > 0) {
            start = i - CCI_N + 1;
        }
        //            NSInteger avedevCount = 0;
        //            for (NSInteger j = start ; j <= i; j++) {
        //                if (j < 0) {
        //                    continue;
        //                }
        //                avedevNum = avedevNum + [[TYP objectAtIndex:j] doubleValue];
        //                avedevCount++;
        //            }
        //            avedevNum = avedevNum / avedevCount;
        float avedevNow = 0;
        NSInteger avedevCount = 0;
        for (NSInteger j = start ; j <= i; j++) {
            if (j < 0) {
                continue;
            }
            avedevNow = avedevNow + fabs([[TYP objectAtIndex:j] doubleValue] - avedevNum);
            avedevCount++;
        }
        avedevNow = avedevNow / avedevCount;
        
        float cciNum = (typNum - avedevNum) / (0.015 * avedevNow);
        [CCI addObject:[NSNumber numberWithFloat:cciNum]];
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"CCI(%.0f)" , CCI_N] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"CCI" linesArray:CCI start:@0 color:[PWChartColors drawColorByIndex:0]]];
    
    return result;
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:0];
        if (i >= ROC_N) {
            klm2 = [array objectAtIndex:i - ROC_N];
        }
        float rocNum = 100 * ([klm.closePrice doubleValue] - [klm2.closePrice doubleValue]) / [klm2.closePrice doubleValue];
        rocNum = isnan(rocNum) || isinf(rocNum) ? 0 : rocNum;
        [ROC addObject:[NSNumber numberWithFloat:rocNum]];
        
        [tmpArr addObject:@(rocNum)];
        if (tmpArr.count > ROC_M) {
            [tmpArr removeObjectAtIndex:0];
        }
        if (tmpArr.count > 0 && tmpArr.count <= ROC_M) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            double maNum = sum / tmpArr.count;
            maNum = isnan(maNum) || isinf(maNum) ? 0 : maNum;
            [MAROC addObject:[NSNumber numberWithFloat:maNum]];
        }
        
        //            NSInteger start = 0;
        //            NSInteger count = 0;
        //            float marocNum = 0;
        //            if (ROC_M > 0) {
        //                start = i - ROC_M + 1;
        //            }
        //            for (NSInteger j = start; j <= i; j++) {
        //                if (j < 0) {
        //                    continue;
        //                }
        //                marocNum = marocNum + [[ROC objectAtIndex:j] doubleValue];
        //                count++;
        //            }
        //            marocNum = marocNum / count;
        //            [MAROC addObject:[NSNumber numberWithFloat:marocNum]];
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"ROC(%.0f,%.0f)" , ROC_N , ROC_M] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"ROC" linesArray:ROC start:@(ROC_N + 2) color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"MAROC" linesArray:MAROC start:@(ROC_N + 2) color:[PWChartColors drawColorByIndex:1]]];
    
    return result;
}

@synthesize PSY_N;
@synthesize PSY_M;
- (NSMutableDictionary *)getPSYResult:(NSMutableArray *)array{
    /*
     PSY:COUNT(CLOSE>REF(CLOSE,1),N)/N*100;
     PSYMA:MA(PSY,M);
     */
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *PSY = [[NSMutableArray alloc] init];
    NSMutableArray *PSYMA = [[NSMutableArray alloc] init];
    
    
    [dict setObject:PSY forKey:FXZBResult_PSY_PSY];
    [dict setObject:PSYMA forKey:FXZBResult_PSY_PSYMA];
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSMutableArray *tmpMAArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:(i > 1) ? i - 1 : 0];
        [tmpArr addObject:@(([klm.closePrice doubleValue] - [klm2.closePrice doubleValue]) > 0 ? 1 : 0)];
        tmpArr.count > PSY_N ? [tmpArr removeObjectAtIndex:0] : 0;
        if (tmpArr.count == PSY_N) {
            int sum = [[tmpArr valueForKeyPath:@"@sum.intValue"] intValue];
            double psyNum = sum * 100.0f / PSY_N;
            [PSY addObject:@(psyNum)];
            [tmpMAArr addObject:@(psyNum)];
        }
        tmpMAArr.count > PSY_M ? [tmpMAArr removeObjectAtIndex:0] : 0;
        if (tmpMAArr.count == PSY_M) {
            double sum = [[tmpMAArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            double psyMANum = sum / PSY_M;
            [PSYMA addObject:@(psyMANum)];
        }
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"PSY(%.0f,%.0f)" , PSY_N , PSY_M] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"PSY" linesArray:PSY start:@(PSY_N - 1) color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"PSYMA" linesArray:PSYMA start:@(PSY_N + PSY_M - 2) color:[PWChartColors drawColorByIndex:1]]];
    
    return result;
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
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        ChartFXDataModel *klm2 = [array objectAtIndex:0];
        if (i >= MTM_N) {
            klm2 = [array objectAtIndex:i - MTM_N];
        }
        float mtmNum = ([klm.closePrice doubleValue] - [klm2.closePrice doubleValue]);
        [MTM addObject:[NSNumber numberWithFloat:mtmNum]];
        
        [tmpArr addObject:@(mtmNum)];
        if (tmpArr.count > MTM_M) {
            [tmpArr removeObjectAtIndex:0];
        }
        if (tmpArr.count > 0 && tmpArr.count <= MTM_M) {
            double sum = [[tmpArr valueForKeyPath:@"@sum.doubleValue"] doubleValue];
            double maNum = sum / tmpArr.count;
            [MAMTM addObject:[NSNumber numberWithFloat:maNum]];
        }
        
        //        NSInteger start = 0;
        //        NSInteger count = 0;
        //        float mamtmNum = 0;
        //        if (MTM_M > 0) {
        //            start = i - MTM_M + 1;
        //        }
        //        for (NSInteger j = start; j <= i; j++) {
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
    for (NSInteger i = 0 ; i < [array count]; i++) {
        ChartFXDataModel *klm = [array objectAtIndex:i];
        
        float price = 0;
        NSInteger count = 0;
        for ( NSInteger j = i - BIAS_N1 + 1; j <= i; j++) {
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
        for ( NSInteger j = i - BIAS_N2 + 1; j <= i; j++) {
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
        for ( NSInteger j = i - BIAS_N3 + 1; j <= i; j++) {
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
        //        NSInteger start = 0;
        //        NSInteger count = 0;
        //        float mamtmNum = 0;
        //        if (MTM_M > 0) {
        //            start = i - MTM_M + 1;
        //        }
        //        for (NSInteger j = start; j <= i; j++) {
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
@synthesize BOLL_N;
- (NSMutableDictionary *)getBOLLResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *BOLL = [[NSMutableArray alloc] init];
    NSMutableArray *UB = [[NSMutableArray alloc] init];
    NSMutableArray *LB = [[NSMutableArray alloc] init];
    
    
    [dict setObject:BOLL forKey:FXZBResult_BOLL_BOLL1];
    [dict setObject:UB forKey:FXZBResult_BOLL_BOLL2];
    [dict setObject:LB forKey:FXZBResult_BOLL_BOLL3];
    
    for (NSInteger i = 0 ; i < array.count; i++) {
        float num = 0;
        if (i >= BOLL_M - 1) {
            for (NSInteger j = i - BOLL_M + 1 ; j <= i; j++) {
                ChartFXDataModel *model = [array objectAtIndex:j];
                num = num + [model.closePrice doubleValue];
            }
        }
        [BOLL addObject:[NSNumber numberWithFloat:num / BOLL_M]];
        
        float num2 = 0;
        if (i >= BOLL_M - 1) {
            for (NSInteger j = i - BOLL_M + 1 ; j <= i; j++) {
                ChartFXDataModel *model = [array objectAtIndex:j];
                num2 = num2 + pow([model.closePrice doubleValue] - num / BOLL_M , 2);
            }
        }
        [UB addObject:[NSNumber numberWithFloat:num / BOLL_M + BOLL_N * sqrtf(num2 / (BOLL_M - 1))]];
        [LB addObject:[NSNumber numberWithFloat:num / BOLL_M - BOLL_N * sqrtf(num2 / (BOLL_M - 1))]];
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSString stringWithFormat:@"BOLL(%.0f)" , BOLL_M] forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@7 sName:@"" linesArray:nil start:@(0) color:nil]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"BOLL" linesArray:BOLL start:@(BOLL_M-1) color:[PWChartColors drawColorByIndex:1]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"UPPER" linesArray:UB start:@(BOLL_M-1) color:[PWChartColors drawColorByIndex:0]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"LOWER" linesArray:LB start:@(BOLL_M-1) color:[PWChartColors drawColorByIndex:2]]];
    
    return result;
}

@synthesize AROON_N;
- (NSMutableDictionary*)getAROONResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *H = [[NSMutableArray alloc] init];
    NSMutableArray *L = [[NSMutableArray alloc] init];
    
    
    [dict setObject:H forKey:FXZBResult_AROON_H];
    [dict setObject:L forKey:FXZBResult_AROON_L];
    
    for (NSInteger i = 0 ; i < array.count; i++) {
        float maxNum = 0;
        NSInteger maxI = 0;
        float minNum = MAXFLOAT;
        NSInteger minI = 0;
        for (NSInteger j = i - AROON_N + 1 ; j <= i; j++) {
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

- (NSMutableDictionary *)getTSZF0Result:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *closes = [[NSMutableArray alloc] init];
    NSMutableArray *tops = [[NSMutableArray alloc] init];
    NSMutableArray *bottoms = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < array.count; i++) {
        ChartFXDataModel *model = [array objectAtIndex:i];
        [closes addObject:model.closePrice];
        [tops addObject:model.topPrice];
        [bottoms addObject:model.bottomPrice];
    }
    
    NSArray *ts = [ChartTools EMA:closes d:2 block:nil];
    NSArray *slopes = [ChartTools Slope:closes para:21 block:^double(double slopeNum, NSInteger index) {
        return slopeNum * 20 + [closes[index] doubleValue];
    }];
    NSArray *mg = [ChartTools EMA:slopes d:42 block:nil];
    
    NSMutableArray *duo = [ChartTools CROSS:ts array2:mg block:^id(id result, NSInteger index) {
        if ([result boolValue]) {
            return bottoms[index];
        }else{
            return @(NAN);
        }
    }];
    NSMutableArray *kong = [ChartTools CROSS:mg array2:ts block:^id(id result, NSInteger index) {
        if ([result boolValue]) {
            return tops[index];
        }else{
            return @(NAN);
        }
    }];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:@"特色战法" forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@-1 sName:@"多" linesArray:duo start:@0 color:[PWChartColors colorByKey:kChartColorKey_Rise]]];
    [arr addObject:[PWFXZBParam makeZBData:@-1 sName:@"空" linesArray:kong start:@0 color:[PWChartColors colorByKey:kChartColorKey_Fall]]];
    
    return result;
}

- (NSMutableDictionary *)getDUOKONGResult:(NSMutableArray *)array{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *closes = [[NSMutableArray alloc] init];
    NSMutableArray *tops = [[NSMutableArray alloc] init];
    NSMutableArray *bottoms = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < array.count; i++) {
        ChartFXDataModel *model = [array objectAtIndex:i];
        [closes addObject:model.closePrice];
        [tops addObject:model.topPrice];
        [bottoms addObject:model.bottomPrice];
    }
    NSMutableArray *LLVLow9 = [ChartTools LLV:bottoms int:9 block:nil];
    NSMutableArray *HHVHigh9 = [ChartTools HHV:tops int:9 block:nil];
    NSMutableArray *LLVLow36 = [ChartTools LLV:bottoms int:36 block:nil];
    NSMutableArray *HHVHigh36 = [ChartTools HHV:tops int:36 block:nil];
    NSMutableArray *arrayDuo = [[NSMutableArray alloc] init];
    NSMutableArray *arrayKong = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < closes.count; i++) {
        double close = [closes[i] doubleValue];
        double LLVLow9Num = [LLVLow9[i] doubleValue];
        double HHVHigh9Num = [HHVHigh9[i] doubleValue];
        double LLVLow36Num = [LLVLow36[i] doubleValue];
        double HHVHigh36Num = [HHVHigh36[i] doubleValue];
        double duoNum = (close - LLVLow9Num) / (HHVHigh9Num - LLVLow9Num) * 100;
        double kongNum = (HHVHigh36Num - close) / (HHVHigh36Num - LLVLow36Num) * 100;
        if (isnan(duoNum)||isinf(duoNum)){
            duoNum = 0;
        }
        if (isnan(kongNum)||isinf(kongNum)){
            kongNum = 0;
        }
        [arrayDuo addObject:@(duoNum)];
        [arrayKong addObject:@(kongNum)];
    }
    
    NSMutableArray *duo = [ChartTools SMA:arrayDuo n:5 m:1 block:nil end:^double(double num, NSInteger index) {
        return num - 8;
    }];
    NSMutableArray *kong = [ChartTools SMA:arrayKong n:2 m:1 block:nil end:nil];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:@"" forKey:@"sName"];
    [result setObject:@(array.count) forKey:@"nCount"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [result setObject:arr forKey:@"linesArray"];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"做多能量线" linesArray:duo start:@0 color:[PWChartColors colorByKey:kChartColorKey_Rise]]];
    [arr addObject:[PWFXZBParam makeZBData:@0 sName:@"做空能量线" linesArray:kong start:@0 color:[PWChartColors colorByKey:kChartColorKey_Fall]]];
    return result;
}

+ (NSDictionary *)makeZBData:(NSNumber *)type sName:(NSString *)sName linesArray:(NSArray *)linesArray start:(NSNumber *)start color:(UIColor *)color{
    //type见ZBChartsLayer
    sName = sName ? sName : @"";
    linesArray = linesArray ? linesArray : @[];
    NSDictionary *dict = @{@"type":type,
                           @"sName":sName ? sName : @"",
                           @"linesArray":linesArray,
                           @"start":start,
                           @"color":color ? color : [UIColor clearColor]
                           };
    return dict;
}
@end

