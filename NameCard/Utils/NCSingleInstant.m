//
//  NCSingleInstant.m
//  NameCard
//
//  Created by 杨昊 on 12-12-3.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "NCSingleInstant.h"
#import <sys/param.h>
#import <sys/mount.h>

@implementation NCSingleInstant
@synthesize dbpath,imagePath,user,uid,isCam,queue,isMe,isSec;

+(NCSingleInstant *)shared
{
    static NCSingleInstant *single = nil;
    static dispatch_once_t p;
    
    dispatch_once(&p,^{
        single = [[NCSingleInstant alloc] init];
    });
    return single;
    /*
    @synchronized(self)
    {
        if(!single)
            single = [[NCSingleInstant alloc] init];
        return single;
    }
     */
}

+(NSString *)filterString:(NSString *)str
{
    NSString *s=@"";
    if(str != nil)
        s = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    //NSLog(@"%@",s);
    return s;
}

+(NSString *)trim:(NSString *)s
{
    NSString *temp = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return temp;
}

+(NSString *)trimSpace:(NSString *)str
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [[NCSingleInstant trim:str] componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@""]; 
}

+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no ''@'' or ''.'' present
        return NO;
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilterString ? stricterFilterString:laxString;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


+(void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NetWork Status"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

+(BOOL)checkNetworkStatus
{
    BOOL b = YES;
    
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus ==NotReachable) &&([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
   /* Reachability *r = [Reachability reachabilityWithHostName:@"http://137.132.179.44/showJson.html"];
    switch ([r currentReachabilityStatus]) {
                      
        case NotReachable:*/
        {
            b=NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NetWork Status"
                                                            message:@"NetWork problem,please check first"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
/*
            break;
        }
        case ReachableViaWWAN:
            break;
            
        case ReachableViaWiFi:
            break;*/
    }
    return b;
    
}

+(void)checkDevice
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    NSLog(@"Plateform %@",platform);
}

+(void)dialNumber:(NSString *)num
{
    @try{
        //UIWebView *callView;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",num]];
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.sohu.com"]];
        
        //NSLog(@"URL:%@",url);
        //[NCSingleInstant alertWithMessage:[url absoluteString]];
        /*if(callView == nil){
            callView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
        }
        [callView loadRequest:[NSURLRequest requestWithURL:url]];
        callView = nil;*/
        [[UIApplication sharedApplication] openURL:url];
    }
    @catch (NSException *e) {
        NSLog(@"Error:%@",e);
        
    }
    
}

+(void)sendMail:(NSString *)address
{
    @try{
        //UIWebView *callView;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",address]];
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.sohu.com"]];
        
        //NSLog(@"URL:%@",url);
        //[NCSingleInstant alertWithMessage:[url absoluteString]];
        /*if(callView == nil){
         callView = [[UIWebView alloc] initWithFrame:CGRectZero];
         
         }
         [callView loadRequest:[NSURLRequest requestWithURL:url]];
         callView = nil;*/
        [[UIApplication sharedApplication] openURL:url];
    }
    @catch (NSException *e) {
        NSLog(@"Error:%@",e);
        
    }
    
}

+(NSString *)freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"free size：%qi MB" ,freespace/1024/1024];
}

+(void)setLoginInfo:(NSInteger)i setName:(NSString*)user setSec:(BOOL)b{
    [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:@"isSec"];
}

@end
