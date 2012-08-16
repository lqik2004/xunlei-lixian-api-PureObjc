//
//  ZZHTTPConnection.m
//  TondarAPI
//
//  Created by Martian on 12-7-29.
//  Copyright (c) 2012年 MartianZ. All rights reserved.
//

#import "ZZHTTPConnection.h"

@implementation ZZHTTPConnection


- (id)init {
    if (self = [super init]) {
        _cookies = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

+ (ZZHTTPConnection *)sharedZZHTTPConnection {
    static ZZHTTPConnection *_sharedZZHTTPConnection = nil;
    if (!_sharedZZHTTPConnection) {
        _sharedZZHTTPConnection = [[self alloc] init];
    }
    return _sharedZZHTTPConnection;
}

//发送GET请求
- (NSString *)get:(NSString *)urlString {
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] init];
    
    _urlRequest = [[NSMutableURLRequest alloc] init];
    [_urlRequest addValue:@"User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.106 Safari/535.2" forHTTPHeaderField:@"User-Agent"];
    [_urlRequest setTimeoutInterval: 15];
    [_urlRequest addValue:@"http://lixian.vip.xunlei.com/" forHTTPHeaderField:@"Referer"];
    [_urlRequest addValue:@"text/xml" forHTTPHeaderField: @"Content-Type"];
    [_urlRequest setURL:[NSURL URLWithString:urlString]];
    [_urlRequest setHTTPMethod:@"GET"];
    /*
    NSMutableString *cookie_str = [[NSMutableString alloc] init];
    for (NSString *keys in [_cookies allKeys]) {
        [cookie_str setString:[cookie_str stringByAppendingFormat:@"%@=%@; ", keys, [_cookies objectForKey:keys]]];
    }
    [_urlRequest setValue:cookie_str forHTTPHeaderField:@"Cookie"];
    */
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&urlResponse error:&error];

    
    NSString *responseResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"]) {
        NSArray *cookies = [[[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"] componentsSeparatedByString:@","];
        for (NSString *cookie in cookies) {
            NSString *key_value = [[cookie componentsSeparatedByString:@";"] objectAtIndex:0];
            
            NSString *key = [[[key_value componentsSeparatedByString:@"="] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *value = [[[key_value componentsSeparatedByString:@"="] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [_cookies setValue:value forKey:key];
        }
    }
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
		return responseResult;
    else
        return nil;
}

//发送POST请求
- (NSString*)post:(NSString*)urlString withBody:(NSString *)bodyData {
    
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] init];

    [_urlRequest setURL:[NSURL URLWithString:urlString]];
    [_urlRequest setHTTPMethod:@"POST"];
    [_urlRequest addValue:@"text/xml" forHTTPHeaderField: @"Content-Type"];
    NSData *requestData = [NSData dataWithBytes: [bodyData UTF8String] length: [bodyData length]];
    [_urlRequest setHTTPBody:requestData];
    
    NSMutableString *cookie_str = [[NSMutableString alloc] init];
    for (NSString *keys in [_cookies allKeys]) {
        [cookie_str setString:[cookie_str stringByAppendingFormat:@"%@=%@; ", keys, [_cookies objectForKey:keys]]];
    }
    [_urlRequest setValue:cookie_str forHTTPHeaderField:@"Cookie"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&urlResponse error:NULL];
    NSString *responseResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    if ([[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"]) {
        NSArray *cookies = [[[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"] componentsSeparatedByString:@","];
        for (NSString *cookie in cookies) {
            
            
            NSString *key_value = [[cookie componentsSeparatedByString:@";"] objectAtIndex:0];
            
            if ([[key_value componentsSeparatedByString:@"="] count] < 2) {
                continue;
            }
            NSString *key = [[[key_value componentsSeparatedByString:@"="] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *value = [[[key_value componentsSeparatedByString:@"="] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
           
            
            [_cookies setValue:value forKey:key];
        }
    }
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
		return responseResult;
    else
        return nil;
}

@end
