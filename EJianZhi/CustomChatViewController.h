//
//  CustomChatViewController.h
//  EJianZhi
//
//  Created by Mac on 2/3/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CustomChatViewController : BaseViewController
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;



//添加企业和个人会话区分界面，keyWord
//必要属性
@property (strong,nonatomic)NSString *categoryKeyWord;
@end
