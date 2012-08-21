#迅雷离线API  (TondarAPI)
***************  
本项目旨在提供一个纯由Objective-C写成的迅雷离线API，方便在Mac OS X和iOS上开发相应项目。  
**TondarAPI已经通过了iOS/Mac OS X兼容性测试** 
###名称释义
**Tondar**为波斯语（Persian），意为闪电  
###功能概述
* 迅雷离线账户登陆  
* 获取任务列表（返回返回每个任务的详细信息，参见XunleiItemInfo）  
* 任务类型识别  
* 获取BT任务列表（返回返回每个任务的详细信息，参见XunleiItemInfo）  
* http/ftp/thunder/ed2k/magnet等下载连接类型支持  
* 删除任务
* 添加云转码任务（包括选择不同清晰度）
* 获取云转码任务列表
* 删除云转码任务
* 云点播
* 一键添加到迅雷快传
* 对迅雷，旋风，Flashget多种专有连接的下载支持

###TODO
* 完善获取“保留时间”方法  
* 增加对正在下载任务的进度获取  
* 增加本地BT文件上传  
* 支持批量任务添加  
* 去掉一些开源库的依赖

******************  
###使用迅雷离线API的项目  
* 迅雷离线 for iOS
* fakeThunder 2  (Developing)

如果你使用了迅雷离线API，可以和我联系添加到这里

******************
###要求
**系统**：iOS 5.0及以上(支持ARC)和Mac OX 10.7 Lion及以上  
**Xcode**：4.3及其以上  
[**asi-http-request**](https://github.com/pokeb/asi-http-request/)  
[**RegexKitLite**](http://regexkit.sourceforge.net/RegexKitLite/)  
[**JSONKit**](https://github.com/johnezang/JSONKit/)
******************
###源文件说明
####依赖的开源库
迅雷离线API依赖的开源库有：[**asi-http-request**](https://github.com/pokeb/asi-http-request/) [**RegexKitLite**](http://regexkit.sourceforge.net/RegexKitLite/)和[**JSONKit**](https://github.com/johnezang/JSONKit/)  
[**asi-http-request**](https://github.com/pokeb/asi-http-request/)方便了http-request。不过[**asi-http-request**](https://github.com/pokeb/asi-http-request/)作者已经停止了开发，而且不支持ARC，所以我也正在考虑更换成别的开源库，如果有比较好的功能完备的库可以推荐给我  
[**RegexKitLite**](http://regexkit.sourceforge.net/RegexKitLite/) 是一款方便进行正则处理的开源库，用起来非常不错，但是据说有reject风险？现在还未确定  
[**JSONKit**](https://github.com/johnezang/JSONKit/) 处理JSON的开源库，详细情况可以查看项目主页

#####开源库的使用######
具体方法就不写了，Google或者到各个项目主页很容易就可以查到。  
需要注意的是在启用了ARC环境下如果使用不开启ARC的库，可以找到Target->Build Phases->Compile Sources->找到需要关闭ARC的.m文件，然后加入**-fno-objc-arc**  
![图示1](http://ww4.sinaimg.cn/large/62d85d3dtw1dvybqxgbt3j.jpg )  
关于开源库的使用，当时为了开发的方便加入了三个开源库能够让我用最快的时间开发出来，把主要精力放在写正则上，现在iOS和Mac OS X对JSON和正则的支持也很不错，所以可能会去掉这两个开源库，用起来方便一些。

#####特别注意：如果你是从别的地方获取的[**asi-http-request**](https://github.com/pokeb/asi-http-request/)，那么需要修改一处代码以支持中文。
把  
[self setDefaultResponseEncoding:NSISO**Latin1**StringEncoding];  
改成  
[self setDefaultResponseEncoding:NS**UTF8**StringEncoding];    

详细操作[点击这里](https://github.com/lqik2004/xunlei-lixian-api-PureObjc/commit/25dd032334adeff60e906c75c8dcc6ecad241026)
####API结构说明
迅雷离线API包含了10个文件  
对外调用需要以下文件：
HYXunleiLixianAPI，XunleiItemInfo 和Kuai  
HYXunleiLixianAPI 提供了获取任务列表，添加任务删除任务等功能  
XunleiItemInfo 提供了任务返回信息（包含任务名称，dcid等）  
Kuai中对外调用为其中的KuaiItemInfo类，包含了从迅雷快传提取任务的各种信息
*******************
###更新日志  
* 2012-8-22 v0.5 fix some bugs && 增加了对迅雷，旋风，Flashget专有下载链接格式的支持
* 2012-8-21 v0.4.1 fix some bugs && update README
* 2012-8-20 v0.4 released!，增加了迅雷快传
* 2012-8-19 重写了接口  

*******************
###反馈问题
有任何问题可以和lqik2004#gmail.com进行联系  
或者到我的博客[http://res0w.com](http://res0w.com)进行留言  
也可以Follow我的Twitter:[@lqik2004](https://twitter.com/lqik2004)
********************
###许可证
*在适当的时候我可能会更改许可证为MIT*  
本项目采用[LGPL](http://www.gnu.org/copyleft/lesser.html)许可  
![LGPL](http://www.gnu.org/graphics/lgplv3-147x51.png)