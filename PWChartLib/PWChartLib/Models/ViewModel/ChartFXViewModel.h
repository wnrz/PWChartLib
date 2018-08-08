//
//  ChartFXViewModel.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartFXDataModel.h"

@interface ChartFXViewModel : NSObject

@property (nonatomic , strong)NSMutableArray<ChartFXDataModel *> *fxDatas;
@end
