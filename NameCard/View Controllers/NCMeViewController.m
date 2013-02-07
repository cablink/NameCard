//
//  NCMeViewController.m
//  NameCard
//
//  Created by 杨昊 on 12-11-23.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "NCMeViewController.h"
#import "sqlHelp.h"
#import "NCSingleInstant.h"
#import "netUtils.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"


@interface NCMeViewController (){
    NSArray *name;
    NSArray *personal;
    NSArray *company;
    NSArray *address;
    NSArray *others;
    NSArray *caption;
    sqlHelp *db;
    BOOL First;
    NSString *nid;
}

@end

@implementation NCMeViewController
@synthesize array,myButton,myTableView,myCamera;

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
    
    if([NCSingleInstant shared].isSec)
        [myButton setTitle:@"Del Data"];
    
    First = NO;
    caption = [NSArray arrayWithObjects:@"",@"Personal Information",@"Company Information",@"Address",@"Others", nil];
    //d = [[NSMutableDictionary alloc] init];
    db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    if(db != nil)
        [self loadData];
	// Do any additional setup after loading the view.
   // self.hidesBottomBarWhenPushed = NO;
   // self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    if(First)
        [myCamera setTitle:@"Scan"];
    [self loadData];
    [self.myTableView reloadData];
}

-(void)loadData
{
    @try{
        NSDictionary *d = nil;
        NSString *sql = [[NSString alloc] initWithFormat:@"select id,e_name,mobile,telephone,email,title,department,company,web,fax,others,address,c_country,c_state,c_city,c_street,lastname from nameCard where typeid = 1 and accountid = %d order by id desc",[NCSingleInstant shared].uid];
        
        NSLog(@"sql:%@",sql);
        
        NSArray *arr = [db querryTable:sql];
        if((arr == nil)||([arr count]==0)){
            [myCamera setTitle:@"Scan"];
            arr = nil;
        }
        else
            [myCamera setTitle:@"Re-Scan"];
        
        d = [arr objectAtIndex:0];
        nid = [d objectForKey:@"id"];
        NCRecord *n1 = [NCRecord new];
        n1.title = @"Name:";
        NSString *str = nil;
        if([d objectForKey:@"e_name"]!=nil){
            str = [NSString stringWithFormat:@"%@ %@",[d objectForKey:@"e_name"],[d objectForKey:@"lastname"]];
            
        }
        n1.value = str;
        sql = nil;
        
        sql = [[NSString alloc] initWithFormat:@"select count(*) as num from nameCard where accountid = %d and lastname <>''",[NCSingleInstant shared].uid];
        NSArray *a = [db querryTable:sql];
        NSDictionary *d1 = [a objectAtIndex:0];
        NCRecord *n11 = [NCRecord new];
        n11.title = @"Card Num:";
        n11.value = [d1 objectForKey:@"num"];
        name = nil;
        name = [[NSArray alloc]initWithObjects:n1,n11,nil];
        
        
        NCRecord *n2 = [[NCRecord alloc]init];
        n2.title = @"Mobile:";
        n2.value = [d objectForKey:@"mobile"];
        NCRecord *n3 = [[NCRecord alloc]init];
        n3.title = @"Telephone:";
        n3.value = [d objectForKey:@"telephone"];
        NCRecord *n4 = [[NCRecord alloc]init];
        n4.title = @"Email:";
        n4.value = [d objectForKey:@"email"];
        personal = nil;
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
        company = nil;
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
        
        address = [[NSArray alloc]initWithObjects:n16,n7,n13,n14,n15,nil];
        NCRecord *n10=[[NCRecord alloc]init];
        n10.title = @"Notes:";
        n10.value = [d objectForKey:@"others"];
        others = nil;
        others = [[NSArray alloc]initWithObjects:n10, nil];
        array = nil;
        array = [NSArray arrayWithObjects:name,personal, company,address,others,nil];
        //NSLog(@"array count:%i",[array count]);
        arr = nil;
        d = nil;
    }@catch (NSException *e) {
        NSLog(@"LoadMe Error:%@",e);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    //NSLog(@"In numberOfSectionsInTableView");
    return [array count];
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    //NSLog(@"In numberOfSectionsInTableView   Section");
    NSArray *s = [array objectAtIndex:section];
    return [s count];
/*    NSInteger i;
    if(section == 0)
        i = 1;
    else
        i = 3;
    
    return 1;*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCell
    //NSLog(@"In Cell");
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    
   // NSArray *d = [array objectAtIndex:section] ;
    
    
    static NSString *GroupedTableIdentifier = @"mecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
    }
    NSArray *a = [array objectAtIndex:section];
    NCRecord *s = [a objectAtIndex:row];
    //给Label附上名称 
    cell.textLabel.text = s.title;
    cell.detailTextLabel.text = s.value;
    CGSize labelHeight = [s.value sizeWithFont:[UIFont systemFontOfSize:14.0]];
    [cell.detailTextLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [cell.detailTextLabel setNumberOfLines:ceil([self getHeight:s.value]/labelHeight.height)];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //这个方法用来告诉表格第section分组的名称
    //NSLog(@"In Section");
    NSString *tname=[caption objectAtIndex:section];
    //NSString *tname = @"OK";
    return tname;
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

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = [response expectedContentLength];
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
}
*/
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];

	HUD = nil;
}

-(void)viewDidUnload
{
    [self setMyCamera:nil];
    [self setMyTableView:nil];
    [self setMyButton:nil];
    
    name = nil;
    personal = nil;
    company = nil;
    address = nil;
    others = nil;
    caption = nil;
    db = nil;
    
    array = nil;
    
    
}
- (IBAction)pressMe:(id)sender {
    [NCSingleInstant shared].isMe=YES;
    
    [self.tabBarController setSelectedIndex:1];
    
}


- (IBAction)pressSync:(id)sender {
    RIButtonItem *cancel = [RIButtonItem item];
    cancel.label = @"Cancel";
    cancel.action = ^{
        NSLog(@"cancel Button pressed!");
    };
    
    RIButtonItem *ok = [RIButtonItem item];
    ok.label = @"OK";
    ok.action = ^{
        __block MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        //hud.labelText = @"With a block";
        
        [hud showAnimated:YES whileExecutingBlock:^{
            [self syncNameCard];
        } completionBlock:^{
            [hud removeFromSuperview];
            hud = nil;
            
        }];

    };
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Local DB will be deleted when this button is pressed.Continue?" cancelButtonItem:ok otherButtonItems:cancel, nil];
    [alert show];
    
        
               
}

-(void)syncNameCard{
    netUtils *n = [netUtils new];
    [n delNameCard];
    if(![NCSingleInstant shared].isSec){
        [n syncNameCard:[self getLastNCNum]];
    }
    n = nil;
    [self loadData];
    [self.myTableView reloadData];
}

- (NSString *)getLastNCNum
{
    NSString *r = nil;
    db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    if(db != nil){
        NSString *sql =[NSString stringWithFormat:@"select curNum from account where id = %d",[NCSingleInstant shared].uid];
        if([db openDB])
        {
            NSArray *a = [db querryTableBatch:sql];
            if((a != nil)&&([a count]>0)){
                NSDictionary *d = [a objectAtIndex:0];
                r = [d objectForKey:@"curNum"];
                d = nil;
            }   
            a = nil;
        }
        
    }
    return r;
}
@end
