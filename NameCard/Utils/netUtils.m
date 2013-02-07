//
//  netUtils.m
//  NameCard
//
//  Created by 杨昊 on 12-12-3.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "netUtils.h"

@implementation netUtils
-(BOOL)logout
{
    BOOL b = NO;
    sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    NSString *s = @"delete from loginStatus";
    if([db openDB]){
        if([db DeleteTableBatch:s]){
            b = YES;
        }
        [db closeDatabase];
    }
    db = nil;
    return b;
    
}

-(BOOL)delNameCard
{
    sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    if([db openDB])
    {
        NSString *sql = [NSString stringWithFormat:@"delete from namecard"];
        [db DeleteTableBatch:sql];
        [db closeDatabase];
    }
    db = nil;
}

-(BOOL)checkLoginStatus
{
    BOOL b = NO;
    /*sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    NSString *s = @"select id,account from loginStatus";
    NSArray *arr = [db querryTable:s];
    if((arr != nil)&&([arr count]>0)){
        NSDictionary *d = [arr objectAtIndex:0];
        [NCSingleInstant shared].user = [d objectForKey:@"account"];
        [NCSingleInstant shared].uid = [[d objectForKey:@"id"] intValue];
        b = YES;
    }
    db = nil;*/
    
    
    [NCSingleInstant shared].user= [[NSUserDefaults standardUserDefaults] stringForKey:@"user"];
    if([NCSingleInstant shared].user != nil)
    {
        [NCSingleInstant shared].uid = [[NSUserDefaults standardUserDefaults] integerForKey:@"uid"];
        [NCSingleInstant shared].isSec = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSec"];
        b = YES;
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    return b;
}

-(NSDictionary *)parseRequest:(ASIHTTPRequest *)request
{
    
    NSString *s = [request responseString];
    NSData *jsons = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* d =[NSJSONSerialization
                      JSONObjectWithData:jsons //1
                      
                      options:kNilOptions
                      error:&error];
    return d;
}

-(BOOL)regist:(NSString *)email password:(NSString *)pwd spassword:(NSString *)spwd
{
    
    BOOL r=NO;
    
    if([NCSingleInstant checkNetworkStatus])
    {
        NSString *s = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,NCREGISTER];
        NSURL *url = [NSURL URLWithString:s];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:email forKey:@"email"];
        [request setPostValue:pwd forKey:@"pwd"];
        
        if(spwd != nil)
            [request setPostValue:spwd forKey:@"se_pwd"];
        
        [request startSynchronous];
        //[request startSynchronous];
        NSError *error = [request error];
        if(!error){
            //NSLog(@"Request:%@",[request responseString]);
           /* NSString *s = [request responseString];
            NSData *jsons = [s dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary* d =[NSJSONSerialization
                                 JSONObjectWithData:jsons //1
                                 
                                 options:kNilOptions
                                 error:&error];*/
           
            NSDictionary* d = [self parseRequest:request];
            NSString *ret = [d objectForKey:@"ret"];
            int i = [ret intValue];
            if(i == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register" message:@"Register success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    //NSString *str = [self stringFormDict:d];
            //NSLog(@"%@",str);
                [alert show];
                r = YES;
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register" message:[d objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //NSString *str = [self stringFormDict:d];
                //NSLog(@"%@",str);
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register" message:@"Network is wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //NSString *str = [self stringFormDict:d];
            //NSLog(@"%@",str);
            [alert show];
            NSLog(@"Error:%@",error.debugDescription);
        }
    }
    return r;
}

-(int)login:(NSString *)email password:(NSString *)pwd
{
    int r=0;
    if([NCSingleInstant checkNetworkStatus])
    {
        NSString *s = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,NCLOGIN];
        NSURL *url = [NSURL URLWithString:s];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:email forKey:@"email"];
        [request setPostValue:pwd forKey:@"pwd"];
        [request setUseCookiePersistence:YES];
       // [requst s]
        [request startSynchronous];
        //[request startSynchronous];
        NSError *error = [request error];
        if(!error){
            NSDictionary* d = [self parseRequest:request];
            NSString *ret = [d objectForKey:@"ret"];
            int i = [ret intValue];
            if(i != 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" message:[d objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //NSString *str = [self stringFormDict:d];
                //NSLog(@"%@",str);
                [alert show];
            }else{
                NSDictionary *data = [d objectForKey:@"data"];
                
                r = [[data objectForKey:@"LoginVerifyType"] intValue];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" message:@"Network problem" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //NSString *str = [self stringFormDict:d];
            //NSLog(@"%@",str);
            [alert show];
        }
    }
    return r;
}
-(NSString *)combineRquestID
{
   NSMutableString *r = [[NSMutableString alloc] init];
    
    sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    NSString *sql = [[NSString alloc] initWithFormat:@"select requestId from picture where status <>1 and status <>4 and requestId <>0 and accountid = %i",[NCSingleInstant shared].uid];
    NSLog(@"combineRequestID:%@",sql);
    NSArray *arr = [db querryTable:sql];
    NSDictionary *d = nil;
    if((arr != nil)&&([arr count]>0))
    {
        int num = [arr count];
        for(int i = 0;i<num;i++)
        {
            d = [arr objectAtIndex:i];
            NSString *s = [d objectForKey:@"requestId"];
            [r appendString:s];
            if(i < num-1)
                [r appendString:@","];
        }
    }
    NSLog(@"R is %@",r);
    return r;
}
-(BOOL)checkImageStatus
{
    BOOL r=NO;
    if([NCSingleInstant checkNetworkStatus])
    {
        NSString *s = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,NCSTATUS];
        NSURL *url = [NSURL URLWithString:s];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"1" forKey:@"mobileLogin"];
        [request setPostValue:[self combineRquestID] forKey:@"IdNameCardRequest"];
        //[request setPostValue:@"95" forKey:@"IdNameCardRequest"];
        [request setPostValue:[NCSingleInstant shared].user forKey:@"email"];
        [request setTimeOutSeconds:30];
        [request startSynchronous];
        //[request startSynchronous];
        NSError *error = [request error];
        if(!error)
        {
            @try{
                //NSLog(@"Request:%@",[request responseString]);
                NSDictionary* d = [self parseRequest:request];
                
                NSString *temp = [d objectForKey:@"ret"];
                int i = [temp intValue];
                if(i == 1){
                    r = YES;
                    sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
                    if(![db openDB])
                        return NO;
                    
                    NSArray *arr = [d objectForKey:@"data"];
                    NSDictionary *d1;
                    for(d1 in arr)
                    {
                        NSDictionary *requestDict = [d1 objectForKey:@"NameCardRequestInfo"];
                        NSString *s1 = [requestDict objectForKey:@"ImageStatus"];
                        int i1 = [s1 intValue];
                        NSString *sql = nil;
                        if(i1 == 1){
                            sql = [[NSString alloc] initWithFormat:@"update picture set status = 1, description = '%@' where id = %@",[requestDict objectForKey:@"Comment"],[requestDict objectForKey:@"IdClientPid"]];
                            NSLog(@"Update picture status:%@",sql);
                            [db UpdataTableBatch:sql];
                            sql = nil;
                            sql = [[NSString alloc] initWithFormat:@"select type from picture where id = %@",[requestDict objectForKey:@"IdClientPid"]];
                            
                            NSArray *a = [db querryTableBatch:sql];
                            NSDictionary *d = [a objectAtIndex:0];
                            NSString *t = [d objectForKey:@"type"];
                            int i = [t intValue];
                            if(i == 1){
                            
                                sql = [[NSString alloc] initWithFormat:@"update nameCard set typeid = 0 where  accountid = %i and typeid = 1",[NCSingleInstant shared].uid];
                                [db UpdataTableBatch:sql];
                            }
                            sql = nil;
                            
                            NSDictionary *card = [d1 objectForKey:@"NameCardInfo"];
                            sql = [NSString stringWithFormat:@"insert into nameCard(e_name,c_name,py_name,title,company,address,postcode,web,fax,mobile,telephone,email,department,accountid,f_page,b_page,thumb,requestId,typeid,c_country,c_state,c_city,c_street,lastname,others) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%i,'%@','%@','%@',%@,%@,'%@','%@','%@','%@','%@','%@')",
                                   [NCSingleInstant filterString:[card objectForKey:@"NameEnglish"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"NameChinese"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"NamePinYin"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"Position"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyName"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyAddress"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyZipCode"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyWebsite"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyFaxNo"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"MobileNo"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"TelNo"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"EmailAddress"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"Department"]],
                                   [NCSingleInstant shared].uid,
                                   [card objectForKey:@"NameCardImageF"],
                                   [card objectForKey:@"NameCardImageB"],
                                   [card objectForKey:@"Thumb"],
                                   [card objectForKey:@"IdNameCardRequest"],
                                   t,
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyCountry"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyState"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyCity"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"CompanyStreet"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"LastName"]],
                                   [NCSingleInstant filterString:[card objectForKey:@"Other"]]
                                   ];
                            NSLog(@"%@",sql);
                            [db InsertTableBatch:sql];
                            sql = nil;
                            
                        }else if(i1 ==4){
                            sql = [[NSString alloc] initWithFormat:@"update picture set status = 4, description = '%@' where id = %@",[requestDict objectForKey:@"Comment"],[requestDict objectForKey:@"IdClientPid"]];
                            NSLog(@"%@",sql);
                            [db UpdataTableBatch:sql];
                        }
                    }
                    [db closeDatabase];
                    db = nil;
                }
            }@catch (NSException *e) {
                
                NSLog(@"checkStatus:%@",e);
            }
            
        }else{
            
            NSLog(@"%@",error.description);
           
        }
    }
    return r;
}
-(BOOL)syncNameCard:(NSString *)num
{
    BOOL r=NO;
    NSString *sql = nil;
    if([NCSingleInstant checkNetworkStatus])
    {
        NSString *s = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,NCSYNC];
        NSURL *url = [NSURL URLWithString:s];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"1" forKey:@"mobileLogin"];
        [request setPostValue:num forKey:@"IdNameCard"];
        [request setPostValue:[NCSingleInstant shared].user forKey:@"email"];
        [request setTimeOutSeconds:30];
        [request startSynchronous];
        //[request startSynchronous];
        NSError *error = [request error];
        if(!error){
            @try{
            NSLog(@"Request:%@",[request responseString]);
            NSDictionary* d = [self parseRequest:request];
            
            NSString *temp = [d objectForKey:@"ret"];
            int i = [temp intValue];
            if(i == 1){
                r = YES;
                sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
                [db openDB];
                NSArray *arr = [d objectForKey:@"data"];
                NSDictionary *card;
                for(card in arr)
                {
                    sql = [NSString stringWithFormat:@"select id,status from picture where requestId = %@",[card objectForKey:@"idNameCardRequest"]];
                    NSArray *a = [db querryTableBatch:sql];
                    if((a!=nil)&&([a count]>0)){
                        NSDictionary *d1 = [a objectAtIndex:0];
                        int status = [[d1 objectForKey:@"status"] intValue];
                        if( status !=1){
                            sql = [NSString stringWithFormat:@"update picture set status = 1 ,description = '' where id = %@",[d1 objectForKey:@"id"]];
                        }
                        
                    }
                                            sql = [NSString stringWithFormat:@"insert into nameCard(e_name,c_name,py_name,title,company,address,postcode,web,fax,mobile,telephone,email,department,accountid,f_page,b_page,thumb,requestId,typeid,c_country,c_state,c_city,c_street,lastname,others) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%i,'%@','%@','%@',%@,%@,'%@','%@','%@','%@','%@','%@')",
                           [NCSingleInstant filterString:[card objectForKey:@"NameEnglish"]],
                           [NCSingleInstant filterString:[card objectForKey:@"NameChinese"]],
                           [NCSingleInstant filterString:[card objectForKey:@"NamePinYin"]],
                           [NCSingleInstant filterString:[card objectForKey:@"Position"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyName"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyAddress"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyZipCode"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyWebsite"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyFaxNo"]],
                           [NCSingleInstant filterString:[card objectForKey:@"MobileNo"]],
                           [NCSingleInstant filterString:[card objectForKey:@"TelNo"]],
                           [NCSingleInstant filterString:[card objectForKey:@"EmailAddress"]],
                           [NCSingleInstant filterString:[card objectForKey:@"Department"]],
                           [NCSingleInstant shared].uid,
                           [card objectForKey:@"NameCardImageF"],
                           [card objectForKey:@"NameCardImageB"],
                           [card objectForKey:@"Thumb"],
                           [card objectForKey:@"IdNameCardRequest"],
                           [card objectForKey:@"NameCardType"],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyCountry"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyState"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyCity"]],
                           [NCSingleInstant filterString:[card objectForKey:@"CompanyStreet"]],
                           [NCSingleInstant filterString:[card objectForKey:@"LastName"]],
                           [NCSingleInstant filterString:[card objectForKey:@"Other"]]
                           ];

                    NSLog(@"%@",sql);
                        [db InsertTableBatch:sql];
                        sql = nil;
                }
                [db closeDatabase];
                db = nil;
            }
            }@catch (NSException *e) {
                NSLog(@"Sync error:%@",e);
            }
            
        }else{
            
            NSLog(@"%@",error.description);
            
        }
    }
    return r;
}

@end
