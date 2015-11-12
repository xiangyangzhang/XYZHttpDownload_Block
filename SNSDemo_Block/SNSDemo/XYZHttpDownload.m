//
//  XYZHttpDownload.m
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "XYZHttpDownload.h"

@interface XYZHttpDownload() <NSURLConnectionDataDelegate>

@end
/*
    A 委托 B 处理事情 A主动方
    在A中回调B 的方法
 
    1. 先定义block的类型 (在回调block类当中定义（主动方）)
    2. 在哪里调用block（回调）
    3. 实现block代码块传到主动方 --> 在被动方写（block的实现）
 */
@implementation XYZHttpDownload

- (instancetype)init {
    if (self = [super init]) {
        // 创建一个对象
        self.downloadData = [NSMutableData new];
    }
    return self;
}
// 必须在下载的时候传入block
- (void)downloadDataWithUrl:(NSString *)urlStr successBlock:(DownloadBlock)block failedBlock:(ErrorBlock)errorBlock{
    if (_httpRequest) {
        [_httpRequest cancel];
        _httpRequest = nil;
    }
    
    // 立即保存block 方便下面使用
    self.successBlock = block;
    self.errorBlock = errorBlock;
    
    // url 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    // 异步下载链接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    // 一旦创建就会立即异步下载
    // 每次下载都要重新创建链接请求
}

#pragma mark - 代理方法 <NSURLConnectionDataDelegate>
// 接收到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // 把之前的数据清空
    self.downloadData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // 下载完成后通知block
    if (self.successBlock) {
        // 回调block
        self.successBlock(self.downloadData);
    } else NSLog(@"block没有实现方法");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.errorBlock) {
        self.errorBlock(error);
    }
    
//    NSLog(@"下载失败");
}
@end
