//
//  NSString+Hashing.h
//  DKNetwork
//
//  Created by 刘康09 on 2017/9/1.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 iOS CommonCrypto库提供了对MD， SHA-1 SHA-256摘要以及其他不太常用的加密算法的支持。该分类专注于MD5 SHA-1 SHA-256。对于所有的CommonCryto摘要算法，生成哈希值的过程是一致的。可以通过一些列函数调用创建摘要上下文来手工创建哈希值，然后使用待处理的数据更新上下文，最后获取摘要计算的值，也可以使用每个摘要算法提供的便捷函数。
 */

typedef NS_ENUM(NSInteger, DKHashType) {
    DKHashTypeMD5 = 1,
    DKHashTypeSHA1,
    DKHashTypeSHA256
};

@interface NSString (Hashing)

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)hashWithType:(DKHashType)type;

- (NSString *)hamcWithKey:(NSString *)key;

@end
