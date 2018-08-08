//
//  ZBDataModel.h
//  AFNetworking
//
//  Created by 王宁 on 2018/7/12.
//

#import "ChartBaseModel.h"

@interface ChartZBDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *zbName;
@property(nonatomic , copy)NSMutableArray *zbDatas;
@end
