//
//  XunleiItemInfo.m
//  xunleilixian
//
//  Created by liuchao on 8/2/12.
//
//

#import "XunleiItemInfo.h"

@implementation XunleiItemInfo

NSString * const TaskStatusArray[]={
   @"waiting",@"downloading",@"complete",@"fail",@"pending"
};

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSString *tmpStatus=[self statusToString:self.status];
    [aCoder encodeObject:tmpStatus forKey:@"status"];
    [aCoder encodeObject:self.taskid forKey:@"taskid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.readableSize forKey:@"readableSize"];
    [aCoder encodeObject:self.downloadPercent forKey:@"loaddingProcess"];
    [aCoder encodeObject:self.retainDays forKey:@"retainDays"];
    [aCoder encodeObject:self.addDate forKey:@"addTime"];
    [aCoder encodeObject:self.downloadURL forKey:@"downloadURL"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.dcid forKey:@"dcid"];
    [aCoder encodeObject:self.originalURL forKey:@"originalurl"];
    [aCoder encodeObject:self.ifvod forKey:@"ifVod"];
    [aCoder encodeObject:self.isBT forKey:@"isBT"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self=[self init])){
        TaskStatus tmpStatus=[self stringToTaskStatus:[aDecoder decodeObjectForKey:@"status"]];
        [self setStatus:tmpStatus];
        [self setTaskid:[aDecoder decodeObjectForKey:@"taskid"]];
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setSize:[aDecoder decodeObjectForKey:@"size"]];
        [self setDownloadPercent:[aDecoder decodeObjectForKey:@"loaddingProcess"]];
        [self setRetainDays:[aDecoder decodeObjectForKey:@"retainDays"]];
        [self setAddDate:[aDecoder decodeObjectForKey:@"addTime"]];
        [self setDownloadURL:[aDecoder decodeObjectForKey:@"downloadURL"]];
        [self setType:[aDecoder decodeObjectForKey:@"type"]];
        [self setDcid:[aDecoder decodeObjectForKey:@"dcid"]];
        [self setOriginalURL:[aDecoder decodeObjectForKey:@"originalurl"]];
        [self setReadableSize:[aDecoder decodeObjectForKey:@"readableSize"]];
        [self setIfvod:[aDecoder decodeObjectForKey:@"ifVod"]];
        [self setIsBT:[aDecoder decodeObjectForKey:@"isBT"]];
        
    }
    return self;
}

-(NSString *) statusToString:(TaskStatus) status{
    return TaskStatusArray[status];
}
-(TaskStatus) stringToTaskStatus:(NSString*) taskStatusString{
    int r;
    for(int i=0;i<sizeof(TaskStatusArray)-1;i++){
        if([(NSString*)TaskStatusArray[i] isEqualToString:taskStatusString]){
            r=i;
            break;
        }
    }
    return (TaskStatus)r;
}


@end
