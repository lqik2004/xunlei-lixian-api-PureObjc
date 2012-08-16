//
//  rex.h
//  test
//
//  Created by liuchao on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhraseElements : NSObject

+(NSArray *) taskPageData:(NSString *)orignData;

+(NSString *) taskName:(NSString *)taskContent;
+(NSString *) taskSize:(NSString *)taskContent;
+(NSString *) taskLoadProcess:(NSString *)taskContent;
+(NSString *) taskRetainDays:(NSString *)taskContent;
+(NSString *) taskAddTime:(NSString *)taskContent;
+(NSString *) taskDownlaodNormalURL:(NSString *)taskContent;
+(NSString *) nextPageContent:(NSString *)taskContent;
+(NSString *) GDriveID:(NSString *) orignData;
+(NSString *) taskType:(NSString *)taskContent;
+(NSString *) DCID:(NSString *)taskContent;
+(NSString *) GCID:(NSString *)taskDownLoadURL;
+(NSMutableDictionary *)taskInfo:(NSString *)taskContent;
@end
