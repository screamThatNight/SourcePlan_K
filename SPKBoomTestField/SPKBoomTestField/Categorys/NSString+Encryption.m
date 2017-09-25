//
//  NSString+Encryption.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/9/1.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "NSString+Encryption.h"
#import "NSData+Encryption.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Encryption)

- (NSString *)encryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptedWithAESUsingKey:key andIV:iv];
    
    //该方法被废弃
    NSString *encryptedString = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptedString;
}

@end
