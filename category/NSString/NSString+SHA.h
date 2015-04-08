//
//  NSString+SHA.h
//  ParkHereCoupon
//
//  Created by liu poolo on 15/4/8.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (SHA)

- (NSString*) sha1;
- (NSString*) sha224;
- (NSString*) sha256;
- (NSString*) sha384;
- (NSString*) sha512;

@end
