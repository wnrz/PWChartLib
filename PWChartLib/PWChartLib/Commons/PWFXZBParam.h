//
//  FXZBParam.h
//  socketTest
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#define FXZBResult_MACD_DIF @"FXZBResult_MACD_DIF"
#define FXZBResult_MACD_DEA @"FXZBResult_MACD_DEA"
#define FXZBResult_MACD_MACD @"FXZBResult_MACD_MACD"

#define FXZBResult_KDJ_K @"FXZBResult_KDJ_K"
#define FXZBResult_KDJ_D @"FXZBResult_KDJ_D"
#define FXZBResult_KDJ_J @"FXZBResult_KDJ_J"


#define FXZBResult_DMI_PDI @"FXZBResult_DMI_PDI"
#define FXZBResult_DMI_MDI @"FXZBResult_DMI_MDI"
#define FXZBResult_DMI_ADX @"FXZBResult_DMI_ADX"
#define FXZBResult_DMI_ADXR @"FXZBResult_DMI_ADXR"

#define FXZBResult_DMA_DIF @"FXZBResult_DMA_DIF"
#define FXZBResult_DMA_DIFMA @"FXZBResult_DMA_DIFMA"

#define FXZBResult_TRIX_TRIX @"FXZBResult_TRIX_TRIX"
#define FXZBResult_TRIX_MATRIX @"FXZBResult_TRIX_MATRIX"

#define FXZBResult_BRAR_BR @"FXZBResult_BRAR_BR"
#define FXZBResult_BRAR_AR @"FXZBResult_BRAR_AR"

#define FXZBResult_CR_CR @"FXZBResult_CR_CR"
#define FXZBResult_CR_MA1 @"FXZBResult_CR_MA1"
#define FXZBResult_CR_MA2 @"FXZBResult_CR_MA2"
#define FXZBResult_CR_MA3 @"FXZBResult_CR_MA3"
#define FXZBResult_CR_MA4 @"FXZBResult_CR_MA4"

#define FXZBResult_VR_VR @"FXZBResult_VR_VR"
#define FXZBResult_VR_MAVR @"FXZBResult_VR_MAVR"


#define FXZBResult_OBV_OBV @"FXZBResult_OBV_OBV"
#define FXZBResult_OBV_MAOBV @"FXZBResult_OBV_MAOBV"


#define FXZBResult_ASI_ASI @"FXZBResult_ASI_ASI"
#define FXZBResult_ASI_MAASI @"FXZBResult_ASI_MAASI"

#define FXZBResult_EMV_EMV @"FXZBResult_EMV_EMV"
#define FXZBResult_EMV_MAEMV @"FXZBResult_EMV_MAEMV"

#define FXZBResult_RSI_RSI1 @"FXZBResult_RSI_RSI1"
#define FXZBResult_RSI_RSI2 @"FXZBResult_RSI_RSI2"
#define FXZBResult_RSI_RSI3 @"FXZBResult_RSI_RSI3"

#define FXZBResult_WR_WR1 @"FXZBResult_WR_WR1"
#define FXZBResult_WR_WR2 @"FXZBResult_WR_WR2"

#define FXZBResult_CCI_CCI @"FXZBResult_CCI_CCI"

#define FXZBResult_ROC_ROC @"FXZBResult_ROC_ROC"
#define FXZBResult_ROC_MAROC @"FXZBResult_ROC_MAROC"

#define FXZBResult_PSY_PSY @"FXZBResult_PSY_PSY"
#define FXZBResult_PSY_PSYMA @"FXZBResult_PSY_PSYMA"

#define FXZBResult_MTM_MTM @"FXZBResult_MTM_MTM"
#define FXZBResult_MTM_MAMTM @"FXZBResult_MTM_MAMTM"

#define FXZBResult_BIAS_BIAS1 @"FXZBResult_BIAS_BIAS1"
#define FXZBResult_BIAS_BIAS2 @"FXZBResult_BIAS_BIAS2"
#define FXZBResult_BIAS_BIAS3 @"FXZBResult_BIAS_BIAS3"

#define FXZBResult_ZJLX_JM @"FXZBResult_ZJLX_JM"
#define FXZBResult_ZJLX_TD @"FXZBResult_ZJLX_TD"
#define FXZBResult_ZJLX_LX @"FXZBResult_ZJLX_LX"


#define FXZBResult_ZJKP_G1 @"FXZBResult_ZJKP_G1"
#define FXZBResult_ZJKP_P1 @"FXZBResult_ZJKP_P1"
#define FXZBResult_ZJKP_W1 @"FXZBResult_ZJKP_W1"
#define FXZBResult_ZJKP_G2 @"FXZBResult_ZJKP_G2"
#define FXZBResult_ZJKP_P2 @"FXZBResult_ZJKP_P2"
#define FXZBResult_ZJKP_W2 @"FXZBResult_ZJKP_W2"

#define FXZBResult_ZJDL_DLZHZ @"FXZBResult_ZJDL_DLZHZ"

#define FXZBResult_BOLL_BOLL1 @"FXZBResult_BOLL_BOLL1"
#define FXZBResult_BOLL_BOLL2 @"FXZBResult_BOLL_BOLL2"
#define FXZBResult_BOLL_BOLL3 @"FXZBResult_BOLL_BOLL3"

#define FXZBResult_AROON_H @"FXZBResult_AROON_H"
#define FXZBResult_AROON_L @"FXZBResult_AROON_L"

#define FXZBResult_CYZB_Values @"FXZBResult_CYZB_Values"

#import <Foundation/Foundation.h>
#import "ChartFXDataModel.h"
#import "ChartHQDataModel.h"

@interface PWFXZBParam : NSObject
@property(nonatomic , retain)NSArray *Pri_MAS;
@property(nonatomic , retain)NSArray *VOL_MAS;

@property(nonatomic)float MACD_Short;
@property(nonatomic)float MACD_Long;
@property(nonatomic)float MACD_Mid;

@property(nonatomic)float KDJ_N;
@property(nonatomic)float KDJ_M1;
@property(nonatomic)float KDJ_M2;

@property(nonatomic)float DMI_N;
@property(nonatomic)float DMI_MM;

@property(nonatomic)float DMA_N1;
@property(nonatomic)float DMA_N2;
@property(nonatomic)float DMA_M;

@property(nonatomic)float TRIX_N;
@property(nonatomic)float TRIX_M;

@property(nonatomic)float BRAR_N;

@property(nonatomic)float CR_N;
@property(nonatomic)float CR_M1;
@property(nonatomic)float CR_M2;
@property(nonatomic)float CR_M3;
@property(nonatomic)float CR_M4;

@property(nonatomic)float VR_N;
@property(nonatomic)float VR_M;

@property(nonatomic)float OBV_M;

@property(nonatomic)float ASI_M;

@property(nonatomic)float ASI_M1;
@property(nonatomic)float ASI_M2;

@property(nonatomic)float EMV_N;
@property(nonatomic)float EMV_M;

@property(nonatomic)float RSI_N1;
@property(nonatomic)float RSI_N2;
@property(nonatomic)float RSI_N3;

@property(nonatomic)float WR_N;
@property(nonatomic)float WR_N1;

@property(nonatomic)float CCI_N;

@property(nonatomic)float ROC_N;
@property(nonatomic)float ROC_M;

@property(nonatomic)float PSY_N;
@property(nonatomic)float PSY_M;

@property(nonatomic)float MTM_N;
@property(nonatomic)float MTM_M;

@property(nonatomic)float BIAS_N1;
@property(nonatomic)float BIAS_N2;
@property(nonatomic)float BIAS_N3;

@property(nonatomic)float BOLL_M;

@property(nonatomic)float AROON_N;

@property(nonatomic)float CYZB_Value;

+(PWFXZBParam*)shareFXZBParam;

//主图指标
- (NSMutableDictionary *)getPriMAResult:(NSMutableArray *)array;

//幅图指标
- (NSMutableDictionary *)getVOLMAResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getMACDResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getKDJResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getDMIResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getDMAResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getTRIXResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getBRARResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getCRResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getVRResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getOBVResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getASIResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getASI2Result:(NSMutableArray *)array;

- (NSMutableDictionary *)getEMVResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getRSIResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getWRResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getCCIResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getROCResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getPSYResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getMTMResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getBIASResult:(NSMutableArray *)array;

- (NSMutableDictionary*)getBOLLResult:(NSMutableArray *)array;

- (NSMutableDictionary*)getAROONResult:(NSMutableArray *)array;

- (NSMutableDictionary *)getTSZF0Result:(NSMutableArray *)array;

//- (NSMutableDictionary*)getCYZBResult:(NSMutableArray *)array datas:(NSMutableArray *)datas;


@end
