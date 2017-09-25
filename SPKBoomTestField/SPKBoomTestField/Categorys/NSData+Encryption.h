//
//  NSData+Encryption.h
//  DKNetwork
//
//  Created by 刘康09 on 2017/9/1.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

//data的本质是啥
- (NSData *)encryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv;
- (NSData *)decryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv;

- (NSData *)encryptedWith3DESUsingKey:(NSString *)key andIV:(NSData *)iv;
- (NSData *)decryptedWith3DESUsingKey:(NSString *)key andIV:(NSData *)iv;

//+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
//- (id)initWithBase64EncodedString:(NSString *)string;
//- (id)initWithBase64EncodedString:(NSString *)base64String options:(NSDataBase64DecodingOptions)options

//一部分方法已经在iOS7内具备
//- (NSString *)base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options

@end
