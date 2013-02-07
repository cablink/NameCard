//
//  NCCardViewController.m
//  NameCard
//
//  Created by 杨昊 on 12-11-23.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "NCCardViewController.h"
#import "NCImageViewController.h"
#import "sqlHelp.h"
#import "NCSingleInstant.h"

@interface NCCardViewController (){
    NSArray *name;
    NSArray *personal;
    NSArray *company;
    NSArray *address;
    NSArray *others;
    NSArray *caption;
    sqlHelp *db;
    NSString *f_page;
    NSString *b_page;
}

@end

@implementation NCCardViewController
@synthesize array;
@synthesize cid;
@synthesize myTableView;

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
    
    db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    if(db != nil)
        [self loadData];
	// Do any additional setup after loading the view.
    
     
}

-(void)loadData
{
    NSDictionary *d = nil;
    
    
    caption = [NSArray arrayWithObjects:@"",@"Personal Information",@"Company Information",@"Address",@"Others", nil];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select e_name,mobile,telephone,email,title,department,company,web,fax,others,f_page,b_page,address,c_country,c_state,c_city,c_street,lastname from nameCard where id = %@",cid];
    NSLog(@"sql:%@",sql);
    NSArray *arr = [db querryTable:sql];
    if([arr count]==0)
        arr = nil;
    d = [arr objectAtIndex:0];
    NCRecord *n1 = [NCRecord new];
    n1.title = @"Name:";
    n1.value = [NSString stringWithFormat:@"%@ %@",[d objectForKey:@"e_name"],[d objectForKey:@"lastname"]];
    name = [[NSArray alloc]initWithObjects:n1,nil];
    
    NCRecord *n2 = [[NCRecord alloc]init];
    n2.title = @"Mobile:";
    n2.value = [d objectForKey:@"mobile"];
    NCRecord *n3 = [[NCRecord alloc]init];
    n3.title = @"Telephone:";
    n3.value = [d objectForKey:@"telephone"];
    NCRecord *n4 = [[NCRecord alloc]init];
    n4.title = @"Email:";
    n4.value = [d objectForKey:@"email"];
    personal = [[NSArray alloc]initWithObjects:n2,n3,n4,nil];
    
    NCRecord *n5 = [[NCRecord alloc]init];
    n5.title = @"Title:";
    n5.value = [d objectForKey:@"title"];
    NCRecord *n12 = [[NCRecord alloc]init];
    n12.title = @"Dept.:";
    n12.value = [d objectForKey:@"department"];
    NCRecord *n6 = [[NCRecord alloc]init];
    n6.title = @"Company:";
    n6.value = [d objectForKey:@"company"];
    NCRecord *n8 = [[NCRecord alloc]init];
    n8.title = @"Web:";
    n8.value = [d objectForKey:@"web"];
    NCRecord *n9 = [[NCRecord alloc]init];
    n9.title = @"Fax:";
    n9.value = [d objectForKey:@"fax"];
    company = [[NSArray alloc]initWithObjects:n5,n12,n6,n8,n9, nil];
    
    NCRecord *n16 = [[NCRecord alloc]init];
    n16.title = @"Bld/Unit:";
    n16.value = [d objectForKey:@"address"];
    NCRecord *n7 = [[NCRecord alloc]init];
    n7.title = @"Street:";
    n7.value = [d objectForKey:@"c_street"];
    NCRecord *n13 = [[NCRecord alloc]init];
    n13.title = @"City:";
    n13.value = [d objectForKey:@"c_city"];
    NCRecord *n14 = [[NCRecord alloc]init];
    n14.title = @"State:";
    n14.value = [d objectForKey:@"c_state"];
    NCRecord *n15 = [[NCRecord alloc]init];
    n15.title = @"Country:";
    n15.value = [d objectForKey:@"c_country"];
    
    address =[[NSArray alloc]initWithObjects:n16,n7,n13,n14,n15, nil];
     
    NCRecord *n10=[[NCRecord alloc]init];
    n10.title = @"Notes:";
    n10.value = [d objectForKey:@"others"];
    others = [[NSArray alloc]initWithObjects:n10, nil];
    array = [NSArray arrayWithObjects:name,personal, company,address,others,nil];
    if(([d objectForKey:@"f_page"]!= nil)&&([[d objectForKey:@"f_page"] length]!=0))
       f_page = [NSString stringWithFormat:@"%@",[d objectForKey:@"f_page"]];
    if(([d objectForKey:@"b_page"]!= nil)&&[[d objectForKey:@"b_page"] length]!=0)
        b_page = [NSString stringWithFormat:@"%@",[d objectForKey:@"b_page"]];
    arr = nil;
    d = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return [array count];
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    NSArray *s = [array objectAtIndex:section];
    return [s count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
       
    static NSString *GroupedTableIdentifier = @"detailcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
                
    }
    NSArray *d = [array objectAtIndex:section];
    NCRecord *s = [d objectAtIndex:row];
    //给Label附上名称 
    cell.textLabel.text = s.title;
    cell.detailTextLabel.text = s.value;
    CGSize labelHeight = [s.value sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [cell.detailTextLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [cell.detailTextLabel setNumberOfLines:ceil([self getHeight:s.value]/labelHeight.height)];
    s = nil;
    d = nil;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //这个方法用来告诉表格第section分组的名称
    NSString *tname=[caption objectAtIndex:section];
    //NSString *tname = @"OK";
    return tname;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if((section == 0)&&(row==0))
    {
        [self showCard];
    }
    if(((section==1)&&(row==0))||((section==1)&&(row==1)))
    {
        NSArray *d = [array objectAtIndex:section];
        NCRecord *s = [d objectAtIndex:row];
        NSLog(@"Dial:%@",s.value);
        if(s.value != nil){
            @try{
               /* UIWebView *callView;
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[NCSingleInstant trimSpace:s.value]]];
                NSLog(@"%@",url.absoluteString);
                //[NCSingleInstant alertWithMessage:[url absoluteString]];
                if(callView == nil){
                    callView = [[UIWebView alloc] initWithFrame:CGRectZero];
                 }
                 [callView loadRequest:[NSURLRequest requestWithURL:url]];
                 callView = nil;*/
                //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@"]
               NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[NCSingleInstant trimSpace:s.value]]];
                [[UIApplication sharedApplication] openURL:url];
            }
            @catch (NSException *e) {
                NSLog(@"Error:%@",e);
            
            }
        }
    }
    
    if((section == 1)&&(row == 2)){
        NSArray *d = [array objectAtIndex:section];
        NCRecord *s = [d objectAtIndex:row];
        NSLog(@"Mail:%@",s.value);
        if(s.value != nil){
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (!mailClass) {
                [self alertWithMessage:@"This Device doesn't support send email"];
                return;
            }
            if (![mailClass canSendMail]) {
                [self alertWithMessage:@"Please setup email account on this machine"];
                return;
            }
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.mailComposeDelegate = self;
            [mailPicker setToRecipients:[NSArray arrayWithObject:s.value]];
            [self presentModalViewController: mailPicker animated:YES];
            mailPicker=nil;
        }
    }
        
    NSLog(@"SelectRow:%d",indexPath.row);
    
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h=46.0f;
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSArray *d = [array objectAtIndex:section];
    NCRecord *s = [d objectAtIndex:row];
    h = [self getHeight:s.value];
    if(h<46.0f)
        h = 46.0f;
    return h; 
    
}

-(CGFloat)getHeight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGFloat contentWidth = self.myTableView.frame.size.width;
    
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return size.height+46;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
    
	HUD = nil;
}
void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

-(void)showCard
{
    __block MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    //hud.labelText = @"With a block";
    __block UIImage *f_image = nil;
    __block UIImage *b_image = nil;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        
        if(f_page != nil){
            NSString * str = [NSString stringWithFormat:@"%@%@",NCSERVER,f_page];
            NSURL *url = [NSURL URLWithString:str];
            NSLog(@"Front:%@",str);
            
            f_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if(b_page != nil){
                str = [NSString stringWithFormat:@"%@%@",NCSERVER,b_page];
                url = [NSURL URLWithString:str];
                NSLog(@"Back:%@",str);
                b_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            }
            
        }
        
    } completionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
        
    
        NCImageViewController *d = [[NCImageViewController alloc] init];
        NSMutableArray *a = [[NSMutableArray alloc]init];
        if(f_image != nil){
            [a addObject:f_image];
            if(b_image != nil)
                [a addObject:b_image];
            d.photoList = a;
            [self presentModalViewController:d animated:YES];
        }else{
            [NCSingleInstant alertWithMessage:@"There is no pic on the server"];
        }
    }];
}
-(void)viewDidUnload
{
    [self setMyTableView:nil];
    db = nil;
    array = nil;
    cid = nil;
}
- (IBAction)sendEmail:(id)sender {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"This Device doesn't support send email"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"User doesn't setup email account"];
        return;
    }
    [self displayMailPicker];
}


-(NSString *)loadBody
{
    NSString *str;
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select e_name,mobile,telephone,email,title,department,company,address,web,fax,others,c_street,c_state,c_city,c_country,lastname from nameCard where id = %@",cid];
    NSLog(@"sql:%@",sql);
    NSArray *arr = [db querryTable:sql];
    NSDictionary *d = [arr objectAtIndex:0];
    str = [[NSString alloc] initWithFormat:@"Name:%@ %@<br> Mobile(P):%@<br> Telephone:%@<br> Email:%@<br> Title:%@<br> Dept.:%@<br> Company:%@<br> Address:%@,%@,%@,%@,%@<br> WebSite:%@<br> Fax:%@<br>",
           [d objectForKey:@"e_name"],[d objectForKey:@"lastname"],[d objectForKey:@"mobile"],[d objectForKey:@"telephone"],
           [d objectForKey:@"email"],[d objectForKey:@"title"],[d objectForKey:@"department"],
           [d objectForKey:@"company"],[d objectForKey:@"address"],[d objectForKey:@"c_street"],[d objectForKey:@"c_city"],[d objectForKey:@"c_state"],[d objectForKey:@"c_country"],[d objectForKey:@"web"],[d objectForKey:@"fax"]];
    NSLog(@"%@",str);
    return str;
}

-(void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"Share Name Card"];
    
        
    NSString *emailBody = [self loadBody];
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController: mailPicker animated:YES];
    mailPicker=nil;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg = nil;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            msg = @"Save Mail Success";
            [self alertWithMessage:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"Send Mail Success";
            [self alertWithMessage:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"Send Mail Error";
            [self alertWithMessage:msg];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
/*
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
*/

- (void) alertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Email"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
@end
