//
//  EJZMessageViewController.m
//  EJianZhi
//
//  Created by Mac on 2/3/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "EJZMessageViewController.h"

#import "CustomChatViewController.h"
#import "ContactsViewController.h"
#import "SettingsViewController.h"
#import "ApplyViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
@interface EJZMessageViewController () <UIAlertViewDelegate, IChatManagerDelegate>
{
    CustomChatViewController *_indivChatListVC;
//    SettingsViewController *_settingsVC;
    CustomChatViewController *_compyChatListVC;
    ContactsViewController *_contactsVC;
//    UIBarButtonItem *_addFriendItem;
//    
//    //自定义button
//    UIBarButtonItem *_seeFriendItem;
//    UIBarButtonItem *_backFrom_contactsVC_Item;
    
}



@property (strong, nonatomic) NSDate *lastPlaySoundDate;

//自定义UISegmentedControl   AT
@property (strong,nonatomic)UISegmentedControl *segmentedControl;


@end
@implementation EJZMessageViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}


-(UISegmentedControl*)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl=[[UISegmentedControl alloc]initWithItems:@[@"招聘企业",@"兼职伙伴"]];
        
    }
    return _segmentedControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    // Do any additional setup after loading the view from its nib.
    //设置segmentedController
    self.segmentedControl.tintColor=[UIColor whiteColor];
    self.navigationItem.titleView=self.segmentedControl;
    //默认选中企业列表
    self.segmentedControl.selectedSegmentIndex=0;
    [self.segmentedControl addTarget:self
                               action:@selector(segementedChange)
                     forControlEvents:UIControlEventValueChanged];
    
    //
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"好友" style:UIBarButtonItemStylePlain target:self action:@selector(seeFriendsAction)];
    
    
    
    /**----------初始化业务逻辑,1账号登陆-------------------**/
    //初始化登录操作，目前是写死的
    [self loginWithUsername:@"15652779418" password:@"123456"];
    
    
    /**----------初始化业务逻辑,2获取未读消息---------------**/
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    /**----------初始化业务逻辑,3加载子View---------------**/
    //设置主界面
    [self setupSubviews];
    
    /**----------初始化业务逻辑,4设置未处理数据badges---------**/
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];

}

- (void)dealloc
{
    [self unregisterNotifications];
}

-(void)seeFriendsAction
{
    if (_contactsVC) {
        _contactsVC.hidesBottomBarWhenPushed=YES;
        _contactsVC.navigationItem.title = @"好友列表";
//        _contactsVC.navigationItem.rightBarButtonItem = _addFriendItem;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController pushViewController:_contactsVC animated:YES];
    }
}

#pragma --mark  自定义Ui
//
- (void)setupSubviews
{
    _compyChatListVC=[[CustomChatViewController alloc]init];
    _compyChatListVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     _compyChatListVC.categoryKeyWord=CompanyCategory;
    _compyChatListVC.view.tag=90001;
    _indivChatListVC=[[CustomChatViewController alloc]init];
    _indivChatListVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _indivChatListVC.view.tag=90002;
    _indivChatListVC.categoryKeyWord=IndividualCategory;
    [self.view addSubview:_compyChatListVC.view];
    
    _contactsVC=[[ContactsViewController alloc]init];
    
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
                [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            } onQueue:nil];
        }
    }
    else if (alertView.tag == 100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } else if (alertView.tag == 101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}


#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



//统计未读消息
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
//    if (_indivChatListVC) {
        if (unreadCount > 0) {
            self.navigationController.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",unreadCount];
            
        }else{
            self.navigationController.tabBarItem.badgeValue=nil;
        }
//    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
        if (unreadCount > 0) {
            //好友关系申请badge 的操作
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
            
            self.navigationController.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",unreadCount];
            
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
            self.navigationController.tabBarItem.badgeValue=nil;
        }
//    }
}

#pragma --mark 登录操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:@"正在登录..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
         }else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     NSLog(@"error:,%@",error.description);
                     
                     TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"登录失败");
                     break;
             }
         }
     } onQueue:nil];
    
}

#pragma --mark  segementedChange 事件
-(void)segementedChange
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"selected:%d",0);
            [_compyChatListVC.view removeFromSuperview];
            [self.view addSubview:_indivChatListVC.view];
            break;
        case 1:
            [_indivChatListVC.view removeFromSuperview];
            [self.view addSubview:_compyChatListVC.view];
            NSLog(@"selected:%d",1);
            break;
            
            
        default:
            break;
    }
    
}




#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [_indivChatListVC refreshDataSource];
    [_compyChatListVC refreshDataSource];
}

-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    [self setupUnreadMessageCount];
}


- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupList];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    if (ret) {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        
        do {
            if (options.noDisturbing) {
                NSDate *now = [NSDate date];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                                               fromDate:now];
                
                NSInteger hour = [components hour];
                //        NSInteger minute= [components minute];
                
                NSUInteger startH = options.noDisturbingStartH;
                NSUInteger endH = options.noDisturbingEndH;
                if (startH>endH) {
                    endH += 24;
                }
                
                if (hour>=startH && hour<=endH) {
                    ret = NO;
                    break;
                }
            }
        } while (0);
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = message.isGroup ? [self needShowNotification:message.conversation.chatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }
#endif
    }
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"[图片]";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"[位置]";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"[音频]";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"[视频]";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversation.chatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        /*NSString *hintText = @"";
         if (error.errorCode != EMErrorServerMaxRetryCountExceeded) {
         if (![[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled]) {
         hintText = @"你的账号登录失败，请重新登陆";
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
         message:hintText
         delegate:self
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil,
         nil];
         alertView.tag = 99;
         [alertView show];
         }
         } else {
         hintText = @"已达到最大登陆重试次数，请重新登陆";
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
         message:hintText
         delegate:self
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil,
         nil];
         alertView.tag = 99;
         [alertView show];
         }*/
        NSString *hintText = @"你的账号登录失败，正在重试中... \n点击 '登出' 按钮跳转到登录页面 \n点击 '继续等待' 按钮等待重连成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:@"继续等待"
                                                  otherButtonTitles:@"登出",
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_compyChatListVC isConnect:NO];
        [_indivChatListVC isConnect:NO];
    }
}


#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:@"%@ %@", username, @"添加你为好友"];
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
    
    [_contactsVC reloadApplyView];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    [_contactsVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES];
    [_compyChatListVC refreshDataSource];
    [_indivChatListVC refreshDataSource];
    [_contactsVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username{
    [_contactsVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
    [_contactsVC reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        
        [_contactsVC reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    TTAlertNoTitle(message);
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
    NSString *message = [NSString stringWithFormat:@"同意加入群组\'%@\'", groupname];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已在其他地方登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 100;
        [alertView show];
    } onQueue:nil];
}

- (void)didRemovedFromServer {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你的账号已被从服务器端移除"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    [_compyChatListVC networkChanged:connectionState];
    [_indivChatListVC networkChanged:connectionState];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    [self hideHud];
    [self showHudInView:self.view hint:@"正在重连中..."];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    [self hideHud];
    if (error) {
        [self showHint:@"重连失败，稍候将继续重连"];
    }else{
        [self showHint:@"重连成功！"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
