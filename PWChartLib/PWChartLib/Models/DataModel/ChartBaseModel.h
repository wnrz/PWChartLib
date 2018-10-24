//
//  BaseModel.h
//  FAFViewTest
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ModelEmptyString ([NSString stringWithFormat:@""])

@interface ChartBaseModel : NSObject<NSCopying>

@property(nonatomic , strong)NSMutableDictionary *dict;

- (id)initWithDictionary:(id)d;
- (id)objectForKey:(id)aKey;

- (id)objectForKeyedSubscript:(id )key;
- (void)setObject:(id)obj forKeyedSubscript:(id )key;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

- (BOOL)isValidateString:(NSString *)str;
@end
