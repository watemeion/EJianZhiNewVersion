//
//  RTLoginBusiness.m
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//


#import "SRLoginBusiness.h"


@implementation SRLoginBusiness

-(void)loginInbackground:(NSString *)username Pwd:(NSString *)pwd
{
    [BmobUser loginWithUsernameInBackground:username password:pwd block:^(BmobUser *user, NSError *error) {
        if (user != nil&&!error) {
            
            [self dragUserDataFromBmob];
        }
        else {
            [self loginIsSucceed:NO];
        }
    }];
}

-(BOOL)loginIsSucceed:(BOOL)result
{
    if (result) {
        self.feedback=@"登录成功";
        [self.loginDelegate loginSucceed:YES];
    }
    else
    {
        self.feedback=@"登录失败";
        [self.loginDelegate loginSucceed:NO];

    }
    return result;
}

-(BOOL)saveUserInfoLocally:(SRUserInfo*)_currentInfo
{
    //本地化常用数据
    //currentUserName 当前用户名
    
    if (_currentInfo!=nil) {
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:_currentInfo.username forKey:@"currentUserName"];
        [mySettingData synchronize];
    }
    return YES;
}

-(BOOL)checkIfAuto_login
{
    BmobUser *cuser=[BmobUser getCurrentUser];
    if(cuser!=nil)
    {
        return YES;
    }
    else
    {
     return NO;
    }
}


+(BOOL)logOut
{
    //退出机制

    [BmobUser logout];  //清除缓存用户对象
    
    if ([BmobUser getCurrentUser]==nil) {
        //设置NSUserdefault
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        
        [mySettingData setBool:NO forKey:@"auto_login"];
        
        [mySettingData removeObjectForKey: @"currentUserName"];
        
        [mySettingData synchronize];
        
        return YES;
    }
    else
        return NO;
}

-(void)dragUserDataFromBmob
{
    BmobQuery *query  = [BmobUser query];
    BmobUser *currentUser=[BmobUser getCurrentObject];
    
    [query getObjectInBackgroundWithId:[currentUser objectId] block:^(BmobObject *object, NSError *error) {
        if (error == nil) {
            SRUserInfo *user=[SRUserInfo shareInstance];
            user.username=[object objectForKey:@"username"];
            user.email=[object objectForKey:@"email"];
            user.phone=[object objectForKey:@"phone"];
            
            //本地化
            [self saveUserInfoLocally:user];
            
            [self loginIsSucceed:YES];
            
        } else {
            
            [self loginIsSucceed:NO];
        }
    }];
}

@end
