//
//  XYZHttpDownload.h
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

// 用block封装的下载类

/*
 我们的app往往 很多界面都需要 进行下载数据，这时我们可以利用封装性对 下载进一步的封装，哪个界面需要下载那么我们就直接创建封装好的下载对象就可以了
 //当前类 只负责 下载数据,不知道怎么处理处理，界面是需要处理数据,这时 下载对象可以 委托 界面 进行处理数据
 //代理设计模式
 1.通过协议规范代理的行为
 2.block 回调
 */

/*
 * 封装 ，当前类负责下载数据 
 * 界面需要数据，下载对象可以委托界面进行处理数据
 * 代理设计模式 1. 通过协议规范代理行为
              2. block 回调
 */
#import <Foundation/Foundation.h>
// 定义block 类型
typedef void (^DownloadBlock)(NSData *downloadData); // 下载成功block类型
typedef void (^ErrorBlock)(NSError *error); // 下载失败block类型

@interface XYZHttpDownload : NSObject
{
    // 下载链接请求
    NSURLConnection *_httpRequest;
}

@property (nonatomic, strong) NSMutableData *downloadData; // 保存下载数据
// 保存block必须用copy -- 不保存可能会释放掉
@property (nonatomic, copy) DownloadBlock successBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;
// 封装下载函数
- (void)downloadDataWithUrl:(NSString *)urlStr successBlock:(DownloadBlock)successBlock failedBlock:(ErrorBlock)errorBlock;

@end
