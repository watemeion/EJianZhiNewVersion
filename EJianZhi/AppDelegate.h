//
//  AppDelegate.h
//  EJianZhi
//
//  Created by RAY on 14/12/23.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
EMConnectionState _connectionState;
}
@property (strong, nonatomic) UIWindow *window;

@end

