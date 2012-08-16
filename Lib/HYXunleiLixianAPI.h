//
//  HWXunleiLixianAPI.h
//  http
//
//  Created by Liu Chao on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    QMiddleQuality=1,
    QLowQuality=2,
    QHighQuality=3
}YUNZHUANMAQuality;

@interface HYXunleiLixianAPI : NSObject

-(BOOL) loginWithUsername:(NSString *) aName Password:(NSString *) aPassword;
-(NSString *) cookieValueWithName:(NSString *)aName;
-(NSMutableArray *) taskPageWithUserid:(NSString *) aUserID status:(NSUInteger) aST;
-(NSMutableArray *) btTaskPageWithTaskID:(NSString *) taskid hashID:(NSString *)dcid;
-(NSMutableArray *) yunTaskPageWithUserID:(NSString *) aUserID;
-(NSString *) addMegnetTask:(NSString *) url;
-(NSString *) addNormalTask:(NSString *)url;
-(BOOL) deleteTasks:(NSArray *)ids;
-(BOOL) addYunTaskWithFileSize:(NSString*) size downloadURL:(NSString*) url dcid:(NSString*) cid fileName:(NSString*) aName Quality:(YUNZHUANMAQuality) q;
@end
