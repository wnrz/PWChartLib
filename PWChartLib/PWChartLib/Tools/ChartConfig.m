//
//  ChartConfig.m
//  AFNetworking
//
//  Created by 王宁 on 2018/9/16.
//

#import "ChartConfig.h"

@implementation ChartConfig

+(ChartConfig *)shareConfig{
    //使用单一线程，解决网络同步请求的问题
    static ChartConfig* shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ChartConfig alloc] init];
        shareInstance.fontName = @"Helvetica Neue";
        shareInstance.fontSize = 10;
        shareInstance.chartLineWidth = 1;
    });
    return shareInstance;
}
@end
