//
//  XunleiItemInfo.h
//  xunleilixian
//
//  Created by liuchao on 8/2/12.
//
//

#import <Foundation/Foundation.h>

typedef enum{
    sWaiting=0,
    sDownloadding=1,
    sComplete=2,
    sFail=3,
    sPending=4
}TaskStatus;


@interface XunleiItemInfo : NSObject<NSCoding>

@property(nonatomic) NSString *taskid;
//任务名称
@property(nonatomic) NSString *name;
//任务大小（以字节为单位）
@property(nonatomic) NSString *size;
//任务大小（易读）
@property(nonatomic) NSString *readableSize;
//下载进度(float)
@property(nonatomic) NSString *downloadPercent;
//剩余保留时间
@property(nonatomic) NSString  *retainDays;
//添加时间
@property(nonatomic) NSString *addDate;
//下载地址
@property(nonatomic) NSString *downloadURL;
//原始下载地址
@property(nonatomic) NSString *originalURL;
//BT或者普通任务(0为BT，1为普通任务）
@property(nonatomic) NSString *isBT;
//
@property(nonatomic) NSString *type;
//bt hash
@property(nonatomic) NSString  *dcid;
//下载状态
@property(nonatomic) TaskStatus  status;
//是否可以在线播放
@property(nonatomic) NSString *ifvod;

@end
