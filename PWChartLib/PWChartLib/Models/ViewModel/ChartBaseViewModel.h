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

@interface ChartBaseViewModel : PWBaseDataBridge

@property (nonatomic , strong)ChartHQDataModel *hqData;

@property(nonatomic)double topPrice;  //最高价格
@property(nonatomic)double bottomPrice;  //最低价格
@property(nonatomic)BOOL showCrossLine;  //是否显示交叉线
@property(nonatomic)CGPoint showCrossLinePoint;  //交叉线坐标


@property(nonatomic)NSInteger showIndex;  //显示的数据条
//分时属性
@property(nonatomic)NSInteger maxPointCount;  //最多多少个点

//k线属性
@property(nonatomic)NSInteger maxShowNum;  //最大显示条数
@property(nonatomic)NSInteger minShowNum;  //最小显示条数
@property(nonatomic)NSInteger currentIndex;  //当前显示点
@property(nonatomic)NSInteger currentShowNum;  //显示条数

@end
