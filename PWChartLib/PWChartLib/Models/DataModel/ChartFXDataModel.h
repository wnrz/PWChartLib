//
//  FXDataModel.h
//  FAFViewTest
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChartBaseModel.h"

@interface ChartFXDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *openPrice;
@property(nonatomic , copy)NSString *topPrice;
@property(nonatomic , copy)NSString *bottomPrice;
@property(nonatomic , copy)NSString *closePrice;
@property(nonatomic , copy)NSString *volume;
@property(nonatomic , copy)NSString *amount;
@property(nonatomic , copy)NSString *time;
@property(nonatomic , copy)NSString *date;
@property(nonatomic , copy)NSString *timeStamp;

@property(nonatomic , weak)ChartFXDataModel *perFXModel;


@end
