//
//  SRRegistBussiness.m
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "SRRegistBussiness.h"

@implementation SRRegistBussiness
@synthesize feedback;
@synthesize username;
@synthesize pwd;
@synthesize phone;

-(void)NewUserRegistInBackground:(NSString*)_username Pwd:(NSString*)_password Phone:(NSString *)_phone{
    
    BmobUser * user = [[BmobUser alloc] init];
    [user setUserName:_username];
    [user setPassword:_password];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
           [self RegistHasSucceed];
            
        } else {
            
            [self RegistHasFailed:error];

        }
    }];
}

-(void) RegistHasFailed:(NSError*)error
{
    self.feedback=@"该用户名已经被注册";
    [self.registerDelegate registerComplete:NO];
}

-(void) RegistHasSucceed
{
    self.feedback=@"注册成功";
    [self.registerDelegate registerComplete:YES];
}

@end
