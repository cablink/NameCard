//
//  NCCameraController.m
//  NameCard
//
//  Created by 杨昊 on 12-11-18.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "NCCameraController.h"
#import "NCSingleInstant.h"
#import "sqlHelp.h"
#import "Global.h"
@interface NCCameraController (){
    //NSString *lastPic;
    NSString *front;
    NSString *back;
    NSString *thumb;
    BOOL b;
    sqlHelp *db;
    BOOL me;
}
    
@end

@implementation NCCameraController
@synthesize backButton,finishButton,cancelButton;

static UIImage *shrinkImage(UIImage *original, CGSize size);


@synthesize imageView;
@synthesize imageFrame;
@synthesize isMe;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.hidesBottomBarWhenPushed = YES;
   // self.tabBarController.tabBar.hidden = YES;
    b = NO;
    front = nil;
    back = nil;
    //if([NCSingleInstant shared].step ==nil)
     //   [NCSingleInstant shared].step =@1;
    //[self showCam];
    CGSize s = self.view.frame.size;
    if(s.height >480){
        [imageView setFrame:CGRectMake(0, 0, 320.0, 410.f)];
        [backButton setFrame:CGRectMake(20,415, 73.0, 40.0)];
        [finishButton setFrame:CGRectMake(125,415, 73.0, 40.0)];
        [cancelButton setFrame:CGRectMake(225,415, 73.0, 40.0)];
    }
    //NSLog(@"width:%f height:%f",s.width,s.height);
    db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    [self showCustomCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.hidesBottomBarWhenPushed = YES;
   // [self.view setFrame:CGRectMake(self.view.frame.origin.x, 460, self.view.frame.size.width,	self.view.frame.size.height)];
        //self.tabBarController.hidesBottomBarWhenPushed = YES;
   /* if([NCSingleInstant shared].isCam==nil){
       [NCSingleInstant shared].isCam=@1;
        [self showCam];
    }
    else*/
    //[self showCam];
        //[self performSegueWithIdentifier:@"showImage" sender:nil];
    if(!b)
        [self showCustomCamera];
   
}
-(NSString *)getFileName
{
    NSDate *now= [NSDate date];
    NSString *s = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [calendar components:unitFlags fromDate:now];
   
    s = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",[d year],[d month],[d day],[d hour],[d minute],[d second]];
    return s;
}
- (void)showCustomCamera
{
    
    // Create UIImagePickerController
        
    
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        picker = [[UIImagePickerController alloc] init];
        // Set the source type to the camera
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        //picker.allowsEditing = YES;
        // Set ourself as delegate
        [picker setDelegate:self];
        [picker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        [self presentViewController:picker animated:YES completion:nil];
        //[self navigationController:self.navigationController willShowViewController:picker animated:YES];
        picker = nil;
    }else{
        [NCSingleInstant alertWithMessage:@"There is no Rear Camera in this device"];
    }
       // Present the picker
    
}

- (void)pickerCameraSnap:(id)sender{
    [picker takePicture];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
   // UIImage *shrunkenImage = shrinkImage(image, imageFrame.size);
   // imageView.image=shrunkenImage;
    NSString *document  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDocPath = [document stringByAppendingPathComponent:@"ImageFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageDocPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *str = [self getFileName];
    NSString *t = [[NSString alloc] initWithFormat:@"%@.jpg",str];
    NSString *f=[imageDocPath stringByAppendingPathComponent:t];
    [UIImageJPEGRepresentation(image, 0.3f) writeToFile:f atomically:YES];    
    if(!b){
        NSString *th = [NSString stringWithFormat:@"%@_thumb.jpg",str];
    
        thumb=[imageDocPath stringByAppendingPathComponent:th];
    
    
        [UIImageJPEGRepresentation([self scaleImage:image toScale:0.2],0.3f) writeToFile:thumb atomically:YES];
        NSLog(@"ThumbImage is %@",thumb);
    }
    
    if(!b)
        front = [NSString stringWithString:f];
    else
        back = [NSString stringWithString:f];
    
    NSData *img = [NSData dataWithContentsOfFile:f];
    
    imageView.image = [UIImage imageWithData:img];
    b=YES;
 
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:2];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}
-(void)addSomeElements:(UIViewController *)viewController{
    
    
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];  //左下角按钮
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
    [useButton setTitle:@"上传" forState:UIControlStateNormal];  //右下角按钮
}
/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [self addSomeElements:viewController];
}
*/
- (IBAction)btnCancel:(id)sender {
    front = nil;
    back = nil;
    b = NO;
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)btnBack:(id)sender {
    [self showCustomCamera];
    picker = nil;
    
}


- (IBAction)btnFinish:(id)sender {
    
    NSString *sql;
    int i;
    
    
    //NSLog(@"%@",document);
   // NSString *dir = [document stringByAppendingPathComponent:@"DB"];
    me = [NCSingleInstant shared].isMe;
    if(front !=nil){
        if(back == nil){
            if(!me)
                sql= [[NSString alloc] initWithFormat:@"insert into picture(f_page,accountid,status,thumb) values('%@',%i,-1,'%@')",front,[NCSingleInstant shared].uid,thumb];
            else
                sql= [[NSString alloc] initWithFormat:@"insert into picture(f_page,accountid,status,type,thumb) values('%@',%i,-1,1,'%@')",front,[NCSingleInstant shared].uid,thumb];
        }
        else
            if(!me)
                sql= [[NSString alloc] initWithFormat:@"insert into picture(f_page,s_page,accountid,status,thumb) values('%@','%@',%i,-1,'%@')",front,back,[NCSingleInstant shared].uid,thumb];
            else
                sql= [[NSString alloc] initWithFormat:@"insert into picture(f_page,s_page,accountid,status,type,thumb) values('%@','%@',%i,-1,1,'%@')",front,back,[NCSingleInstant shared].uid,thumb];
        NSLog(@"%@",sql);
        
        if(db != nil){
            i = [db InsertTableWithID:sql];
            if(i>0){
                __block NSString *f_page = front;
                __block NSString *b_page = back;
                __block int index= i;
                
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self sendData:index fistpage:f_page backpage:b_page];
                  
                });
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image" message:@"DB error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //NSString *str = [self stringFormDict:d];
                //NSLog(@"%@",str);
                [alert show];
            }
        }else
            db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image" message:@"Please scan first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
        [alert show];
    }
    front = nil;
    back = nil;
    b = NO;
    [self.tabBarController setSelectedIndex:2];
    
}

-(void)sendData:(int)index fistpage:(NSString *)f_page backpage:(NSString *)b_page
{
    if([NCSingleInstant checkNetworkStatus])
    {
        
        NSString *s = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,NCREQUEST];
        
        
        NSURL *url = [NSURL URLWithString:s];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSString *in = [[NSString alloc] initWithFormat:@"%i",index];
        [request setPostValue:@"1" forKey:@"mobileLogin"];
        [request setFile:f_page forKey:@"OriginalNameCardImageF"];
        if(b_page != nil)
            [request setFile:b_page forKey:@"OriginalNameCardImageB"];
        [request setPostValue:[NCSingleInstant shared].user forKey:@"email"];
        [request setPostValue:in forKey:@"IdClientPid"];
        if(me)
            [request setPostValue:@"1" forKey:@"nameCardType"];
        else
            [request setPostValue:@"0" forKey:@"nameCardType"];
        /*
        [request setFile:f_page forKey:@"file"];
        [request setPostValue:@"upload" forKey:@"sub"];
        [request setPostValue:@"reset" forKey:@"res"];*/
        //[request setDelegate:self];
        
        
        
        NSStringEncoding enc= CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingUTF8);
        
        [request setStringEncoding :enc];
        
           
        //[ request setDidFinishSelector : @selector ( responseComplete )];
        
        //[ request setDidFailSelector : @selector (responseFailed)];
        
        NSLog(@"Begin send image");
        [request setTimeOutSeconds:30];
        [request startSynchronous];
        NSError *e = [request error];
   /*     if([[NSFileManager defaultManager] fileExistsAtPath:f_page])
            NSLog(@"OK:%@",f_page);
        else
            NSLog(@"Error:%@",f_page);
        if([[NSFileManager defaultManager] fileExistsAtPath:b_page])
            NSLog(@"OK:%@",b_page);
        else
            NSLog(@"Error:%@",b_page);*/
        if(!e){
            NSString *resp = [ request responseString ];
            //[NCSingleInstant alertWithMessage:resp];
            NSLog(@"%@",resp);
            NSData *jsons = [resp dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary* d =[NSJSONSerialization
                              JSONObjectWithData:jsons
                              options:kNilOptions
                              error:&error];
            if(error==nil){
                NSString *ret = [d objectForKey:@"ret"];
                int i = [ret intValue];
                if(i == 1){
                    NSDictionary *data = [d objectForKey:@"data"];
                    NSString *pid = [data objectForKey:@"IdClientPid"];
                    NSString *sql = [[NSString alloc] initWithFormat:@"update picture set requestid = %@,status = %@ where id = %@",[data objectForKey:@"IdNameCardRequest"],[data objectForKey:@"ImageStatus"],pid];
                    NSLog(@"%@",sql);
                    sqlHelp *tdb = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
                    if(tdb != nil)
                    {
                        [tdb UpdataTable:sql];
                        NSLog(@"Update requestid ok");
                    }
                
                }else
                    NSLog(@"Error:%@",[d objectForKey:@"msg"]);
            }else
                NSLog(@"Error:%@",error.description);
        
        }else{
            NSLog(@"NetWork error:%@",e.description);
        }
    }
}
/*
-( void )responseComplete{
    
    // 请求响应结束，返回 responseString
    
    NSString *resp = [ request responseString ];
    
    
    NSLog(@"%@",resp);
    
    
    NSData *jsons = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* d =[NSJSONSerialization
                      JSONObjectWithData:jsons
                      options:kNilOptions
                      error:&error];
    //NSMutableDictionary *d = [jsons objectFromJSONData];
    // NSString *str = [self stringFormDict:d];
    // NSLog(@"%@",str);
    if(error==nil){
        NSString *ret = [d objectForKey:@"ret"];
        int i = [ret intValue];
        if(i == 1){
            NSDictionary *data = [d objectForKey:@"data"];
            NSString *pid = [data objectForKey:@"IdClientPid"];
            NSString *sql = [[NSString alloc] initWithFormat:@"update picture set requestid = %@,status = %@ where id = %@",[data objectForKey:@"IdNameCardRequest"],[data objectForKey:@"ImageStatus"],pid];
            NSLog(@"%@",sql);
            if(db != nil)
            {
                [db UpdataTable:sql];
                NSLog(@"Update requestid ok");
            }
            
        }else
            NSLog(@"Error:%@",[d objectForKey:@"msg"]);
    }else
        NSLog(@"Error:%@",error.description);
    //[self.tabBarController setSelectedIndex:2];
}

-( void )respnoseFailed{
    
    // 请求响应失败，返回错误信息
    
    NSError *error = [ request error ];
    NSLog(@"Network error:%@",error.description);
    //[self.tabBarController setSelectedIndex:2];
}
 */
- (void)viewDidUnload {
    
    [self setBackButton:nil];
    [self setFinishButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    db =nil;
    front = nil;
    back = nil;
}
@end
