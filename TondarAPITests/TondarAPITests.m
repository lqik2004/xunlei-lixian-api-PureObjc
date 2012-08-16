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
    if ([TondarAPI loginWithUsername:@"zhu@4321.la" Password:@"asdfgh%"]) {
        NSLog(@"LOGIN SUCCESS: %@", [TondarAPI userID]);
        for (XunleiItemInfo *task in [TondarAPI taskPageWithUserid:[TondarAPI userID] status:0]) {
            NSLog(@"%@", task.name);
        }
        
    } else {
        NSLog(@"LOGIN FAIL");
    }
    
    
}

@end
