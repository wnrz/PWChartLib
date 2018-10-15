//
//  BaseColors.m
//  Tools
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PWChartColors.h"

//颜色获取宏
#define PWCColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define PWCColorRGBAndAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define PWCColorRGBWithDecimal(r, g, b) ([UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:1.0])
#define PWCColorRGBWithDecimalAndAlpha(r, g, b , a) ([UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:a])

@implementation PWChartColors

+ (PWChartColors *)share{
    //使用单一线程，解决网络同步请求的问题
    static PWChartColors* shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[PWChartColors alloc] init];
    });
    return shareInstance;
}

+ (UIColor *)colorByKey:(NSString *)key{
    UIColor *color;
    if ([[ChartConfig shareConfig].chartColors isKindOfClass:[NSDictionary class]] && [ChartConfig shareConfig].chartColors.count > 0) {
        color = [ChartConfig shareConfig].chartColors[key];
        if (color) {
            return color;
        }
    }
    [key isEqual:kChartColorKey_Form] ? color = PWCColorRGB(0x999FAA) : 0;
    
    [key isEqual:kChartColorKey_Rise] ? color = PWCColorRGB(0xff4147) : 0;
    [key isEqual:kChartColorKey_Fall] ? color = PWCColorRGB(0x0b956) : 0;
    [key isEqual:kChartColorKey_Stay] ? color = PWCColorRGB(0x666666) : 0;
    
//    [key isEqual:kChartColorKey_Text] ? color = PWCColorRGB(0x31343A) : 0;
    
    [key isEqual:kChartColorKey_Text] ? color = PWCColorRGB(0x666666) : 0;
    
    [key isEqual:kChartColorKey_TextBorderText] ? color = PWCColorRGB(0x666666) : 0;
    [key isEqual:kChartColorKey_TextBorder] ? color = PWCColorRGB(0x666666) : 0;
    [key isEqual:kChartColorKey_TextBorderBackground] ? color = PWCColorRGB(0xffffff) : 0;
    [key isEqual:kChartColorKey_CrossLine] ? color = PWCColorRGB(0x999FAA) : 0;
    
    [key isEqual:kChartColorKey_XJ] ? color = PWCColorRGB(0x6F89CB) : 0;
    [key isEqual:kChartColorKey_XJFrom] ? color = PWCColorRGB(0xE1ECFE) : 0;
    [key isEqual:kChartColorKey_XJTo] ? color = PWCColorRGB(0xFFFFFF) : 0;
    [key isEqual:kChartColorKey_JJ] ? color = PWCColorRGB(0xF2B415) : 0;
    [key isEqual:kChartColorKey_ThirdLine] ? color = PWCColorRGB(0x01d162) : 0;
    
    return color;
    /*
     
     
     #define kChartColorKey_Text @"kChartColorKey_Text";
     */
}

+ (UIColor *)drawColorByIndex:(NSInteger)index{
    NSArray *colorArr = [self colors];
    index = index % colorArr.count;
    
    UIColor *color = PWCColorRGB([colorArr[index] integerValue]);
    return color;
}

+ (NSArray *)colors{
    if ([[ChartConfig shareConfig].lineColors isKindOfClass:[NSArray class]] && [ChartConfig shareConfig].lineColors.count > 0) {
        return [ChartConfig shareConfig].lineColors;
    }
    return @[@(0x005C78),@(0xFF9E00),@(0xD71A7B),@(0x9B59B6),@(0xE74C3C),@(0xF5BB25),@(0x4FCAD3)];
}
@end
