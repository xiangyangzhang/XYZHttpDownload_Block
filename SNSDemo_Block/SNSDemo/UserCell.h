//
//  UserCell.h
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *uidLable;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;

// 填充 cell 根据数据模型
// cell 上数据来源model
- (void)showDataWithModel:(UserModel *)model;

@end
