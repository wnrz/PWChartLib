//
//  CommonMacro.h
//  
//
//  Created by mac on 2018/4/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h


//属性是否有效判断
#define chartIsValidArr(arr) ((arr && [arr isKindOfClass:[NSArray class]] && [arr count] > 0))
#define chartIsValidDic(dic) (nil != dic && [dic isKindOfClass:[NSDictionary class]] && [dic count] > 0)
#define chartIsValidString(str) ((nil != str) && ([str isKindOfClass:[NSString class]]) && ([str length] > 0) && (![str isEqualToString:@"(null)"]) && (![str isEqualToString:@"null"]) &&((NSNull *) str != [NSNull null]))
#define chartIsValidBool(num) (num == 0 || num == 1)
#define chartIsValidLenString(str , minLength) ((nil != str) && ([str isKindOfClass:[NSString class]]) && ([str length] >= minLength) && (![str isEqualToString:@"(null)"]) && (![str isEqualToString:@"null"]) &&((NSNull *) str != [NSNull null]))

#define chartScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define chartScreenHeight   [[UIScreen mainScreen] bounds].size.height

#endif /* CommonMacro_h */
