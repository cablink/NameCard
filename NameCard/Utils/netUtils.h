//
//  netUtils.h
//  NameCard
//
//  Created by 杨昊 on 12-12-3.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "sqlHelp.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "Global.h"
#import "NCSingleInstant.h"


@interface netUtils : NSObject


-(BOOL)regist:(NSString *)email password:(NSString *)pwd spassword:(NSString *)spwd;
-(int)login:(NSString *)email password:(NSString *)pwd;
-(BOOL)logout;
-(BOOL)checkImageStatus;
-(BOOL)syncNameCard:(NSString *)num;
-(BOOL)checkLoginStatus;
-(BOOL)delNameCard;

@end


