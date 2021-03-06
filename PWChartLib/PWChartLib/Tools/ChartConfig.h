//
//  ChartConfig.h
//  AFNetworking
//
//  Created by 王宁 on 2018/9/16.
//

#import <PWDataBridge/PWBaseDataBridge.h>

@interface ChartConfig : PWBaseDataBridge

@property (nonatomic , copy) NSString *fontName;
@property (nonatomic , assign) int fontSize;

@property (nonatomic , strong)NSDictionary *chartColors;
@property (nonatomic , strong)NSArray *lineColors;

@property (nonatomic , assign) CGFloat chartLineWidth;

@property (nonatomic, copy) CALayer * (^lastFSPointLayer)();
+ (ChartConfig *)shareConfig;

//+ (CABasicAnimation *)opacityForever_Animation:(float)time;
+ (CALayer *)flashPointLayer:(UIColor *)color;
@end
