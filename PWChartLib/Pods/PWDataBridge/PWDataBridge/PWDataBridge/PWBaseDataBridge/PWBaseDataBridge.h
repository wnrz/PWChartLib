//
//  PWBaseDataBridge.h
//  UIKit
//
//  Created by wnrz on 2018/1/10.
//  Copyright © 2018年 wnrz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PWBaseDataBridgeBeforeReturnBlock)(id value , id *result);
typedef void(^PWBaseDataBridgeResultBlock)(id value);

@interface PWBaseDataBridgeActionModel : NSObject

@property (nonatomic , copy) NSString *actionName;
@property (nonatomic , copy) PWBaseDataBridgeBeforeReturnBlock beforeBlock;
@end

@interface PWBaseDataBridgeBlockModel : NSObject

@property (nonatomic , copy) PWBaseDataBridgeResultBlock block;
@property (nonatomic , copy) PWBaseDataBridgeBeforeReturnBlock beforeBlock;
@end

@interface PWBaseDataBridge : NSObject{
    NSMutableDictionary *observers;
}

@property(assign , nonatomic)int bridgeNum;
@property(copy , nonatomic)NSString *bridgeString;
@property(copy , nonatomic)NSMutableDictionary *bridgeDict;
@property(copy , nonatomic)NSMutableArray *bridgeArray;

- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath correction:(PWBaseDataBridgeBeforeReturnBlock)correction action:(SEL)action;
- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath action:(SEL)action;
- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(PWBaseDataBridgeResultBlock)block;
- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath correction:(PWBaseDataBridgeBeforeReturnBlock)correction block:(PWBaseDataBridgeResultBlock)block;
- (void)removeBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)removeBridgeObserver:(NSObject *)observer;
- (void)removeBridgeForKeyPath:(NSString *)keyPath;
- (void)removeAllBridge;
- (void)addKeyPath:(NSString *)KeyPath;
- (void)removeAllKeyPath;
- (void)sendSignalWith:(NSString *)key value:(id)value;
@end
