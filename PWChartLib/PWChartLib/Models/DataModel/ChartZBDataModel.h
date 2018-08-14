//
//  ZBDataModel.h
//  AFNetworking
//
//  Created by 王宁 on 2018/7/12.
//

#import "ChartBaseModel.h"
#import "ChartBaseViewModel.h"

@interface ChartZBDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *zbName;
@property(nonatomic , assign)NSInteger numCount;
@property(nonatomic , strong)NSMutableArray *zbDatas;
@property(nonatomic , strong)NSMutableDictionary *datas;

- (void)chackTopAndBottomPrice:(ChartBaseViewModel *)baseConfig;
@end
