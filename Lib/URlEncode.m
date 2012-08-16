//
//  URlEncode.m
//  http
//
//  Created by liuchao on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "URlEncode.h"

@implementation URlEncode

+ (NSString *)encodeToPercentEscapeString: (NSString *) input  
{  
    // Encode all the reserved characters, per RFC 3986  
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                            (__bridge CFStringRef)input,  
                                            NULL,  
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",  
                                            kCFStringEncodingUTF8));
    return outputStr;  
}  

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input  
{  
    NSMutableString *outputStr = [NSMutableString stringWithString:input];  
    [outputStr replaceOccurrencesOfString:@"+"  
                               withString:@" "  
                                  options:NSLiteralSearch  
                                    range:NSMakeRange(0, [outputStr length])];  
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
}  

@end
