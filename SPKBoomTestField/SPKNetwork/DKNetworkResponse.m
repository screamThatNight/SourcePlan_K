//
//  DKNetworkResponse.m
//  SPKBoomTestField
//
//  Created by 刘康09 on 2017/9/15.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "DKNetworkResponse.h"

@implementation DKNetworkResponse

- (instancetype)initWithData:(NSData *)data URLResponse:(NSURLResponse *)URLResponse {
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            _originDataDictionary = dataDictionary;
            _businessCode = [dataDictionary[@"errno"] integerValue];
            id resp = dataDictionary[@"response"];
            if ([resp isKindOfClass:[NSDictionary class]]) {
                _responseDictionary = (NSDictionary *)resp;
            }
        }
        _error = error;
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)URLResponse;
        _HTTPResponse = HTTPResponse;
    }
    return self;
}

@end
