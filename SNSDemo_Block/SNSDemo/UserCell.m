//
//  UserCell.m
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "UserCell.h"
#import "UIImageView+WebCache.h"

@implementation UserCell

- (void)showDataWithModel:(UserModel *)model {
    
    self.usernameLable.text = model.username;
    self.uidLable.text = model.uid;

    // 方法内部会启动一个线程 异步下载图片
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headimage] placeholderImage:[UIImage imageNamed:@"0"]];
    
}

@end
