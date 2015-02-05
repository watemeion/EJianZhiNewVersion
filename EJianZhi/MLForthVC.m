//
//  MLForthVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLForthVC.h"
#import <BmobSDK/Bmob.h>
#import "SRLoginVC.h"
#import "MLJobListViewController.h"

@interface MLForthVC ()<finishLogin,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIView *containerView;




@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


- (IBAction)showMyAppliedJob:(id)sender;

- (IBAction)showMyFavoriteAction:(id)sender;



@end

@implementation MLForthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

-(void)viewWillLayoutSubviews
{


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([BmobUser getCurrentObject]!=nil) {
        [self finishLogin];
    }
    else {
        [self finishLogout];
    }
}

- (IBAction)login:(id)sender {
    
    if ([BmobUser getCurrentUser]==nil){
        SRLoginVC *loginVC=[SRLoginVC shareLoginVC];
        loginVC.finishLoginDelegate=self;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出账户？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.delegate=self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        BOOL isLogout=[SRLoginBusiness logOut];
        if (isLogout) {
            [self finishLogout];
        }
    }
}

- (void)finishLogout{
    
    self.buttonLabel.text=[NSString stringWithFormat:@"点击登录"];
    
    self.logoutButton.hidden=YES;
    //动态绑定LoginButton响应函数
    self.logoutButton.tag=10000;
    
    self.bottomConstraint.constant=-60;
}

- (void)finishLogin{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    self.buttonLabel.text=[NSString stringWithFormat:@"%@",[mySettingData objectForKey:@"currentUserName"]];
    
    self.logoutButton.hidden=NO;
    //动态绑定LoginButton响应函数
    self.logoutButton.tag=20000;
    
    self.bottomConstraint.constant=0;
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

- (IBAction)showMyAppliedJob:(id)sender {
    //自定义列表
    
    
    
    
}

- (IBAction)showMyFavoriteAction:(id)sender {
   
    MLJobListViewController *myFavoriteListVC=[[MLJobListViewController alloc]init];
    myFavoriteListVC.navigationController.navigationItem.title=@"我的收藏";
    myFavoriteListVC.hidesBottomBarWhenPushed=YES;
    myFavoriteListVC.navigationController.navigationBar.hidden=NO;
    [self.navigationController pushViewController:myFavoriteListVC animated:YES];
}



@end
