//
//  ChartConfig.h
//  AFNetworking
//
//  Created by 王宁 on 2018/9/16.
//

#import "PWBaseDataBridge.h"

@interface ChartConfig : PWBaseDataBridge

@property (nonatomic , copy) NSString *fontName;
@property (nonatomic , assign) int fontSize;
+ (ChartConfig *)shareConfig;
@end
