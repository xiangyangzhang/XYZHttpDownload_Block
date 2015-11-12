//
//  ViewController.m
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//
#define kUrl (@"http://10.0.8.8/sns/my/user_list.php?page=%ld&number=%ld")
#define kUserCellID @"UserCell"

#import "ViewController.h"
#import "UserCell.h"
#import "UserModel.h"
#import "XYZHttpDownload.h"
// MVC 设计模式
/*
    1. 先分析数据格式
    2. 设计model
    3. 设计cell
    4. 完善controller（下载数据，解析数据，展示数据）
 */

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    XYZHttpDownload *_download;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage; // 记录当前页面
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    // 默认强引用指针 _download
    _download = [XYZHttpDownload new];
    NSString *url = [NSString stringWithFormat:kUrl,self.currentPage,(NSInteger)20];
    [self addDownLoadTaskWithUrl:url];
    
}
#pragma mark - 下载数据 （重点）
// self 拥有 _download，self 强引用 _download , 在block中_download 对self拷贝强引用self ， _download强引用self
// 导致强强引用 ，死锁
- (void)addDownLoadTaskWithUrl:(NSString *)urlStr {
    // 为了避免block对当前对象强引用导致循环引用死锁， 引发内存泄露， 必须 一强一弱
    
    // typeof (self) --- > 获取self 的类型 ViewController * 类型
    __weak typeof(self) weakSelf = self;
    [_download downloadDataWithUrl:urlStr successBlock:^(NSData *downloadData) {
        // 下载成功之后回调block代码
        // 解析数据
        if (downloadData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:downloadData options:NSJSONReadingMutableContainers error:nil];
            NSArray *userArr = dict[@"users"];
            for (NSDictionary *userDict in userArr) {
                UserModel *model = [UserModel new];
                model.username = userDict[@"username"];
                model.uid = userDict[@"uid"];
                
                // 拼接完整的图片地址
                model.headimage = [@"http://10.0.8.8/sns" stringByAppendingString:userDict[@"headimage"]];
                [weakSelf.dataArr addObject:model];
            }
            // tableView 刷新表格
            [weakSelf.tableView reloadData];
        }

    } failedBlock:^(NSError *error) {
        
    }];
}

#pragma mark - tableView
- (void)createTableView {
    // 实例化空的对象
    self.dataArr = [NSMutableArray new];
    // 实例化tableView 对象
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    // 注册xib
    [self.tableView registerNib:[UINib nibWithNibName:kUserCellID bundle:nil] forCellReuseIdentifier:kUserCellID];
    // 下面复用cell直接从队列中取
    
}

#pragma mark - 代理协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCellID forIndexPath:indexPath];
    UserModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

@end
