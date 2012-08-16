//
//  HWXunleiLixianAPI.m
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


#import "HYXunleiLixianAPI.h"
#import "md5.h"
#import "ASIFormDataRequest.h"
#import "PhraseElements.h"
#import "JSONKit.h"
#import "RegexKitLite.h"
#import "URlEncode.h"
#import "XunleiItemInfo.h"

@implementation HYXunleiLixianAPI

#define LoginURL @"http://login.xunlei.com/sec2login/"
#define DEFAULT_USER_AGENT  @"User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.106 Safari/535.2"
#define DEFAULT_REFERER @"http://lixian.vip.xunlei.com/"




/**
 *  登陆方法
 */
-(BOOL) loginWithUsername:(NSString *) aName Password:(NSString *) aPassword{
    NSString *vCode=[self verifyCode:aName];
    if ([vCode compare:@"0"]==NSOrderedSame) {
        return NO;
    }
    NSString *enPassword=[self encodePassword:aPassword withVerifyCode:vCode];
    
    //第一步登陆，验证用户名密码
    NSURL *url = [NSURL URLWithString:LoginURL];
    ASIFormDataRequest*request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:aName forKey:@"u"];
    [request setPostValue:enPassword forKey:@"p"];
    [request setPostValue:vCode forKey:@"verifycode"];
    [request setPostValue:@"0" forKey:@"login_enable"];
    [request setPostValue:@"720" forKey:@"login_hour"];
    [request setUseSessionPersistence:YES];
    [request setUseCookiePersistence:YES];
    [request startSynchronous];
    //验证是否登陆成功
    NSString *userid=[self userID];
    if(userid.length>1){
        return YES;
    }else {
        return NO;
    }
}

//加密密码
-(NSString *) encodePassword:(NSString *) aPassword withVerifyCode:(NSString *) aVerifyCode{
    NSString *enPwd_tmp=[md5 md5HexDigestwithString:([md5 md5HexDigestwithString:aPassword])];
    NSString *upperVerifyCode=[aVerifyCode uppercaseString];
    //join the two strings
    enPwd_tmp=[NSString stringWithFormat:@"%@%@",enPwd_tmp,upperVerifyCode];
    NSString *pwd=[md5 md5HexDigestwithString:enPwd_tmp];
    NSLog(@"%@",pwd);
    return pwd;
}

//获取验证码
-(NSString *) verifyCode:(NSString *) aUserName{
    NSString *currentTime=[self currentTimeString];
    //NSLog(@"%@",currentTime);
    NSString *checkUrlString=[NSString stringWithFormat:@"http://login.xunlei.com/check?u=%@&cachetime=%@",aUserName,currentTime];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:checkUrlString] 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                         timeoutInterval:3];
    
    [NSURLConnection sendSynchronousRequest:request 
                          returningResponse:nil
                                      error:nil];
    NSString *vCode;
    vCode=[self cookieValueWithName:@"check_result"];
    //判断是否取得合法VerifyCode
    NSRange range;
    range=[vCode rangeOfString:@":"];
    if(range.location==NSNotFound){
        NSLog(@"Maybe something wrong when get verifyCode");
        return 0;
    }else {
        vCode=[[vCode componentsSeparatedByString:@":"] objectAtIndex:1];
        NSLog(@"%@",vCode);

    }
    return vCode;
}

//从cookies中取得指定名称的值
-(NSString *) cookieValueWithName:(NSString *)aName{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *value;
    for(NSHTTPCookie *cookie in [cookieJar cookies]){
        if([cookie.name compare:aName]==NSOrderedSame){
            value=cookie.value;
            NSLog(@"%@",value);
        }
    }
    return value;
}

//设置Cookies
-(NSHTTPCookie *) setCookieWithDomain:(NSString *) domain Key:(NSString *) key Value:(NSString *) value{
    /*
    NSArray *keys=[NSArray arrayWithObjects:NSHTTPCookieDomain,NSHTTPCookieName,NSHTTPCookieValue,NSHTTPCookieVersion,nil];
    NSArray *values=[NSArray arrayWithObjects:domain,key,value,@"0",nil];
    NSDictionary *cookieDic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSHTTPCookie *cookie=[NSHTTPCookie cookieWithProperties:cookieDic];
    
    NSHTTPCookieStorage *cookieStorage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [cookieStorage setCookie:cookie];
    
    for(NSHTTPCookie *cookie in [cookieStorage cookies]){
        NSLog(@"%@",cookie);
    }
    return YES;
     */
    //创建一个cookie
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:value forKey:NSHTTPCookieValue];
    [properties setValue:key forKey:NSHTTPCookieName];
    [properties setValue:@".vip.xunlei.com" forKey:NSHTTPCookieDomain];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    //这里是关键，不要写成@"FALSE",而是应该直接写成TRUE 或者 FALSE，否则会默认为TRUE
    [properties setValue:FALSE forKey:NSHTTPCookieSecure];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    NSHTTPCookieStorage *cookieStorage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [cookieStorage setCookie:cookie];
    
    return cookie;
}


//取得当前UTC时间，并转换成13位数字字符
-(NSString *) currentTimeString{
    double UTCTime=[[NSDate date] timeIntervalSince1970];
    NSString *currentTime=[NSString stringWithFormat:@"%f",UTCTime*1000];
    currentTime=[[currentTime componentsSeparatedByString:@"."] objectAtIndex:0];
    
    return currentTime;
}
//获取当前UserID
-(NSString *)userID{
    return ([self cookieValueWithName:@"userid"]);
}

//获取主任务页内容
/*
 * st=0 包含 正在下载和下载完成
 * st=2 包含已经完成嗯任务
 * st=4 包含 正在下载 已经完成 和 已经过期的任务 由于过期任务的页面格式和正在下载和已经下载的格式有所不同
 * 所以如果要获得所有任务那么尽量不适用st=4来获得，而是使用st=0加上已经过期的任务
 */
-(NSMutableArray *) taskPageWithUserid:(NSString *) aUserID status:(NSUInteger) aST{
     NSString *siteData;
    //初始化返回Array
    NSMutableArray *elements=[[NSMutableArray alloc] initWithCapacity:0];
    if(![self cookieValueWithName:@"lx_login"]){
        //完善所需要的cookies，并收到302响应跳转
        NSString *timeStamp=[self currentTimeString];
        NSURL *redirectUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/login?cachetime=%@&cachetime=%@&from=0",timeStamp,timeStamp]];
        ASIHTTPRequest* redirectURLrequest = [ASIHTTPRequest requestWithURL:redirectUrl];
        [redirectURLrequest startSynchronous];
        siteData=[redirectURLrequest responseString];

    }else {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/user_task?userid=%@&st=%ld",aUserID,aST]];
        //获取task页面内容
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        siteData=[request responseString];
    }

    //当得到返回数据且得到真实可用的列表信息（不是502等错误页面）时进行下一步
    if (siteData&&([PhraseElements GDriveID:siteData].length>0)) {
        [self setCookieWithDomain:@"." Key:@"gdriveid" Value:[PhraseElements GDriveID:siteData]];
        /*
         *===============
         *Phrase Html
         *===============
        */
        NSString *re1=@"<div\\s*class=\"rwbox\"([\\s\\S]*)?<!--rwbox-->";
        NSString *tmpD1=[siteData stringByMatching:re1 capture:1];
        NSString *re2=@"<div\\s*class=\"rw_list\"[\\s\\S]*?<!--\\s*rw_list\\s*-->";
        NSArray *allTaskArray=[tmpD1 arrayOfCaptureComponentsMatchedByRegex:re2];
        for(NSArray *tmp in allTaskArray){
            //初始化XunleiItemInfo
            XunleiItemInfo *info=[XunleiItemInfo new];
            NSString *taskContent=[tmp objectAtIndex:0];
            
            NSMutableDictionary *taskInfoDic=[PhraseElements taskInfo:taskContent];
            NSString* taskLoadingProcess=[PhraseElements taskLoadProcess:taskContent];
            NSString* taskRetainDays=[PhraseElements taskRetainDays:taskContent];
            NSString* taskAddTime=[PhraseElements taskAddTime:taskContent];
            NSString* taskType=[PhraseElements taskType:taskContent];
            NSString* taskReadableSize=[PhraseElements taskSize:taskContent];
            
            info.taskid=[taskInfoDic objectForKey:@"id"];
            info.name=[taskInfoDic objectForKey:@"taskname"];
            info.size=[taskInfoDic objectForKey:@"ysfilesize"];
            info.readableSize=taskReadableSize;
            info.downloadPercent=taskLoadingProcess;
            info.retainDays=taskRetainDays;
            info.addDate=taskAddTime;
            info.downloadURL=[taskInfoDic objectForKey:@"dl_url"];
            info.type=taskType;
            info.isBT=[taskInfoDic objectForKey:@"d_tasktype"];
            info.dcid=[taskInfoDic objectForKey:@"dcid"];
            info.status=[[taskInfoDic objectForKey:@"d_status"] integerValue];
            info.originalURL=[taskInfoDic objectForKey:@"f_url"];
            info.ifvod=[taskInfoDic objectForKey:@"ifvod"];
            
            [elements addObject:info];
        }
        //return info
        return elements;
    }else {
        return nil;
    }
    //NSLog(@"%@",elements);
   }

//获取BT页面内容(hashid 也就是dcid)
-(NSMutableArray *) btTaskPageWithTaskID:(NSString *) taskid hashID:(NSString *)dcid{
    NSMutableArray *elements=[[NSMutableArray alloc] initWithCapacity:0];
    NSString *userid=[self userID];
    NSString *currentTimeStamp=[self currentTimeString];
    NSString *urlString=[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/interface/fill_bt_list?callback=fill_bt_list&tid=%@&infoid=%@&g_net=1&p=1&uid=%@&noCacheIE=%@",taskid,dcid,userid,currentTimeStamp];
    NSURL *url=[NSURL URLWithString:urlString];
    //获取BT task页面内容
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSString *siteData=[request responseString];
    if (siteData) {
        NSString *re=@"^fill_bt_list\\((.+)\\)\\s*$";
        NSString *s=[siteData stringByMatching:re capture:1];
        
        NSDictionary *dic=[s objectFromJSONString];
        NSDictionary *result=[dic objectForKey:@"Result"];
        //dcid Value
        NSString *dcid=[result objectForKey:@"Infoid"];
        NSArray *record=[result objectForKey:@"Record"];
        
        for(NSDictionary *task in record){
            XunleiItemInfo *info=[XunleiItemInfo new];
            
            info.taskid=taskid;
            info.name=[task objectForKey:@"title"];
            info.size=[task objectForKey:@"filesize"];
            info.retainDays=[task objectForKey:@"livetime"];
            info.addDate=@"";
            info.downloadURL=[task objectForKey:@"downurl"];
            info.originalURL=[task objectForKey:@"url"];
            info.isBT=@"1";
            info.type=[task objectForKey:@"openformat"];
            info.dcid=dcid;
            info.ifvod=[task objectForKey:@"vod"];
            info.status=[[task objectForKey:@"download_status"] integerValue];
            info.readableSize=[task objectForKey:@"size"];
            info.downloadPercent=[task objectForKey:@"percent"];
            [elements addObject:info];
        }
        if([elements count]>0){
            return elements;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
    //NSLog(@"%@",elements);
    //return elements;
}

//获取云转码页面信息
-(NSMutableArray *) yunTaskPageWithUserID:(NSString *) aUserID{
    //初始化返回Array
    NSMutableArray *elements=[[NSMutableArray alloc] initWithCapacity:0];
    NSURL *requestURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com//cloud?userid=%@&cst=0",aUserID]];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:requestURL];
    [request startSynchronous];
    NSString *data=[request responseString];
    if(data){
        NSString *re1=@"<div\\s*class=\"rwbox\"([\\s\\S]*)?<!--rwbox-->";
        NSString *tmpD1=[data stringByMatching:re1 capture:1];
        NSString *re2=@"<div\\s*class=\"rw_list\"[\\s\\S]*?<!--\\s*rw_list\\s*-->";
        NSArray *allTaskArray=[tmpD1 arrayOfCaptureComponentsMatchedByRegex:re2];
        for(NSArray *tmp in allTaskArray){
            //初始化XunleiItemInfo
            XunleiItemInfo *info=[XunleiItemInfo new];
            NSString *taskContent=[tmp objectAtIndex:0];
            
            NSMutableDictionary *taskInfoDic=[PhraseElements taskInfo:taskContent];
            NSString* taskLoadingProcess=[PhraseElements taskLoadProcess:taskContent];
            NSString* taskRetainDays=[PhraseElements taskRetainDays:taskContent];
            NSString* taskAddTime=[PhraseElements taskAddTime:taskContent];
            NSString* taskType=[PhraseElements taskType:taskContent];
            NSString* taskReadableSize=[PhraseElements taskSize:taskContent];
            
            info.taskid=[taskInfoDic objectForKey:@"id"];
            info.name=[taskInfoDic objectForKey:@"cloud_taskname"];
            info.size=[taskInfoDic objectForKey:@"ysfilesize"];
            info.readableSize=taskReadableSize;
            info.downloadPercent=taskLoadingProcess;
            info.retainDays=taskRetainDays;
            info.addDate=taskAddTime;
            info.downloadURL=[taskInfoDic objectForKey:@"cloud_dl_url"];
            info.type=taskType;
            info.isBT=[taskInfoDic objectForKey:@"d_tasktype"];
            info.dcid=[taskInfoDic objectForKey:@"dcid"];
            info.status=[[taskInfoDic objectForKey:@"cloud_d_status"] integerValue];
            //info.originalURL=[taskInfoDic objectForKey:@"f_url"];
            //info.ifvod=[taskInfoDic objectForKey:@"ifvod"];
            
            [elements addObject:info];
        }
        //return info
        return elements;
    }else {
        return nil;
    }
}



//add megnet task
-(NSString *) addMegnetTask:(NSString *) url{
    NSString *cid;
    NSString *tsize;
    NSString *btname;
    NSString *findex;
    NSString *sindex;
    NSString *enUrl=[URlEncode encodeToPercentEscapeString:url];
    NSString *timestamp=[self currentTimeString];
    NSString *callURLString=[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/interface/url_query?callback=queryUrl&u=%@&random=%@",enUrl,timestamp];
    NSURL *callURL=[NSURL URLWithString:callURLString];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:callURL];
    [request startSynchronous];
    NSString *data=[request responseString];
    NSString *re=@"queryUrl(\\(1,.*\\))\\s*$";
    NSString *sucsess=[data stringByMatching:re capture:1];
    if(sucsess){
        //NSLog(sucsess);
        NSArray *array=[sucsess componentsSeparatedByString:@"new Array"];
        //first data
        NSString *dataGroup1=[array objectAtIndex:0];
        //last data
        NSString *dataGroup2=[array objectAtIndex:([array count]-1)];
        //last fourth data
        NSString *dataGroup3=[array objectAtIndex:([array count]-4)];
        NSString *re1=@"['\"]?([^'\"]*)['\"]?";
        cid=[[[dataGroup1 componentsSeparatedByString:@","] objectAtIndex:1] stringByMatching:re1 capture:1];
        //NSLog(cid);
        tsize=[[[dataGroup1 componentsSeparatedByString:@","] objectAtIndex:2] stringByMatching:re1 capture:1];
        //NSLog(tsize);
        btname=[[[dataGroup1 componentsSeparatedByString:@","] objectAtIndex:3] stringByMatching:re1 capture:1];
        //NSLog(btname);
        
        //findex
        NSString *re2=@"\\(([^\\)]*)\\)";
        NSString *preString0=[dataGroup2 stringByMatching:re2 capture:1];  
        NSString *re3=@"'([^']*)'";
        NSArray *preArray0=[preString0 arrayOfCaptureComponentsMatchedByRegex:re3];
        NSMutableArray *preMutableArray=[NSMutableArray arrayWithCapacity:0];
        for(NSArray *a in preArray0){
            [preMutableArray addObject:[a objectAtIndex:1]];
        }
        findex=[preMutableArray componentsJoinedByString:@"_"];
        //NSLog(@"%@",findex);
        
        //size index
        preString0=[dataGroup3 stringByMatching:re2 capture:1];  
        preArray0=[preString0 arrayOfCaptureComponentsMatchedByRegex:re3];
        NSMutableArray *preMutableArray1=[NSMutableArray arrayWithCapacity:0];
        for(NSArray *a in preArray0){
            [preMutableArray1 addObject:[a objectAtIndex:1]];
        }
        sindex=[preMutableArray1 componentsJoinedByString:@"_"];
        //NSLog(@"%@",sindex); 
        
        //提交任务
        NSURL *commitURL = [NSURL URLWithString:@"http://dynamic.cloud.vip.xunlei.com/interface/bt_task_commit"];
        ASIFormDataRequest* commitRequest = [ASIFormDataRequest requestWithURL:commitURL];
        
        [commitRequest setPostValue:[self userID] forKey:@"uid"];
        [commitRequest setPostValue:btname forKey:@"btname"];
        [commitRequest setPostValue:cid forKey:@"cid"];
        [commitRequest setPostValue:tsize forKey:@"tsize"];
        [commitRequest setPostValue:findex forKey:@"findex"];
        [commitRequest setPostValue:sindex forKey:@"size"];
        [commitRequest setPostValue:@"0" forKey:@"from"];
        
        [commitRequest setUseSessionPersistence:YES];
        [commitRequest setUseCookiePersistence:YES];
        [commitRequest startSynchronous];
    }else {
        NSString *re1=@"queryUrl\\(-1,'([^']{40})";
        cid=[data stringByMatching:re1 capture:1];
    }
    //NSLog(@"%@",cid);
    return cid;
}

//add normal task(http,ed2k...)
-(NSString *) addNormalTask:(NSString *)url{
    NSString *enUrl=[URlEncode encodeToPercentEscapeString:url];
    NSString *timestamp=[self currentTimeString];
    NSString *callURLString=[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/interface/task_check?callback=queryCid&url=%@&random=%@&tcache=%@",enUrl,timestamp,timestamp];
    NSURL *callURL=[NSURL URLWithString:callURLString];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:callURL];
    [request startSynchronous];
    NSString *dataRaw=[request responseString];
    
    NSString *cid=@"";
    NSString *gcid=@"";
    NSString *size=@"";
    NSString *filename=@"";
    NSString *goldbeen=@"";
    NSString *silverbeen=@"";
    NSString *is_full=@"";
    NSString *random=@"";
    NSString *ext=@"";
    NSString *someKey=@"";
    NSString *taskType=@"";
    NSString *userid=@"";
    
    userid=[self userID];
    
    
    if(([url rangeOfString:@"http://" options:NSCaseInsensitiveSearch].length>0)||([url rangeOfString:@"ftp://" options:NSCaseInsensitiveSearch].length>0)){
        taskType=@"0";
    }else if([url rangeOfString:@"ed2k://" options:NSCaseInsensitiveSearch].length>0){
        taskType=@"2";
    }
    
    NSString *re=@"queryCid\\((.+)\\)\\s*$";
    NSString *sucsess=[dataRaw stringByMatching:re capture:1];
    NSArray *data=[sucsess componentsSeparatedByString:@","];
    NSMutableArray *newData=[NSMutableArray arrayWithCapacity:0];
    for(NSString *i in data){
        NSString *re1=@"\\s*['\"]?([^']*)['\"]?";
        NSString *d=[i stringByMatching:re1 capture:1];
        if(!d){
            d=@"";
        }
        [newData addObject:d];
        NSLog(@"%@",d);
    }
    if(8==data.count){
        cid=[newData objectAtIndex:0];
        gcid=[newData objectAtIndex:1];
        size=[newData objectAtIndex:2];
        filename=[newData objectAtIndex:3];
        goldbeen=[newData objectAtIndex:4];
        silverbeen=[newData objectAtIndex:5];
        is_full=[newData objectAtIndex:6];
        random=[newData objectAtIndex:7];
    }
    else if(9==data.count){
        cid=[newData objectAtIndex:0];
        gcid=[newData objectAtIndex:1];
        size=[newData objectAtIndex:2];
        filename=[newData objectAtIndex:3];
        goldbeen=[newData objectAtIndex:4];
        silverbeen=[newData objectAtIndex:5];
        is_full=[newData objectAtIndex:6];
        random=[newData objectAtIndex:7];
        ext=[newData objectAtIndex:8];
    }else if(10==data.count){
        cid=[newData objectAtIndex:0];
        gcid=[newData objectAtIndex:1];
        size=[newData objectAtIndex:2];
        someKey=[newData objectAtIndex:3];
        filename=[newData objectAtIndex:4];
        goldbeen=[newData objectAtIndex:5];
        silverbeen=[newData objectAtIndex:6];
        is_full=[newData objectAtIndex:7];
        random=[newData objectAtIndex:8];
        ext=[newData objectAtIndex:9];
    }
    //filename如果是中文放到URL中会有编码问题，需要转码
    NSString *newFilename=[URlEncode encodeToPercentEscapeString:filename];
    
    
    NSString *commitString=[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/interface/task_commit?callback=ret_task&uid=%@&cid=%@&gcid=%@&size=%@&goldbean=%@&silverbean=%@&t=%@&url=%@&type=%@&o_page=task&o_taskid=0",userid,cid,gcid,size,goldbeen,silverbeen,newFilename,enUrl,taskType];
    //NSLog(@"%@",commitString);
    NSURL *commitURL=[NSURL URLWithString:commitString];
    NSLog(@"%@",commitURL);
    ASIHTTPRequest *commitRequest=[ASIHTTPRequest requestWithURL:commitURL];
    [commitRequest startSynchronous];
    return [commitRequest responseString];
}


//Delete tasks
-(BOOL) deleteTasks:(NSArray *)ids{
    BOOL returnResult=NO;
    NSMutableString *idString=[NSMutableString string];
    for(NSString *i in ids){
        [idString appendString:i];
        [idString appendString:@","];
    }
    NSString *encodeIDString=[URlEncode encodeToPercentEscapeString:idString];
    NSString *tmp=[URlEncode encodeToPercentEscapeString:@","];
    NSString *urlString=[NSString stringWithFormat:@"http://dynamic.cloud.vip.xunlei.com/interface/task_delete?type=2&taskids=%@&old_idlist=&databases=0%@&old_databaselist=&",encodeIDString,tmp];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSString *requestString=[request responseString];
    if (requestString) {
        NSString *re=@"^delete_task_resp\\((.+)\\)$";
        NSNumber *result=[[[requestString stringByMatching:re capture:1] objectFromJSONString] objectForKey:@"result"];
        if(result && ([result intValue]==1)){
            returnResult=YES;
        }
    }
    return returnResult;
}

//Yun Zhuan Ma
-(BOOL) addYunTaskWithFileSize:(NSString*) size downloadURL:(NSString*) url dcid:(NSString*) cid fileName:(NSString*) aName Quality:(YUNZHUANMAQuality) q{
    NSString *gcid=[PhraseElements GCID:url];
    NSURL *requestURL=[NSURL URLWithString:@"http://dynamic.cloud.vip.xunlei.com/interface/cloud_build_task/"];
    NSString *detailTaskPostValue=[NSString stringWithFormat:@"[{\"section_type\":\"c7\",\"filesize\":\"%@\",\"gcid\":\"%@\",\"cid\":\"%@\",\"filename\":\"%@\"}]",size,gcid,cid,aName];
    ASIFormDataRequest* commitRequest = [ASIFormDataRequest requestWithURL:requestURL];
    NSString *cloudFormat=[NSString stringWithFormat:@"%d",q];
    [commitRequest setPostValue:cloudFormat  forKey:@"cloud_format"];
    [commitRequest setPostValue:detailTaskPostValue forKey:@"tasks"];
    [commitRequest setUseSessionPersistence:YES];
    [commitRequest setUseCookiePersistence:YES];
    [commitRequest startSynchronous];
    NSString *response=[commitRequest responseString];
    if(response){
        NSDictionary *rDict=[response objectFromJSONString];
        if([rDict objectForKey:@"succ"] && [[rDict objectForKey:@"succ"] intValue]==1){
            return YES;
        }
    }
    return NO;
}
@end
