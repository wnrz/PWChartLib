//
//  BaseColors.h
//  Tools
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChartColors : NSObject

#define kChartColorKey_Form @"kChartColorKey_Form"
#define kChartColorKey_CrossLine @"kChartColorKey_CrossLine"

#define kChartColorKey_Rise @"kChartColorKey_Rise"
#define kChartColorKey_Fall @"kChartColorKey_Fall"
#define kChartColorKey_Stay @"kChartColorKey_Stay"

#define kChartColorKey_Text @"kChartColorKey_Text"
#define kChartColorKey_TextBorderText @"kChartColorKey_TextBorderText"
#define kChartColorKey_TextBorder @"kChartColorKey_TextBorder"
#define kChartColorKey_TextBorderBackground @"kChartColorKey_TextBorderBackground"

#define kChartColorKey_XJ @"kChartColorKey_XJ"
#define kChartColorKey_JJ @"kChartColorKey_JJ"



+ (UIColor *)colorByKey:(NSString *)key;

+ (UIColor *)drawColorByIndex:(NSInteger)index;
@end
