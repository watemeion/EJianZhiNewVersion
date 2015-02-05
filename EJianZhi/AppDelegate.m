//
//  AppDelegate.m
//  EJianZhi
//
//  Created by RAY on 14/12/23.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import <ShareSDK/ShareSDK.h>
#import "SMS_SDK/SMS_SDK.h"

//#import "MainViewController.h"
//#import "LoginViewController.h"
#import "ApplyViewController.h"
#import "MobClick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //############环信聊天初始化设置###################
    //1、注册登录变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    //
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(78, 188, 211, 1)];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }

    
    //2、友盟
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSLog(@"bundleID=%@",bundleID);
    if ([bundleID isEqualToString:@"com.easemob.enterprise.demo.ui"]) {
        [MobClick startWithAppkey:@"5389bb7f56240ba94208ac97"
                     reportPolicy:BATCH
                        channelId:Nil];
#if DEBUG
        [MobClick setLogEnabled:YES];
#else
        [MobClick setLogEnabled:NO];
#endif
    }
    [MobClick startWithAppkey:@"54d0c830fd98c594f4000961"
                 reportPolicy:BATCH
                    channelId:Nil];
#if DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    
    
    
    [self registerRemoteNotification];
    
    
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
//    NSString *apnsCertName = nil;
#if DEBUG
//    apnsCertName = @"chatdemoui_dev";
#else
//    apnsCertName = @"chatdemoui";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"studiospicyhot#ejianzhi2014" apnsCertName:nil];
    
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[[EaseMob sharedInstance] chatManager] setIsAutoFetchBuddyList:YES];
    
#warning 注册为SDK的ChatManager的delegate (及时监听到申请和通知)
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
#warning 如果使用MagicalRecord, 要加上这句初始化MagicalRecord
    //demo coredata, .pch中有相关头文件引用
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"SSHIM"]];
    
    [self loginStateChange:nil];

    
    
    
    
    
    
    //##############Bomb#####################
    [Bmob registerWithAppKey:@"0c7866e7c8597793cd62c72f6ca52649"];
    
    //for ShareSDK
//    [ShareSDK registerApp:@"50de98338b9f"];
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    //短信验证模块
    [SMS_SDK registerApp:@"56454b8585da" withSecret:@"17e36cd8f741167baa78e940456c238c"];

    return YES;
}


#pragma --mark  IM Method
- (void)registerRemoteNotification{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    if (_mainController) {
//        [_mainController jumpToChatList];
//    }

#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if (_mainController) {
//        [_mainController jumpToChatList];
//    }
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //    [EaseMob sharedInstance];
    //    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    //
    //    id fetchViewController = navigationController.topViewController;
    //    if ([fetchViewController respondsToSelector:@selector(fetchDataResult:)]) {
    //        [fetchViewController fetchDataResult:^(NSError *error, NSArray *results){
    //            if (!error) {
    //                if (results.count != 0) {
    //                    //Update UI with results.
    //                    //Tell system all done.
    //                    completionHandler(UIBackgroundFetchResultNewData);
    //                } else {
    //                    completionHandler(UIBackgroundFetchResultNoData);
    //                }
    //            } else {
    //                completionHandler(UIBackgroundFetchResultFailed);
    //            }
    //        }];
    //    } else {
    //        completionHandler(UIBackgroundFetchResultFailed);
    //    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
//    if (_mainController) {
//        [_mainController setupUntreatedApplyCount];
//    }
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
    if (!groupId || !username) {
        return;
    }
    
    NSString *groupName = groupId;
    if (!message || message.length == 0) {
        message = [NSString stringWithFormat:@"%@ 邀请你加入群组\'%@\'", username, groupName];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupName, @"groupId":groupId, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    [[ApplyViewController shareController] addNewApply:dic];
//    if (_mainController) {
//        [_mainController setupUntreatedApplyCount];
//    }
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'", username, groupname];
    }
    else{
        reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'：%@", username, groupname, reason];
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:@"发送申请失败:%@\n原因：%@", reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
        [[ApplyViewController shareController] addNewApply:dic];
//        if (_mainController) {
//            [_mainController setupUntreatedApplyCount];
//        }
    }
}

- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:@"被拒绝加入群组\'%@\'", groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请提示" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:@"你被从群组\'%@\'中踢出", tmpStr];
    }
    if (str.length > 0) {
        TTAlertNoTitle(str);
    }
}

#pragma mark - IChatManagerDelegate

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    
//    [_mainController networkChanged:connectionState];
}

#pragma mark - EMChatManagerPushNotificationDelegate

- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(@"消息推送与设备绑定失败");
    }
}

#pragma mark - private

-(void)loginStateChange:(NSNotification *)notification
{
//    UINavigationController *nav = nil;
//    
//    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
//    BOOL loginSuccess = [notification.object boolValue];
//    
//    if (isAutoLogin || loginSuccess) {
//        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
//        if (_mainController == nil) {
//            _mainController = [[MainViewController alloc] init];
//            [_mainController networkChanged:_connectionState];
//            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
//        }else{
//            nav  = _mainController.navigationController;
//        }
//    }else{
//        _mainController = nil;
//        LoginViewController *loginController = [[LoginViewController alloc] init];
//        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
//        loginController.title = @"环信Demo";
//    }
//    
//    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
//        nav.navigationBar.barStyle = UIBarStyleDefault;
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
//                                forBarMetrics:UIBarMetricsDefault];
//        
//        [nav.navigationBar.layer setMasksToBounds:YES];
//    }
//    
////    self.window.rootViewController = nav;
//    
//    [nav setNavigationBarHidden:YES];
//    [nav setNavigationBarHidden:NO];
}



#pragma --mark  注册环信账号 method
-(void)doRegist:(NSString *)username passwd:(NSString*)pwd{
//[self showHudInView: hint:@"正在注册..."];
[[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username
                                                     password:pwd
                                               withCompletion:
 ^(NSString *username, NSString *password, EMError *error) {
     
     if (!error) {
         TTAlertNoTitle(@"注册成功,请登录");
     }else{
         switch (error.errorCode) {
             case EMErrorServerNotReachable:
                 TTAlertNoTitle(@"连接服务器失败!");
                 break;
             case EMErrorServerDuplicatedAccount:
                 TTAlertNoTitle(@"您注册的用户已存在!");
                 break;
             case EMErrorServerTimeout:
                 TTAlertNoTitle(@"连接服务器超时!");
                 break;
             default:
                 TTAlertNoTitle(@"注册失败");
                 break;
         }
     }
 } onQueue:nil];
}

@end
