//
//  DKNetworkResponse.h
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/15.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKNetworkResponse : NSObject

@property (nonatomic, copy) NSDictionary *originDataDictionary;
@property (nonatomic) NSError *error;
@property (nonatomic, readonly) NSInteger businessCode;
@property (nonatomic, copy, readonly) NSDictionary *responseDictionary; //最终model存放的地方
@property (nonatomic, readonly) NSHTTPURLResponse *HTTPResponse;

- (instancetype)initWithData:(NSData *)data URLResponse:(NSURLResponse *)URLResponse;

@end
