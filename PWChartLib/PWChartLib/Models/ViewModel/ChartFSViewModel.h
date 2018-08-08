//
//  ChartFSViewModel.h
//  ChartLib
//
//  Created by 王宁 on 2018/8/8.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartFSDataModel.h"

@interface ChartFSViewModel : NSObject

@property (nonatomic , strong)NSMutableArray<ChartFSDataModel *> *fsDatas;
@end
