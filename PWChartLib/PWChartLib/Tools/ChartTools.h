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

+ (NSMutableArray *)SUM:(NSArray *)array d:(NSInteger)d block:(double (^)(double num , NSInteger index))block;
+ (NSMutableArray *)EMA:(NSArray *)array d:(NSInteger)d block:(double (^)(double num , NSInteger index))block;
+ (NSMutableArray *)SMA:(NSArray *)array n:(NSInteger)n m:(NSInteger)m block:(double (^)(double num , NSInteger index))block end:(double (^)(double num , NSInteger index))end;
+ (NSMutableArray *)MA:(NSArray *)array d:(NSInteger)d block:(double (^)(double num , NSInteger index))block;
+ (NSMutableArray *)Slope:(NSArray *)input para:(short)para block:(double (^)(double num , NSInteger index))block;
+ (NSMutableArray *)CROSS:(NSArray *)array1 array2:(NSArray *)array2 block:(id (^)(id result , NSInteger index))block;
+ (NSMutableArray *)HHV:(NSArray *)array int:(NSInteger)num block:(double (^)(double num , NSInteger index))block;
+ (NSMutableArray *)LLV:(NSArray *)array int:(NSInteger)num block:(double (^)(double num , NSInteger index))block;

+ (CGFloat)getStartX:(CGRect)rc total:(NSInteger)total;

+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;

NSString *chartDigitString(NSInteger tpflag , NSString *string);

+ (NSArray *)getRGBWithColor:(UIColor *)color;
+ (UIColor *)getNewColorWith:(UIColor *)color alpha:(float)alpha;
@end
