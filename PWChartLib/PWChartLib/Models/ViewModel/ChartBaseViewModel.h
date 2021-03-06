//
//  ChartBaseViewModel.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWDataBridge/PWDataBridge.h>
#import "ChartHQDataModel.h"

typedef enum{
    BottomDataType_Time = 0,
    BottomDataType_Date,
    BottomDataType_DateAndTime,
} BottomDataType;  //底部显示类型

@interface ChartBaseViewModel : PWBaseDataBridge

@property (nonatomic , strong)ChartHQDataModel *hqData;

@property(nonatomic , assign)CGRect showFrame;
@property(nonatomic , assign)CGFloat offsetLeft;
@property(nonatomic , assign)CGFloat offsetTop;
@property(nonatomic , assign)CGFloat offsetRight;
@property(nonatomic , assign)CGFloat offsetBottom;

@property(nonatomic , assign)double topPrice;  //最高价格
@property(nonatomic , assign)double bottomPrice;  //最低价格

@property (nonatomic , assign)BOOL independentTopBottomPrice; //是否分开处理最高最低值 虚拟币绘图时会有用到
@property(nonatomic , strong)NSMutableDictionary *topPrices;  //最高价格 字典 根据数据的属性名作为key 虚拟币可能有多个线 和多个左侧单位
@property(nonatomic , strong)NSMutableDictionary *bottomPrices;  //最低价格 字典 根据数据的属性名作为key 虚拟币可能有多个线 和多个左侧单位

@property(nonatomic , assign)BOOL showCrossLine;  //是否显示交叉线
@property(nonatomic , assign)CGPoint showCrossLinePoint;  //交叉线坐标

@property(nonatomic , assign)NSInteger showIndex;  //显示的数据条
//分时属性
@property(nonatomic , assign)NSInteger maxPointCount;  //最多多少个点

//k线属性
@property(nonatomic , assign)NSInteger maxShowNum;  //最大显示条数
@property(nonatomic , assign)NSInteger minShowNum;  //最小显示条数
@property(nonatomic , assign)NSInteger currentIndex;  //当前显示点
@property(nonatomic , assign)NSInteger currentShowNum;  //显示条数

@property(nonatomic , assign)NSInteger digit;  //小数位

@property(nonatomic , strong)NSArray *verticalSeparateArr; //有多少个 横向 分割线 实线 最小0 最大1
@property(nonatomic , strong)NSArray *horizontalSeparateArr;  //有多少个 纵向 分割线  实线 最小0 最大1
@property(nonatomic , strong)NSArray *verticalSeparateDottedArr; //有多少个 横向 分割线 虚线 最小0 最大1
@property(nonatomic , strong)NSArray *horizontalSeparateDottedArr;  //有多少个 纵向 分割线 虚线 最小0 最大1

@property(nonatomic , assign)BOOL isLeftRiseFallColor;  //左侧是否显示涨跌色
@property(nonatomic , assign)BOOL isRightRiseFallColor;  //右侧是否显示涨跌色
@property(nonatomic , assign)BOOL isDrawLeftText;  //左侧是否显示文字
@property(nonatomic , assign)BOOL isDrawRightText;  //右侧是否显示文字
@property(nonatomic , assign)BOOL isDrawCrossLeftText;  //左侧是否显示十字星文字
@property(nonatomic , assign)BOOL isDrawCrossRightText;  //右侧是否显示十字星文字

@property (nonatomic , assign)BottomDataType showBottomType; // 是否时间显示日期
- (void)SyncParameter:(ChartBaseViewModel *)con;
@end
