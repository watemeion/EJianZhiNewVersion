//
//  JobListTableViewCell.m
//  EJianZhi
//
//  Created by Mac on 1/24/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "JobListTableViewCell.h"

@implementation JobListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.IconView.type=WithBadge;
    self.IconView.badgeText=@"有炮友";
    self.IconView.backgroundColor=DefaultFillColor;
    //设置圆角
    [self.IconView.layer setMasksToBounds:YES];
    [self.IconView.layer setCornerRadius:3.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
