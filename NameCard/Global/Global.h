//
//  Global.h
//  NameCard
//
//  Created by 杨昊 on 12-11-26.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#ifndef NameCard_Global_h
#define NameCard_Global_h

#define SYSTEM_VERSION_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//#define NCSERVER        @"http://MobileNameCard.zp366.com"
#define NCSERVER        @"http://137.132.179.44"

#define NCLOGIN         @"/api/MobileClient.ashx?method=login"
#define NCLOGIUT        @"/api/MobileClient.ashx?method=LogOut"
#define NCREGISTER      @"/api/MobileClient.ashx?method=Register"
#define NCUPDATEPWD     @"api/ MobileClient.ashx?method=updatePwd"

#define NCREQUEST       @"/api/NameCardRequest.ashx?method=create"
#define NCSTATUS        @"/api/NameCard.ashx?method=CheckNameCardIsAuditSuccess"    
#define NCSYNC          @"/api/NameCard.ashx?method=GetPassNameCard_GreaterThan"
#endif
