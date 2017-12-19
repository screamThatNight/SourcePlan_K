//
//  DKNetworkErrorManager.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/8/31.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "DKNetworkError.h"

@implementation DKNetworkError

/*
 NSError 对象有如下3个主要属性:
 - code 标识错误的NSInteger值。 对于产生该错误的错误域来说，这个值是唯一的。
 - domain - 错误域的NSString指针。如 NSPOSIXErrorDomain NSOSStatusErrorDomain NSMachErrorDomain。 ->大部分来自于 CFNetworkError.h中定义的错误代码 目前有kCFURLError
 - userInfo - NSDictionary指针，包含特定于错误的值。
 */

- (id)fetchMyStuff:(NSURL *)url error:(NSError **)error {
    BOOL errorOccurred = NO;
    
    //some code that makes a call and may fail
    
    if (errorOccurred) {
        NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
        [errorDict setValue:@"Fail to fetch my stuff" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"myDomain" code:111 userInfo:errorDict];
        return nil;
    }
    
    // return what you want to return
    
    return nil;
}

- (void)six_one {
  
    
}



@end
