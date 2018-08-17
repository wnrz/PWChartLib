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

+ (UIColor *)colorByKey:(NSString *)key{
    UIColor *color;
    [key isEqual:kChartColorKey_Form] ? color = PWCColorRGB(0x999FAA) : 0;
    
    [key isEqual:kChartColorKey_Rise] ? color = PWCColorRGB(0xF55449) : 0;
    [key isEqual:kChartColorKey_Fall] ? color = PWCColorRGB(0x07A168) : 0;
    [key isEqual:kChartColorKey_Stay] ? color = PWCColorRGB(0xaaaaaa) : 0;
    
    [key isEqual:kChartColorKey_Text] ? color = PWCColorRGB(0x31343A) : 0;
    
    [key isEqual:kChartColorKey_Text] ? color = PWCColorRGB(0x999FAA) : 0;
    
    [key isEqual:kChartColorKey_TextBorderText] ? color = PWCColorRGB(0xFFFFFF) : 0;
    [key isEqual:kChartColorKey_TextBorder] ? color = PWCColorRGB(0x999FAA) : 0;
    [key isEqual:kChartColorKey_TextBorderBackground] ? color = PWCColorRGB(0x999FAA) : 0;
    [key isEqual:kChartColorKey_CrossLine] ? color = PWCColorRGB(0x999FAA) : 0;
    
    [key isEqual:kChartColorKey_XJ] ? color = PWCColorRGB(0x99CCFD) : 0;
    [key isEqual:kChartColorKey_JJ] ? color = PWCColorRGB(0xF2B415) : 0;
    
    return color;
    /*
     
     
     #define kChartColorKey_Text @"kChartColorKey_Text";
     */
}

+ (UIColor *)drawColorByIndex:(NSInteger)index{
    NSArray *colorArr = @[@(0x005C78),@(0xFF9E00),@(0xD71A7B),@(0x9B59B6),@(0xE74C3C),@(0xF5BB25),@(0x4FCAD3)];
    index = index % colorArr.count;
    
    UIColor *color = PWCColorRGB([colorArr[index] integerValue]);
    return color;
}
@end
