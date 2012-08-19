//
//  TondarAPITests.m
//  TondarAPITests
//
//  Created by Martian on 12-7-29.
//  Copyright (c) 2012年 MartianZ. All rights reserved.
//

#import "TondarAPITests.h"
#import <TondarAPI/HYXunleiLixianAPI.h>
#import <TondarAPI/XunleiItemInfo.h>

@implementation TondarAPITests

- (void)setUp
{
    [super setUp];
    // Set-up code here.
    
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testExample
{
    NSLog(@"TEST START");
    HYXunleiLixianAPI *TondarAPI = [[HYXunleiLixianAPI alloc] init];
#define USERNAME @"lqik2004"
#define pwd @"YOURPASSWORD"
    if ([TondarAPI loginWithUsername:USERNAME Password:pwd]) {
        NSLog(@"LOGIN SUCCESS: %@", [TondarAPI userID]);
        //获取全部已经完成任务
        /*
        for (XunleiItemInfo *task in [TondarAPI readAllCompleteTasks]) {
            NSLog(@"%@", task.name);
        }
         */
        /*获取删除和过期任务（有问题）
        for (XunleiItemInfo *task in [TondarAPI readAllDeletedTasks]) {
            NSLog(@"%@", task.name);
        }
        */
        //读取云转码第一页,并删除第一个，再打印第一页
        NSMutableArray* ma=[TondarAPI readYunTasksWithPage:1 retIfHasNextPage:NULL];
        for (XunleiItemInfo *task in ma) {
            NSLog(@"%@-------%@", task.taskid,task.name);
        }
        [TondarAPI deleteYunTaskByID:[(XunleiItemInfo*)[ma objectAtIndex:0] taskid]];
        for (XunleiItemInfo *task in [TondarAPI readYunTasksWithPage:1 retIfHasNextPage:NULL]) {
            NSLog(@"%@-------%@", task.taskid,task.name);
        }
        /*
        //获取全部云转码任务
        for (XunleiItemInfo *task in [TondarAPI readAllYunTasks]) {
            NSLog(@"%@", task.name);
        }
         */
    } else {
        NSLog(@"LOGIN FAIL");
    }
    
    
}

@end
