//
//  UserModel.h
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
// 数据模型， 保存数据
// 根据数据 设计模型， 数据模型的属性名一个跟数据名字一样
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *headimage;

@end
