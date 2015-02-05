//
//  SRRegisterVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/21.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "SRRegisterVC.h"
#import <BmobSDK/Bmob.h>
#import "SRLoginVC.h"
#import "SMS_SDK/SMS_SDK.h"

@interface SRRegisterVC ()<registerComplete>

@end

@implementation SRRegisterVC
@synthesize phoneNumber=_phoneNumber;
@synthesize securityCode=_securityCode;
@synthesize userPassword=_userPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.frame = CGRectMake(25, 345, 25, 25);
    [_check1 setTitle:nil forState:UIControlStateNormal];
    [_check1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:_check1];
    [_check1 setChecked:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.rect1=self.floatView.frame;
    
    self.verificationButton.enabled=NO;
    
    self.registerButton.enabled=NO;
    
    agreed=YES;
    
    Register=[[SRRegistBussiness alloc]init];
    Register.registerDelegate=self;
    
    self.timerLabel.hidden=YES;
    
    self.phoneNumber.keyboardType=UIKeyboardTypeNumberPad;
    self.securityCode.keyboardType=UIKeyboardTypeNumberPad;
    
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=NO;
}

- (IBAction)inputVerifyCode:(id)sender {
    verifyCode=self.securityCode.text;
    [self checkFinishedInput];
}

- (IBAction)inputPassword:(id)sender {
    inputPassword=self.userPassword.text;
    [self checkFinishedInput];
}

- (IBAction)inputPhoneNumber:(id)sender {
    if(self.phoneNumber.text.length==11)
    {
        inputPhoneNumber=self.phoneNumber.text;
        self.verificationButton.enabled=YES;
    }else{
        inputPhoneNumber=nil;
        self.verificationButton.enabled=NO;
    }
    [self checkFinishedInput];
}

- (void)registerComplete:(BOOL)isSucceed{
    if (isSucceed) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.registerDelegate successRegistered];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:Register.feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)touchRegister:(id)sender {
    
    [SMS_SDK commitVerifyCode:verifyCode result:^(enum SMS_ResponseState state) {
        if (1==state) {
            Register.username=inputPhoneNumber;
            Register.pwd=inputPassword;
            Register.phone=inputPhoneNumber;
            
            [Register NewUserRegistInBackground:Register.username Pwd:Register.pwd Phone:Register.phone];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:Register.feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)verification:(id)sender {
    
    [SMS_SDK getVerifyCodeByPhoneNumber:inputPhoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1==state) {
            
            [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:Register.feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码获取失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码申请次数超限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起，你的操作太频繁啦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

- (void)keyboardWillShow:(NSNotification *)notification{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        CGRect rect2=CGRectMake(self.rect1.origin.x, self.rect1.origin.y-100, self.rect1.size.width, self.rect1.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            
            self.floatView.frame=rect2;
        }];
    }
}

- (void)keyboardWillhide:(NSNotification *)notification{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.floatView.frame=self.rect1;
        }];
    }
}


- (IBAction)touchBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    agreed=checked;
    [self checkFinishedInput];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumber resignFirstResponder];
    [_securityCode resignFirstResponder];
    [_userPassword resignFirstResponder];
}

- (void)checkFinishedInput{
    if (self.phoneNumber.text.length==11&&self.securityCode.text.length>0&&self.userPassword.text.length>0&&agreed) {
        self.registerButton.enabled=YES;
    }else
        self.registerButton.enabled=NO;
}

-(void)initTimer
{
    self.timerLabel.text=[NSString stringWithFormat:@"%d秒",60];
    self.timerLabel.hidden=NO;
    self.verificationButton.hidden=YES;
    
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    seconds=60;
    [[NSRunLoop currentRunLoop] run];
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    NSLog(@"%d",seconds);
    seconds--;
    
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:YES];
    
}

- (void)showTimer{
    self.timerLabel.text=[NSString stringWithFormat:@"%d秒",seconds];
    
    if (seconds==0) {
        [timer invalidate];
        self.timerLabel.hidden=YES;
        self.verificationButton.hidden=NO;
        seconds=60;
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
