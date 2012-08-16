//
//  HWXunleiLixianAPI.h
//  XunleiLixian-API
//
//  Created by Liu Chao on 6/10/12.
//  Copyright (c) 2012 HwaYing. All rights reserved.
//
/*This file is part of XunleiLixian-API.
 
 XunleiLixian-API is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Foobar is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/

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
