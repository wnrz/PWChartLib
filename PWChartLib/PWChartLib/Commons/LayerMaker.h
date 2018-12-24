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

@interface StickModel : NSObject
@property (nonatomic , copy) UIColor *color;
@property (nonatomic , assign) CGFloat value;
@end

@interface LayerMakerLineModel : NSObject
@property (nonatomic , strong) NSArray *points;
@property (nonatomic , assign) CGPoint startPoint;
@property (nonatomic , assign) CGPoint endPoint;
@property (nonatomic , assign) BOOL isDot;
@end

@interface LayerMakerDataModel : NSObject
@property (nonatomic , assign) CGRect showFrame;
@property (nonatomic , assign) CGFloat total;
@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) NSInteger start;

@end

@interface LayerMakerLineChartDataModel : LayerMakerDataModel
@property (nonatomic , strong) NSArray *lineChartDatas;
@property (nonatomic , assign) NSInteger startX;

@end

@interface LayerMakerCandlestickDataModel : LayerMakerDataModel
@property (nonatomic , strong) NSArray<CandlestickModel *> *candlestickDatas;
@property (nonatomic , strong) UIColor *clrUp;
@property (nonatomic , strong) UIColor *clrDown;
@property (nonatomic , strong) UIColor *clrBal;
@property (nonatomic , assign) NSInteger lineType;

@end

@interface LayerMakerStickDataModel : LayerMakerDataModel
@property (nonatomic , strong) NSArray<StickModel *> *stickDatas;
@property (nonatomic , assign) CGFloat lineWidth;

@end

@interface LayerMakerTextModel : NSObject
@property (nonatomic , strong) UIFont * font;
@property (nonatomic , strong) UIColor * foregroundColor;
@property (nonatomic , assign) CGRect frame;
@property (nonatomic , copy) NSString *text;
@property (nonatomic , assign) NSInteger digit;
@end

@interface LayerMaker : NSObject

+ (CAShapeLayer *)getMultiplePointLineLayer:(LayerMakerLineModel *)lineModel;

+ (CAShapeLayer *)getTwoPointLineLayer:(LayerMakerLineModel *)lineModel;

+ (CATextLayer *)getTextLayer:(LayerMakerTextModel *)textModel;

+ (CAShapeLayer *)getLineChartLayer:(LayerMakerLineChartDataModel *)lineChartDataModel;

+ (CAGradientLayer *)drawGredientLayer:(CGRect)showFrame path:(CGPathRef)path fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

//lintType:0、蜡烛线  1、空心线  2、美国线
+ (CALayer *)getCandlestickLine:(LayerMakerCandlestickDataModel *)candlestickDataModel;

+ (CALayer *)getCandlestickLineTopAndBottomValue:(LayerMakerCandlestickDataModel *)candlestickDataModel textLayer:(LayerMakerTextModel *)textModel;

+ (CALayer *)getStickLine:(LayerMakerStickDataModel *)stickDataModel;

+ (CALayer *)drawImages:(CGRect)showFrame total:(float)total top:(float)top bottom:(float)bottom image:(UIImage *)image array:(NSArray *)array isBuy:(BOOL)isBuy;
@end
