//
//  ChartTools.m
//  PWChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ChartTools.h"

@implementation ChartTools

float chartValid(float value) {
    return isnan(value) || isinf(value) ? 0 : value;
}

- (NSMutableArray *)SUMFloat:(NSMutableArray *)array d:(int)d{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        float f = [[array objectAtIndex:i] doubleValue];
        if (i >= d - 1) {
            for (int j = i - d + 1; j < i; j++) {
                float f0 = [[array objectAtIndex:j] doubleValue];
                f = f + f0;
            }
        }
        [a addObject:[NSNumber numberWithFloat:f]];
    }
    
    return a;
}

- (NSMutableArray *)SUMInt:(NSMutableArray *)array d:(int)d{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        float f = [[array objectAtIndex:i] intValue];
        if (i >= d - 1) {
            for (int j = i - d + 1; j < i; j++) {
                float f0 = [[array objectAtIndex:j] intValue];
                f = f + f0;
            }
        }
        [a addObject:[NSNumber numberWithInt:f]];
    }
    
    return a;
}

- (NSMutableArray *)SUMLong:(NSMutableArray *)array d:(int)d{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        long long f = [[array objectAtIndex:i] longLongValue];
        if (i >= d - 1) {
            for (int j = i - d + 1; j < i; j++) {
                long long f0 = [[array objectAtIndex:j] longLongValue];
                f = f + f0;
            }
        }
        [a addObject:[NSNumber numberWithLongLong:f]];
    }
    
    return a;
}

- (NSMutableArray *)EMAFload:(NSMutableArray *)array d:(int)d{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        float f = [[array objectAtIndex:i] doubleValue];
        
        float ema1 = 0;
        float ema1Old = 0;
        if (i > 0) {
            ema1Old = [[a objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * f + ema1Old * (d - 1))/(d + 1);
        }else{
            ema1Old = f;
        }
        
        [a addObject:[NSNumber numberWithFloat:ema1]];
    }
    
    return a;
}

- (NSMutableArray *)EMALong:(NSMutableArray *)array d:(int)d{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        long long f = [[array objectAtIndex:i]  longLongValue];
        
        double ema1 = 0;
        double ema1Old = 0;
        if (i > 0) {
            ema1Old = [[a objectAtIndex:i - 1] longLongValue];
            ema1 = (2 * f + ema1Old * (d - 1))/(d + 1);
        }else{
            ema1Old = f;
        }
        
        [a addObject:[NSNumber numberWithDouble:ema1]];
    }
    
    return a;
}

- (NSMutableArray *)EMADouble:(NSMutableArray *)array d:(int)d{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [array count]; i++) {
        double f = [[array objectAtIndex:i] doubleValue];
        
        double ema1 = 0;
        double ema1Old = 0;
        if (i > 0) {
            ema1Old = [[a objectAtIndex:i - 1] doubleValue];
            ema1 = (2 * f + ema1Old * (d - 1))/(d + 1);
        }else{
            ema1Old = f;
        }
        
        [a addObject:[NSNumber numberWithDouble:ema1]];
    }
    
    return a;
}
@end
