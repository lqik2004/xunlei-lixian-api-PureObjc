//
//  ZZHTTPConnection.h
//  TondarAPI
//
//  Created by Martian on 12-7-29.
//  Copyright (c) 2012年 MartianZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHTTPConnection : NSObject <NSURLConnectionDelegate> {
    @public
    NSMutableDictionary *_cookies;
}

+ (ZZHTTPConnection *)sharedZZHTTPConnection;
- (NSString *)get:(NSString *)urlString;
- (NSString*)post:(NSString*)urlString withBody:(NSString *)bodyData;


@end
