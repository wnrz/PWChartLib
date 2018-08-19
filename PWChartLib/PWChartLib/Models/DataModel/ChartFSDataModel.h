//
//  FSDataModel.h
//  FAFViewTest
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChartBaseModel.h"

@interface ChartFSDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *avgPrice;
@property(nonatomic , copy)NSString *nowPrice;
@property(nonatomic , copy)NSString *thirdLine;
@property(nonatomic , copy)NSString *avgVol;
@property(nonatomic , copy)NSString *nowVol;
@property(nonatomic , copy)NSString *time;
@property(nonatomic , copy)NSString *date;
@property(nonatomic , copy , nonnull)NSString *timeStamp;

@property(nonatomic , weak)ChartFSDataModel *perFSModel;

- (void)storeFromDict:(NSDictionary *)dict;
@end
