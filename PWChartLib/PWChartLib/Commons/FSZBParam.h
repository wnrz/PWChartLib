//
//  FSZBParam.h
//  socketTest
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#define FSZBResult_MACD_DIF @"FSZBResult_MACD_DIF"
#define FSZBResult_MACD_DEA @"FSZBResult_MACD_DEA"
#define FSZBResult_MACD_MACD @"FSZBResult_MACD_MACD"

#define FSZBResult_KDJ_K @"FSZBResult_KDJ_K"
#define FSZBResult_KDJ_D @"FSZBResult_KDJ_D"
#define FSZBResult_KDJ_J @"FSZBResult_KDJ_J"


#define FSZBResult_DMI_PDI @"FSZBResult_DMI_PDI"
#define FSZBResult_DMI_MDI @"FSZBResult_DMI_MDI"
#define FSZBResult_DMI_ADX @"FSZBResult_DMI_ADX"
#define FSZBResult_DMI_ADXR @"FSZBResult_DMI_ADXR"

#define FSZBResult_DMA_DIF @"FSZBResult_DMA_DIF"
#define FSZBResult_DMA_DIFMA @"FSZBResult_DMA_DIFMA"

#define FSZBResult_TRIX_TRIX @"FSZBResult_TRIX_TRIX"
#define FSZBResult_TRIX_MATRIX @"FSZBResult_TRIX_MATRIX"

#define FSZBResult_BRAR_BR @"FSZBResult_BRAR_BR"
#define FSZBResult_BRAR_AR @"FSZBResult_BRAR_AR"

#define FSZBResult_CR_CR @"FSZBResult_CR_CR"
#define FSZBResult_CR_MA1 @"FSZBResult_CR_MA1"
#define FSZBResult_CR_MA2 @"FSZBResult_CR_MA2"
#define FSZBResult_CR_MA3 @"FSZBResult_CR_MA3"
#define FSZBResult_CR_MA4 @"FSZBResult_CR_MA4"

#define FSZBResult_VR_VR @"FSZBResult_VR_VR"
#define FSZBResult_VR_MAVR @"FSZBResult_VR_MAVR"


#define FSZBResult_OBV_OBV @"FSZBResult_OBV_OBV"
#define FSZBResult_OBV_MAOBV @"FSZBResult_OBV_MAOBV"


#define FSZBResult_ASI_ASI @"FSZBResult_ASI_ASI"
#define FSZBResult_ASI_MAASI @"FSZBResult_ASI_MAASI"

#define FSZBResult_EMV_EMV @"FSZBResult_EMV_EMV"
#define FSZBResult_EMV_MAEMV @"FSZBResult_EMV_MAEMV"

#define FSZBResult_RSI_RSI1 @"FSZBResult_RSI_RSI1"
#define FSZBResult_RSI_RSI2 @"FSZBResult_RSI_RSI2"
#define FSZBResult_RSI_RSI3 @"FSZBResult_RSI_RSI3"

#define FSZBResult_WR_WR1 @"FSZBResult_WR_WR1"
#define FSZBResult_WR_WR2 @"FSZBResult_WR_WR2"

#define FSZBResult_CCI_CCI @"FSZBResult_CCI_CCI"

#define FSZBResult_ROC_ROC @"FSZBResult_ROC_ROC"
#define FSZBResult_ROC_MAROC @"FSZBResult_ROC_MAROC"

#define FSZBResult_MTM_MTM @"FSZBResult_MTM_MTM"
#define FSZBResult_MTM_MAMTM @"FSZBResult_MTM_MAMTM"

#define FSZBResult_BIAS_BIAS1 @"FSZBResult_BIAS_BIAS1"
#define FSZBResult_BIAS_BIAS2 @"FSZBResult_BIAS_BIAS2"
#define FSZBResult_BIAS_BIAS3 @"FSZBResult_BIAS_BIAS3"

#define FSZBResult_ZJLX_JM @"FSZBResult_ZJLX_JM"
#define FSZBResult_ZJLX_TD @"FSZBResult_ZJLX_TD"
#define FSZBResult_ZJLX_LX @"FSZBResult_ZJLX_LX"


#define FSZBResult_ZJKP_G1 @"FSZBResult_ZJKP_G1"
#define FSZBResult_ZJKP_P1 @"FSZBResult_ZJKP_P1"
#define FSZBResult_ZJKP_W1 @"FSZBResult_ZJKP_W1"
#define FSZBResult_ZJKP_G2 @"FSZBResult_ZJKP_G2"
#define FSZBResult_ZJKP_P2 @"FSZBResult_ZJKP_P2"
#define FSZBResult_ZJKP_W2 @"FSZBResult_ZJKP_W2"

#define FSZBResult_ZJDL_DLZHZ @"FSZBResult_ZJDL_DLZHZ"

#define FSZBResult_BOLL_BOLL1 @"FSZBResult_BOLL_BOLL1"
#define FSZBResult_BOLL_BOLL2 @"FSZBResult_BOLL_BOLL2"
#define FSZBResult_BOLL_BOLL3 @"FSZBResult_BOLL_BOLL3"

#import <Foundation/Foundation.h>
#import "ChartFSDataModel.h"
#import "ChartHQDataModel.h"

@interface FSZBParam : NSObject
@property(nonatomic , retain)NSArray *VOL_MAS;

@property(nonatomic)float MACD_Short;
@property(nonatomic)float MACD_Long;
@property(nonatomic)float MACD_Mid;

+(FSZBParam*)shareFSZBParam;

//主图指标

//幅图指标
- (NSMutableDictionary *)getMACDResult:(NSMutableArray *)array;
- (NSMutableDictionary *)getVOLMAResult:(NSMutableArray *)array;

@end
