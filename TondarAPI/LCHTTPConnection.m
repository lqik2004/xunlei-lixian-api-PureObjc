//
//  LCHTTPConnection.m
//  TondarAPI
//
//  Created by Martian on 12-9-29.
//  Copyright (c) 2012年 LiuChao. All rights reserved.
//

#import "LCHTTPConnection.h"

@interface LCHTTPConnection()
@property NSMutableArray *postData;
@end

@implementation LCHTTPConnection
@synthesize postData;


+ (LCHTTPConnection *)sharedZZHTTPConnection {
    static LCHTTPConnection *_sharedZZHTTPConnection = nil;
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
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString *cookie_str = [[NSMutableString alloc] init];
    for(NSHTTPCookie *cookie in [cookieJar cookies]){
        if([cookie.domain hasSuffix:@".xunlei.com"]){
            [cookie_str setString:[cookie_str stringByAppendingFormat:@"%@=%@; ", cookie.name, cookie.value]];
        }
    }
    [_urlRequest setValue:cookie_str forHTTPHeaderField:@"Cookie"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&urlResponse error:&error];
    
    NSString *responseResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"]) {
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:[urlResponse allHeaderFields] forURL:[NSURL URLWithString:@".vip.xunlei.com"]];
        for(NSHTTPCookie *t in cookies){
            [self setCookieWithKey:t.name Value:t.value];
        }
    }
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 400)
		return responseResult;
    else
        return nil;
}

-(void) setPostValue:(NSString*) value forKey:(NSString*) key{
    // Remove any existing value
	NSUInteger i;
	for (i=0; i<[[self postData] count]; i++) {
		NSDictionary *val = [[self postData] objectAtIndex:i];
		if ([[val objectForKey:@"key"] isEqualToString:key]) {
			[[self postData] removeObjectAtIndex:i];
			i--;
		}
	}
    if (!key) {
		return;
	}
	if (![self postData]) {
		[self setPostData:[NSMutableArray array]];
	}
	NSMutableDictionary *keyValuePair = [NSMutableDictionary dictionaryWithCapacity:2];
	[keyValuePair setValue:key forKey:@"key"];
	[keyValuePair setValue:[value description] forKey:@"value"];
	[[self postData] addObject:keyValuePair];
}

//发送POST请求
- (NSString*)post:(NSString*)urlString withBody:(NSString *)bodyData{
    
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] init];
    
    [_urlRequest setURL:[NSURL URLWithString:urlString]];
    [_urlRequest setHTTPMethod:@"POST"];
    [_urlRequest addValue:@"text/xml" forHTTPHeaderField: @"Content-Type"];
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [_urlRequest addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
    
    // define boundary separator...
    NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
    //adding the body...
    NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
    // Adds post data
	NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
	NSUInteger i=0;
	for (NSDictionary *val in [self postData]) {
        [postBody appendData:[(NSString*)[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[val objectForKey:@"key"]] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[val objectForKey:@"value"] dataUsingEncoding:NSUTF8StringEncoding]];
		i++;
		if (i != [[self postData] count]) { //Only add the boundary if this is not the last item in the post body
			[postBody appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
    [_urlRequest setHTTPBody:postBody];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString *cookie_str = [[NSMutableString alloc] init];
    for(NSHTTPCookie *cookie in [cookieJar cookies]){
        if([cookie.domain hasSuffix:@".xunlei.com"]){
            [cookie_str setString:[cookie_str stringByAppendingFormat:@"%@=%@; ", cookie.name, cookie.value]];
        }
    }
    [_urlRequest setValue:cookie_str forHTTPHeaderField:@"Cookie"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&urlResponse error:NULL];
    NSString *responseResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"]) {
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:[urlResponse allHeaderFields] forURL:[NSURL URLWithString:@".vip.xunlei.com"]];
        for(NSHTTPCookie *t in cookies){
            [self setCookieWithKey:t.name Value:t.value];
        }
    }
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 400)
		return responseResult;
    else
        return nil;
}

-(NSString*) post:(NSString*) urlString{
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] init];
    
    [_urlRequest setURL:[NSURL URLWithString:urlString]];
    [_urlRequest setHTTPMethod:@"POST"];
    [_urlRequest addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSMutableString *postValueStr=[NSMutableString new];
    for(NSDictionary *kv in [self postData]){
        [postValueStr setString:[postValueStr stringByAppendingFormat:@"%@=%@&",[kv objectForKey:@"key"],[kv objectForKey:@"value"] ]];
    }
    NSLog(@"hahah:%@",postValueStr);
    [_urlRequest setHTTPBody:[postValueStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString *cookie_str = [[NSMutableString alloc] init];
    for(NSHTTPCookie *cookie in [cookieJar cookies]){
        if([cookie.domain hasSuffix:@".xunlei.com"]){
            [cookie_str setString:[cookie_str stringByAppendingFormat:@"%@=%@; ", cookie.name, cookie.value]];
        }
    }
    [_urlRequest setValue:cookie_str forHTTPHeaderField:@"Cookie"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:_urlRequest returningResponse:&urlResponse error:NULL];
    NSString *responseResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([[urlResponse allHeaderFields] objectForKey:@"Set-Cookie"]) {
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:[urlResponse allHeaderFields] forURL:[NSURL URLWithString:@".vip.xunlei.com"]];
        for(NSHTTPCookie *t in cookies){
            [self setCookieWithKey:t.name Value:t.value];
        }
    }
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 400)
		return responseResult;
    else
        return nil;
    
}


-(NSHTTPCookie *) setCookieWithKey:(NSString *) key Value:(NSString *) value{
    //创建一个cookie
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:value forKey:NSHTTPCookieValue];
    [properties setObject:key forKey:NSHTTPCookieName];
    [properties setObject:@".vip.xunlei.com" forKey:NSHTTPCookieDomain];
    [properties setObject:@"/" forKey:NSHTTPCookiePath];
    [properties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    //这里是关键，不要写成@"FALSE",而是应该直接写成TRUE 或者 FALSE，否则会默认为TRUE
    [properties setValue:FALSE forKey:NSHTTPCookieSecure];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    NSHTTPCookieStorage *cookieStorage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [cookieStorage setCookie:cookie];
    
    //add to responseCookies Array
    [[self responseCookies] addObject:cookie];
    return cookie;
}

@end
