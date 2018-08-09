//
//  ChartTools.h
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartCommonMacro.h"

@interface ChartTools : NSObject

float chartValid(float value);

+ (NSMutableArray *)SUMFloat:(NSMutableArray *)array d:(int)d;

+ (NSMutableArray *)SUMInt:(NSMutableArray *)array d:(int)d;

+ (NSMutableArray *)SUMLong:(NSMutableArray *)array d:(int)d;

+ (NSMutableArray *)EMAFload:(NSMutableArray *)array d:(int)d;

+ (NSMutableArray *)EMALong:(NSMutableArray *)array d:(int)d;

+ (NSMutableArray *)EMADouble:(NSMutableArray *)array d:(int)d;

+ (CGFloat)getStartX:(CGRect)rc total:(NSInteger)total;

+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;

NSString *chartDigitString(NSInteger tpflag , NSString *string);
@end
