//
//  CALayer+Contents.m
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import "CALayer+Contents.h"
#import "NSObject+ChartSwizzling.h"

@implementation CALayer (Contents)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [CALayer chartSwizzleMethod:@selector(actionForKey:) swizzledSelector:@selector(chartActionForKey:)];
        }
    });
}

- (id<CAAction>)chartActionForKey:(NSString *)key
{
//    if ([key isEqualToString: @"contents"])
//    {
//        return nil;
//    }
    
    return [self chartActionForKey: key];
}
@end
