//
//  HQDataModel.h
//  FAFViewTest
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChartBaseModel.h"

@interface ChartHQDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *code;
@property(nonatomic , copy)NSString *market;
@property(nonatomic , copy)NSString *name;
@property(nonatomic , copy)NSString *closePrice;
@property(nonatomic , copy)NSString *yclosePrice;
@property(nonatomic , copy)NSString *openPrice;
@property(nonatomic , copy)NSString *topPrice;
@property(nonatomic , copy)NSString *bottomPrice;
@property(nonatomic , copy)NSString *nowPrice;
@property(nonatomic , copy)NSString *volume;
@property(nonatomic , copy)NSString *amount;
@property(nonatomic , assign)NSInteger digit;


@end
