//
//  NSObject+Swizzling.h
//  NSobject
//
//  Created by  on 2017/4/6.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ChartSwizzling)
+(void)chartSwizzleMethod:(SEL)origoinalSelector swizzledSelector:(SEL)swizzledMethod;
@end
