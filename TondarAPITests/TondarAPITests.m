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
#define pwd @"1239492339"
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
        /*
        NSMutableArray* ma=[TondarAPI readYunTasksWithPage:1 retIfHasNextPage:NULL];
        for (XunleiItemInfo *task in ma) {
            NSLog(@"%@-------%@", task.taskid,task.name);
        }
        [TondarAPI deleteYunTaskByID:[(XunleiItemInfo*)[ma objectAtIndex:0] taskid]];
        for (XunleiItemInfo *task in [TondarAPI readYunTasksWithPage:1 retIfHasNextPage:NULL]) {
            NSLog(@"%@-------%@", task.taskid,task.name);
        }
         */
        /*
        //获取全部云转码任务
        for (XunleiItemInfo *task in [TondarAPI readAllYunTasks]) {
            NSLog(@"%@", task.name);
        }
         */
        /*
        for (XunleiItemInfo *task in [TondarAPI readAllDeletedTasks]) {
            NSLog(@"%@", task.name);
        }
         */
        /*测试快传
        NSURL *kuaiURL=[NSURL URLWithString:@"http://kuai.xunlei.com/d/NVICEUTSJWIO"];
//        [TondarAPI addAllKuaiTasksToLixianByURL:kuaiURL];
        NSArray* infos=[TondarAPI getKuaiItemInfos:kuaiURL];
        for(KuaiItemInfo* i in infos){
            NSLog(@"Name:%@<<<<<<<<<<<Url:%@",i.name,i.urlString);
            NSLog(@"\n%@",[TondarAPI generateXunleiURLStringByKuaiItemInfo:i]);
        }
         */
        /*
//        测试保留天数
        for (XunleiItemInfo *task in [TondarAPI readCompleteTasksWithPage:1]) {
            NSLog(@"%@", task.retainDays);
        }
        for (XunleiItemInfo *task in [TondarAPI readOutofDateTasksWithPage:1]) {
            NSLog(@"%@", task.retainDays);
        }
        for (XunleiItemInfo *task in [TondarAPI readDeletedTasksWithPage:1]) {
            NSLog(@"%@", task.retainDays);
        }
         */
//        测试文件名不完整bug
        for (XunleiItemInfo *task in [TondarAPI readAllCompleteTasks]) {
            NSLog(@"%@", task.name);
        }
    } else {
        NSLog(@"LOGIN FAIL");
    }
}
-(void) tst{
    
}

@end
