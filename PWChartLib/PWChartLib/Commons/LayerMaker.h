//
//  LayerMaker.h
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LayerMaker : NSObject

+ (CAShapeLayer *)getLineLayer:(CGPoint)startPoint toPoint:(CGPoint)endPoint isDot:(BOOL)isDot;

+ (CATextLayer *)getTextLayer:(NSString *)text point:(CGPoint)point font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor frame:(CGRect)frame;
@end
