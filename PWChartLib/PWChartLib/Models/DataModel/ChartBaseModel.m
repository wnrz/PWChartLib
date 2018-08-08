//
//  BaseModel.m
//  FAFViewTest
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChartBaseModel.h"

@implementation ChartBaseModel

- (id)initWithDictionary:(id)d{
    self = [super init];
    if (self) {
        if ([d isKindOfClass:[NSDictionary class]] || [d isKindOfClass:[NSMutableDictionary class]]) {
            _dict = [[NSMutableDictionary alloc] initWithDictionary:d];
        }
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKey:(id)aKey{
    return [self objectForKeyedSubscript:aKey];
}

- (id)objectForKeyedSubscript:(id )key{
    id data = [_dict objectForKey:key];
    if ([key length] > 4 && [[key substringToIndex:4] isEqualToString:@"kNum"]) {
        if ((nil != data) && ([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSString class]])) {
            return data;
        }else{
            return @0;
        }
    }else if([key length] > 4 && [[key substringToIndex:4] isEqualToString:@"kStr"]){
        if ((nil != data) && ([data isKindOfClass:[NSString class]]) && ([data length] > 0) && (![data isEqualToString:@"(null)"]) && ((NSNull *) data != [NSNull null])) {
            return data;
        }else{
            return @"";
        }
    }else if([key length] > 4 && [[key substringToIndex:4] isEqualToString:@"kArr"]){
        if ((nil != data) && [data isKindOfClass:[NSArray class]] && [data count] > 0) {
            return data;
        }else{
            return @[];
        }
    }
    return data;
}

- (void)setObject:(id)obj forKeyedSubscript:(id )key{
    if ([_dict isKindOfClass:[NSMutableDictionary class]]) {
        [_dict setObject:obj forKeyedSubscript:key];
    }else if ([_dict isKindOfClass:[NSDictionary class]]){
        _dict = [[NSMutableDictionary alloc] initWithDictionary:_dict copyItems:YES];
        [_dict setObject:obj forKeyedSubscript:key];
    }
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx{

    return nil;
}
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{

}

- (BOOL)isEqual:(id)object
{
    if ( [object isKindOfClass:[self class]] ) {
        return [super isEqual:object];
    }
    
    return NO;
}

- (BOOL)isValidateString:(NSString *)str {
    if ( (![str isEqualToString:@"(null)"]) && ((NSNull *) str != [NSNull null]) && nil != str ) {
        return YES;
    }
    return NO;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ChartBaseModel *model = [[ChartBaseModel alloc] initWithDictionary:[self.dict copy]];
    return model;
}

@end
