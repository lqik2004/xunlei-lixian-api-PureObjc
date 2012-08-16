//
//  md5.h
// 
//
//  Created by Liu Chao on 6/10/12.
//  Copyright (c) 2012 HwaYing. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

@interface md5 : NSObject

+(NSString *) md5HexDigestwithString:(NSString *) aString;

@end
