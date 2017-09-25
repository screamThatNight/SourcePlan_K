//
//  NSString+Hashing.m
//  DKNetwork
//
//  Created by 刘康09 on 2017/9/1.
//  Copyright © 2017年 liukang09. All rights reserved.
//

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Hashing)

- (NSString *)md5 {
    return [self hashWithType:DKHashTypeMD5];
}

- (NSString *)sha1 {
    return [self hashWithType:DKHashTypeSHA1];
}

- (NSString *)sha256 {
    return [self hashWithType:DKHashTypeSHA256];
}

- (NSString *)hashWithType:(DKHashType)type {
    const char *ptr = [self UTF8String];
    
    NSInteger bufferSize;
    switch (type) {
        case DKHashTypeMD5: {
            // 16 bytes
            bufferSize = CC_MD5_DIGEST_LENGTH;
            break;
        }
        case DKHashTypeSHA1: {
            //20 bytes
            bufferSize = CC_SHA1_DIGEST_LENGTH;
            break;
        }
        case DKHashTypeSHA256: {
            //32 bytes
            bufferSize = CC_SHA256_DIGEST_LENGTH;
            break;
        }
        default:
            return nil;
            break;
    }
    
    unsigned char buffer[bufferSize];
    
    switch (type) {
        case DKHashTypeMD5: {
            CC_MD5(ptr, (unsigned int)strlen(ptr), buffer);
            break;
        }
        case DKHashTypeSHA1: {
            CC_SHA1(ptr, (unsigned int)strlen(ptr), buffer);
            break;
        }
        case DKHashTypeSHA256: {
            CC_SHA256(ptr, (unsigned int)strlen(ptr), buffer);
            break;
        }
        default:
            return nil;
            break;
    }
    
    NSMutableString *hashString = [NSMutableString stringWithCapacity:bufferSize * 2];
    for (int i = 0; i < bufferSize; i++) {
        //02 表示不足两位，前面补0输出 X 表示以十六进制形式输出 出过两位，不影响 写的很好 里面还有更加细节的东西
        [hashString appendFormat:@"%02x", buffer[i]];
    }
    
    return hashString;
}

- (NSString *)hamcWithKey:(NSString *)key {
    const char *ptr = [self UTF8String];
    const char *keyPtr = [key UTF8String];
    
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyPtr, kCCKeySizeAES256, ptr, (unsigned int)strlen(ptr), buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", buffer[i]];
    }
    
    return output;
}

//密钥版本化

@end
