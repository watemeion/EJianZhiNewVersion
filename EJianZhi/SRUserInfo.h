//
//  RTUserInfo.h
//  Health
//
//  Created by GeoBeans on 14-6-8.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface SRUserInfo : BmobObject{
    
}

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *email;

@property (nonatomic,strong) BmobGeoPoint *depositLocation;

@property (nonatomic,strong) BmobFile *userLogo;

+ (SRUserInfo *)shareInstance;

@end
