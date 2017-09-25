//
//  NSObject+JSON.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/8/31.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

- (NSString *)JSONString {
    /*
     必须满足以下条件才可以转换成为JSON数据
     - 顶层是NSArray 或者 NSDictionary
     - 所有的对象必须是 NSString, NSNumber, NSArray, NSDictionary, 或者 NSNull
     - 所有NSDictionary的键必须是NSString
     - NSNumber不能为NaN 或者 无穷大.
     以后可能还会增加其他规则
     */
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    NSError *error = nil;
    //The resulting data is a encoded in UTF-8
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSAssert(YES, error.localizedDescription);
        return nil;
    }
    return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}

@end
