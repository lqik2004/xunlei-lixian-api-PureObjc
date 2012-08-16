//
//  URlEncode.h
//  http
//
//  Created by liuchao on 6/20/12.
//  Copyright (c) 2012 HwaYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URlEncode : NSObject

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

@end
