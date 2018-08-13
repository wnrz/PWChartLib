//
//  LayerMaker.h
//  Pods-PWChartLibExample
//
//  Created by 王宁 on 2018/8/9.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CandlestickModel : NSObject
@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) CGFloat close;
@property (nonatomic , assign) CGFloat open;
@end

@interface LayerMaker : NSObject

+ (CAShapeLayer *)getLineLayer:(NSArray *)points isDot:(BOOL)isDot;

+ (CAShapeLayer *)getLineLayer:(CGPoint)startPoint toPoint:(CGPoint)endPoint isDot:(BOOL)isDot;

+ (CATextLayer *)getTextLayer:(NSString *)text point:(CGPoint)point font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor frame:(CGRect)frame;

+ (CAShapeLayer *)getLineChartLayer:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom arr:(NSArray *)arr start:(NSInteger)start startX:(NSInteger)startX;

+ (CAGradientLayer *)drawGredientLayer:(CGRect)showFrame path:(CGPathRef)path color:(UIColor *)color;

//lintType:0、蜡烛线  1、空心线  2、美国线
+ (CALayer *)getCandlestickLine:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom models:(NSArray *)models clrUp:(UIColor *)clrUp clrDown:(UIColor *)clrDown clrBal:(UIColor *)clrBal start:(NSInteger)start lineType:(NSInteger)lintType;
@end
