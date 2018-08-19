//
//  ZBDataModel.h
//  AFNetworking
//
//  Created by 王宁 on 2018/7/12.
//

#import "ChartBaseModel.h"
#import "ChartBaseViewModel.h"

@interface ChartPureZBOnewDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *sName;
@property(nonatomic , strong)NSMutableArray *linesArray;
@property(nonatomic , strong)UIColor *color;
@property(nonatomic , assign)NSInteger type;
@property(nonatomic , assign)NSInteger start;

@end
@interface ChartPureZBDataModel : ChartBaseModel

@property(nonatomic , copy)NSString *zbName;
@property(nonatomic , assign)NSInteger numCount;
@property(nonatomic , strong)NSMutableArray *zbDatas;
@property(nonatomic , strong)NSMutableDictionary *datas;

- (void)chackTopAndBottomPrice:(ChartBaseViewModel *)baseConfig;
@end
