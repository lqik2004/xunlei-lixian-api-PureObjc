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
#define pwd @"pwd"
    if ([TondarAPI loginWithUsername:USERNAME Password:pwd]) {
        NSLog(@"LOGIN SUCCESS: %@", [TondarAPI userID]);
        //获取全部已经完成任务
        [TondarAPI readCompleteTasksWithPage:0];
        NSLog(@"%@", [TondarAPI GDriveID]);
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
        /*
//        测试文件名不完整bug
        for (XunleiItemInfo *task in [TondarAPI readAllCompleteTasks]) {
            NSLog(@"%@", task.name);
        }
         */
        /*
//        测试暂停任务
        for (XunleiItemInfo *task in [TondarAPI readDownloadingTasksWithPage:1]) {
            NSLog(@"%@-----------%@-------%u", task.taskid,task.name,task.status);
            if([TondarAPI pauseTask:task]){
                NSLog(@"Pause Done!!");
            }
            [TondarAPI restartTask:task];
        }
         */
        /*
//        添加任务
        [TondarAPI addNormalTask:@"thunder://QUFlZDJrOi8vfGZpbGV8JUU1JUE0JThEJUU0JUJCJTg3JUU4JTgwJTg1JUU4JTgxJTk0JUU3JTlCJTlGLlRoZS5BdmVuZ2Vycy4yMDEyLkRWRC1STVZCLSVFNCVCQSVCQSVFNCVCQSVCQSVFNSVCRCVCMSVFOCVBNyU4NiVFNSU4RSU5RiVFNSU4OCU5QiVFNyVCRiVCQiVFOCVBRiU5MSVFNCVCOCVBRCVFOCU4QiVCMSVFNSU4RiU4QyVFOCVBRiVBRCVFNSVBRCU5NyVFNSVCOSU5NS5ybXZifDY4NDU2MzAxMnxlMTA2MDU2YTQ1NTkyYThjYTUzYmVhODMxZjk1NDJlMHxoPWZoZWM0cHpobjd6YzRoN2Y0bG02cHZvbWN0aTJ1cjdmfC9aWg=="];
         */
        /*
        //BT列表测试
        for (XunleiItemInfo *task in [TondarAPI readCompleteTasksWithPage:1]) {
            if([task.isBT isEqualToString:@"0"]){
                for(XunleiItemInfo *task1 in [TondarAPI allBTTaskListWithTaskID:task.taskid hashID:task.dcid]){
                    NSLog(@"%@", task1.name);
                }
            }
        }
         */
    } else {
        NSLog(@"LOGIN FAIL");
    }
}


@end
