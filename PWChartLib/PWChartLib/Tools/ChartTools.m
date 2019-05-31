//
//  ChartTools.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartTools.h"
#import "ChartConfig.h"

@implementation ChartTools

float chartValid(float value) {
    return isnan(value) || isinf(value) ? 0 : value;
}

+ (NSMutableArray *)SUM:(NSArray *)array d:(NSInteger)d block:(double (^)(double num , NSInteger index))block{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        float f = [[array objectAtIndex:i] doubleValue];
        if (d == 0) {
            if (i > 0) {
                f = f + [[arr lastObject] doubleValue];
            }
        }else{
            for (NSInteger j = (i - d + 1) >= 0 ? (i - d + 1) : 0; j < i; j++) {
                float f0 = [[array objectAtIndex:j] doubleValue];
                f = f + f0;
            }
            //            if (i >= d - 1) {
            //                for (NSInteger j = i - d + 1; j < i; j++) {
            //                    float f0 = [[array objectAtIndex:j] doubleValue];
            //                    f = f + f0;
            //                }
            //            }
        }
        
        double num = f;
        [arr addObject:@(f)];
        if(block){
            num = block(num , i);
        }
        [a addObject:@(num)];
    }
    
    return a;
}

+ (NSMutableArray *)EMA:(NSArray *)array d:(NSInteger)d block:(double (^)(double num , NSInteger index))block{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        double f = [[array objectAtIndex:i]  doubleValue];
        
        double ema1 = 0;
        double ema1Old = 0;
        if (i > 0) {
            ema1Old = [[a objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * f + ema1Old * (d - 1))/(d + 1);
        }else{
//            ema1Old = f;
        }
        
        double num = ema1;
        if(block){
            num = block(num , i);
        }
        [a addObject:@(num)];
    }
    
    return a;
}

+ (NSMutableArray *)SMA:(NSArray *)array n:(NSInteger)n m:(NSInteger)m block:(double (^)(double num , NSInteger index))block end:(double (^)(double num , NSInteger index))end{
    if (n < m){
        return [NSMutableArray arrayWithArray:array];
    }
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        double f = [[array objectAtIndex:i]  doubleValue];
        if (isnan(f) || isinf(f)) {
            f = 0;
        }
        double sma1 = 0;
        double sma1Old = 0;
        if (i > 0) {
            sma1Old = [[a objectAtIndex:i - 1] doubleValue];
            sma1 = (m * f + sma1Old * (n - m))/n;
        }else{
            sma1Old = f;
            sma1 = f;
        }
        
        double num = sma1;
        if(block){
            num = block(num , i);
        }
        [a addObject:@(num)];
    }
    if(end){
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:a];
        [tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            double num = [obj doubleValue];
            if (isnan(num) || isinf(num)) {
                num = 0;
            }
            num = end(num , idx);
            [a replaceObjectAtIndex:idx withObject:@(num)];
        }];
    }
    
    return a;
}

+ (NSMutableArray *)MA:(NSArray *)array d:(NSInteger)d block:(double (^)(double num , NSInteger index))block{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    NSMutableArray *b = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < [array count]; i++) {
        double f = [[array objectAtIndex:i]  doubleValue];
        if (isnan(f) || isinf(f)) {
            f = 0;
        }
        
        [b addObject:@(f)];
        if (b.count > d) {
            [b removeObject:[b firstObject]];
        }
        
        double sum = [[b valueForKeyPath:@"@sum.doubleValue"] doubleValue];
        double num = sum / b.count;
        if(block){
            num = block(num , i);
        }
        [a addObject:@(num)];
    }
    
    return a;
}

+ (NSMutableArray *)Slope:(NSArray *)input para:(short)para block:(double (^)(double num , NSInteger index))block{
    NSMutableArray *emaout = [[NSMutableArray alloc] init];
    NSInteger num = [input count];
    int N = para;
    if (N > 1) {
        float sum_xy = 0, sum_y = 0, ave_x = 0, sum_xx = 0;
        int i;
        for (i = 1; i <= N; ++i) {
            ave_x += i;
            sum_xx += i * i;
        }
        ave_x /= N;
        i = 0;
        i = i + N - 1;
        for (int j = 0 ; j < i ; j++) {
            emaout[j] = @(0);
        }
        for (; i < num; ++i) {
            sum_xy = sum_y = 0;
            for (int j = 0; j < N; ++j) {
                sum_y += [input[i - j] doubleValue];
                sum_xy += [input[i - j] doubleValue] * (N - j);
            }
            double slopeNum = ((sum_xy - ave_x * sum_y) / (sum_xx - N * ave_x * ave_x));
            if(block){
                slopeNum = block(slopeNum , i);
            }
            emaout[i] = @(slopeNum);//@(((sum_xy - ave_x * sum_y) / (sum_xx - N * ave_x * ave_x)) * 20 + [input[i] doubleValue]);
        }
    }
    return emaout;
}

+ (NSMutableArray *)CROSS:(NSArray *)array1 array2:(NSArray *)array2 block:(id (^)(id result , NSInteger index))block{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:array1];
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:array2];
    while (arr1.count != arr2.count) {
        arr1.count < arr2.count ? [arr1 insertObject:@(0) atIndex:0] : arr1.count > arr2.count ? [arr2 insertObject:@(0) atIndex:0] : 0;
    }
    for (int i = 0 ; i < arr1.count ; i++) {
        id result = @(NO);
        if (i > 0 && [arr1[i - 1] doubleValue] < [arr2[i - 1] doubleValue] && [arr1[i] doubleValue] > [arr2[i] doubleValue]){
            result = @(YES);
        }
        if (block) {
            result = block(result , i);
        }
        [arr addObject:result];
    }
    return arr;
}

+ (NSMutableArray *)HHV:(NSArray *)array int:(NSInteger)num block:(double (^)(double num , NSInteger index))block{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < array.count ; i++) {
        NSInteger loc = i >= num ? i - num + 1 : 0;
        if (num == 0) {
            loc = 0;
        }
        NSInteger len = i >= num ? num : i + 1;
        NSArray *tArray = [array subarrayWithRange:NSMakeRange(loc, len)];
        NSNumber *max = [tArray valueForKeyPath:@"@max.self"];
        double hhv = max.doubleValue;
        if (block) {
            hhv = block(hhv , i);
        }
        [arr addObject:@(hhv)];
    }
    return arr;
}

+ (NSMutableArray *)LLV:(NSArray *)array int:(NSInteger)num block:(double (^)(double num , NSInteger index))block{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < array.count ; i++) {
        NSInteger loc = i >= num ? i - num + 1 : 0;
        if (num == 0) {
            loc = 0;
        }
        NSInteger len = i >= num ? num : i + 1;
        NSArray *tArray = [array subarrayWithRange:NSMakeRange(loc, len)];
        NSNumber *min = [tArray valueForKeyPath:@"@min.self"];
        double llv = min.doubleValue;
        if (block) {
            llv = block(llv , i);
        }
        [arr addObject:@(llv)];
    }
    return arr;
}

+ (CGFloat)getStartX:(CGRect)rc total:(NSInteger)total{
    float startX = rc.size.width / total + 1;
    startX = startX / 2;
    return startX;
}




//计算文字的大小
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //    假设最大CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:[ChartConfig shareConfig].fontName size:fontSize]} context:nil].size;
    return nameSize;
}


NSString *chartDigitString(NSInteger tpflag , NSString *string){
    if (tpflag < 0) {
        tpflag = 2;
    }
    NSString *s = [NSString stringWithFormat:@"%%.%lif" , tpflag];
    if (chartIsValidString(string)) {
        s = [NSString stringWithFormat:s , [string doubleValue]];
    }else{
        s = [NSString stringWithFormat:s , 0];
    }
    return s;
}

// 获取RGB和Alpha
+ (NSArray *)getRGBWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

// 改变UIColor的Alpha
+ (UIColor *)getNewColorWith:(UIColor *)color alpha:(float)alpha{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha2 = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha2];
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return newColor;
}
@end
