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

@property(nonatomic , assign)double topPrice;  //最高价格
@property(nonatomic , assign)double bottomPrice;  //最低价格
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

- (void)SyncParameter:(ChartBaseViewModel *)con;
@end
