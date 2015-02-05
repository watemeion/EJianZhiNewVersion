//
//  SRLoginBusiness.h
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRUserInfo.h"

@protocol loginSucceed <NSObject>
@required
- (void)loginSucceed:(BOOL)isSucceed;
@end


@class BmobUser;

@interface SRLoginBusiness : NSObject
{
   
}

@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *pwd;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *feedback;
@property (nonatomic,weak)BmobUser *isSucceedUserLogin;

@property(nonatomic,weak) id<loginSucceed> loginDelegate;

-(void) loginInbackground:(NSString*) username Pwd:(NSString*)pwd;

-(BOOL) loginIsSucceed:(BOOL)result;

//保存username
-(BOOL)saveUserInfoLocally:(SRUserInfo*)_userInfo;
-(BOOL)checkIfAuto_login;


//登出类方法
+(BOOL)logOut;

@end
