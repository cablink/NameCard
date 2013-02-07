//
//  NCSingleInstant.h
//  NameCard
//
//  Created by 杨昊 on 12-12-3.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Global.h"
#import "sqlHelp.h"

@interface NCSingleInstant : NSObject{
    
}

@property(strong,nonatomic)NSString *dbpath;
@property(strong,nonatomic)NSString *imagePath;
@property(strong,nonatomic)NSString *user;
@property int uid;
@property(strong,nonatomic)NSString *isCam;
@property(strong,nonatomic)NSMutableDictionary *queue;
@property BOOL isMe;
@property BOOL isSec;

+(NSString *)filterString:(NSString *)str;
+(NSString *)trimSpace:(NSString *)str;
+(NCSingleInstant *)shared;
+(NSString *)trim:(NSString *)s;
+(void)alertWithMessage:(NSString *)msg;
+(BOOL)checkNetworkStatus;
+(BOOL)validateEmail:(NSString*)email;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(void)checkDevice;
+(void)dialNumber:(NSString *)num;
+(void)sendMail:(NSString *)address;
+(NSString *)freeDiskSpaceInBytes;
+(void)setLoginInfo:(NSInteger)i setName:(NSString*)user setSec:(BOOL)b;
@end
