//
//  PWBaseDataBridge.m
//  UIKit
//
//  Created by wnrz on 2018/1/10.
//  Copyright © 2018年 wnrz. All rights reserved.
//

#import "PWBaseDataBridge.h"
#import <objc/runtime.h>

@implementation PWBaseDataBridgeActionModel

- (void)dealloc{
    _actionName = nil;
    _beforeBlock = nil;
}

@end

@implementation PWBaseDataBridgeBlockModel

- (void)dealloc{
    _block = nil;
    _beforeBlock = nil;
}

@end
#define baseDataBridgeValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
@interface PWBaseDataBridge (){
    
    NSMutableDictionary *actions;
    NSMutableDictionary *blocks;
    NSMutableArray *keyPaths;
    NSMutableArray *addKeyPath;
    NSMutableArray *propertys;
}


@end
@implementation PWBaseDataBridge

- (void)dealloc{
    [self removeAllBridge];
    [keyPaths removeAllObjects];
    keyPaths = nil;
    [observers removeAllObjects];
    observers = nil;
    [actions removeAllObjects];
    actions = nil;
    [blocks removeAllObjects];
    blocks = nil;
    [addKeyPath removeAllObjects];
    addKeyPath = nil;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        observers = [[NSMutableDictionary alloc] init];
        actions = [[NSMutableDictionary alloc] init];
        blocks = [[NSMutableDictionary alloc] init];
        keyPaths = [[NSMutableArray alloc] init];
        addKeyPath = [[NSMutableArray alloc] init];
        propertys = [[NSMutableArray alloc] init];
        [self getAllIvarList];
    }
    return self;
}

- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath action:(SEL)action{
    [self addBridgeObserver:observer forKeyPath:keyPath correction:nil action:action];
}
- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath correction:(PWBaseDataBridgeBeforeReturnBlock)correction action:(SEL)action{
    if (![keyPaths containsObject:keyPath]){
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (!objs) {
        objs = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        [observers setObject:objs forKey:keyPath];
    }
    if (![objs containsObject:observer]) {
        [objs addObject:observer];
    }
    NSString *className;// = NSStringFromClass([observer class]);
    className = [NSString stringWithFormat:@"%@_%p" , keyPath , observer];
    NSMutableDictionary *actionDict = [actions objectForKey:className];
    if (!actionDict) {
        actionDict = [[NSMutableDictionary alloc] init];
    }
    if (![[actionDict allKeys] containsObject:NSStringFromSelector(action)]) {
        PWBaseDataBridgeActionModel *actionModel = [[PWBaseDataBridgeActionModel alloc] init];
        actionModel.actionName = NSStringFromSelector(action);
        actionModel.beforeBlock = correction;
        [actionDict setObject:actionModel forKey:NSStringFromSelector(action)];
    }
    [actions setObject:actionDict forKey:className];
    if (![keyPaths containsObject:keyPath]) {
        [keyPaths addObject:keyPath];
    }
}

- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(PWBaseDataBridgeResultBlock)block{
    [self addBridgeObserver:observer forKeyPath:keyPath correction:nil block:block];
}

- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath correction:(PWBaseDataBridgeBeforeReturnBlock)correction block:(PWBaseDataBridgeResultBlock)block{
    if (![keyPaths containsObject:keyPath]){
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (!objs) {
        objs = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        [observers setObject:objs forKey:keyPath];
    }
    if (![objs containsObject:observer]) {
        [objs addObject:observer];
    }
    NSString *className;// = NSStringFromClass([observer class]);
    className = [NSString stringWithFormat:@"%@_%p" , keyPath , observer];
    PWBaseDataBridgeBlockModel *blockModel;
    if ([[blocks allKeys] containsObject:className]) {
        blockModel = [blocks objectForKey:className];
    }
    blockModel = blockModel ? blockModel : [[PWBaseDataBridgeBlockModel alloc] init];
    blockModel.block = block;
    blockModel.beforeBlock = correction;
    [blocks setObject:blockModel forKey:className];
    if (![keyPaths containsObject:keyPath]) {
        [keyPaths addObject:keyPath];
    }
}

- (void)removeBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (objs) {
        [objs removeObject:observer];
        NSString *className;// = NSStringFromClass([observer class]);
        className = [NSString stringWithFormat:@"%@_%p" , keyPath , observer];
        [actions removeObjectForKey:className];
        [blocks removeObjectForKey:className];
    }
}

- (void)removeBridgeObserver:(NSObject *)observer{
    for (int i = 0 ; i < observers.count ; i++) {
        NSString *keyPath = [observers allKeys][i];
        [self removeBridgeObserver:observer forKeyPath:keyPath];
    }
}

- (void)removeBridgeForKeyPath:(NSString *)keyPath{
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (objs) {
        for (int i = (int)objs.count - 1 ; i >= 0 ; i--) {
            id obj = [objs allObjects][i];
            [objs removeObject:obj];
            NSString *className;// = NSStringFromClass([obj class]);
            className = [NSString stringWithFormat:@"%@_%p" , keyPath , obj];
            [actions removeObjectForKey:className];
            [blocks removeObjectForKey:className];
        }
    }
}

- (void)removeAllBridge{
    for (int i = 0 ; i < keyPaths.count ; i ++) {
        NSString *keyPath = keyPaths[i];
        @try{
            [self removeObserver:self forKeyPath:keyPath];
        }@catch (NSException *error){
        }@finally{
        }
    }
    for (int i = 0 ; i < observers.count ; i++) {
        NSString *keyPath = [observers allKeys][i];
        NSHashTable *objs = [observers objectForKey:keyPath];
        if (objs) {
            [objs removeAllObjects];
        }
    }
    [observers removeAllObjects];
    [actions removeAllObjects];
    [blocks removeAllObjects];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    @autoreleasepool{
        NSHashTable *objs = [self->observers objectForKey:keyPath];
        NSArray *arr = [NSArray arrayWithArray:objs.allObjects];
        if (arr && baseDataBridgeValidArray(arr)) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!self->actions || self->actions.count == 0) {
                    *stop = YES;
                }
                @try{
                    if (obj) {
                        NSString *className;
                        className = [NSString stringWithFormat:@"%@_%p" , keyPath , obj];
                        id pra = [[change allKeys] containsObject:NSKeyValueChangeNewKey] ? change[NSKeyValueChangeNewKey] : [self->propertys containsObject:keyPath] ? [self valueForKeyPath:keyPath] : nil;
                        NSDictionary *actionDict = [self->actions objectForKey:className];//
                        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:actionDict];
                        [tmp enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                PWBaseDataBridgeActionModel *model = object;
                                NSString *actionName = model.actionName;
                                SEL action = NSSelectorFromString(actionName);
                                if (action && [obj respondsToSelector:action]) {
                                    id praResult = pra;
                                    if (model.beforeBlock) {
                                        model.beforeBlock(pra , &praResult);
                                    }
                                    IMP imp = [obj methodForSelector:action];
                                    void (*func)(id, SEL, id) = (void *)imp;
                                    func(obj, action, praResult);
                                    //                            [obj performSelector:action withObject:change];
                                }
                            });
                        }];
                        tmp = nil;
                        PWBaseDataBridgeBlockModel *model = [self->blocks objectForKey:className];
                        if (model && model.block) {
                            id praResult = pra;
                            if (model.beforeBlock) {
                                model.beforeBlock(pra , &praResult);
                            }
                            model.block(praResult);
                        }
                    }
                }@catch (NSException *error){
                    NSLog(@"PWBaseDataBridge error : %@" , error);
                }@finally{
                    
                }
            }];
            arr = nil;
        }
    }
}

- (void)addKeyPath:(NSString *)key{
    [addKeyPath addObject:key];
}

- (void)removeAllKeyPath{
    [addKeyPath removeAllObjects];
}

- (void)sendSignalWith:(NSString *)key value:(id)value{
    if ([propertys containsObject:key] || [propertys containsObject:[NSString stringWithFormat:@"_%@" , key]]) {
        [self setValue:value forKey:key];
    }else{
        if (!value) {
            value = @"";
        }
        [self observeValueForKeyPath:key ofObject:value change:@{NSKeyValueChangeNewKey:value} context:nil];
    }
}

- (void) getAllIvarList {
    unsigned int methodCount = 0;
    Ivar * ivars = class_copyIvarList([self class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
//        const char * type = ivar_getTypeEncoding(ivar);
        [propertys addObject:[NSString stringWithFormat:@"%s" , name]];
    }
    free(ivars);
}
@end
