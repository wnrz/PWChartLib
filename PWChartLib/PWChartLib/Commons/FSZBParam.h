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

#import <Foundation/Foundation.h>
#import "ChartFSDataModel.h"
#import "ChartHQDataModel.h"

@interface FSZBParam : NSObject
@property(nonatomic , retain)NSArray *VOL_MAS;

@property(nonatomic)float MACD_Short;
@property(nonatomic)float MACD_Long;
@property(nonatomic)float MACD_Mid;

@property(nonatomic)float KDJ_N;
@property(nonatomic)float KDJ_M1;
@property(nonatomic)float KDJ_M2;

+(FSZBParam*)shareFSZBParam;

//主图指标

//幅图指标
- (NSMutableDictionary *)getMACDResult:(NSMutableArray *)array;
- (NSMutableDictionary *)getVOLMAResult:(NSMutableArray *)array;
- (NSMutableDictionary *)getKDJResult:(NSMutableArray *)array;

@end
