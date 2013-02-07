//
//  NCQueueViewController.m
//  NameCard
//
//  Created by 杨昊 on 12-11-18.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "NCQueueViewController.h"
#import "sqlHelp.h"
#import "NCSingleInstant.h"
#import "NCQElement.h"
#import "netUtils.h"


@interface NCQueueViewController (){
    NSMutableArray *tasks;
    sqlHelp *db;
    //NSString* curid;
}
@end

@implementation NCQueueViewController
@synthesize myTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)checkImageExists
{
    NSString *s = @"select f_page from picture";
    NSArray *arr = [db querryTable:s];
    BOOL b;
    for(NSDictionary *item in arr)
    {
        b=[[NSFileManager defaultManager] fileExistsAtPath:[item objectForKey:@"f_page"]];
        if(b)
            NSLog(@"OK:%@",[item objectForKey:@"f_page"]);
        else
            NSLog(@"Cannot find %@",[item objectForKey:@"f_page"]);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    tasks = [[NSMutableArray alloc]init];
    //self.hidesBottomBarWhenPushed = NO;
    //self.tabBarController.tabBar.hidden = NO;
    //curid = @"0";
    
    db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    if (_refreshHeaderView == nil) {
        //float h = self.myTableView.bounds.size.height;
        EGORefreshTableHeaderView *view1 =
        [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -self.myTableView.bounds.size.height, self.myTableView.frame.size.width, self.view.bounds.size.height)];
        view1.delegate = self;
        [self.myTableView addSubview:view1];
        _refreshHeaderView = view1;
        view1=nil;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData
{
    @try{
        NSDictionary *d = nil;
        int i = 0;
        
        NSString *sql = [[NSString alloc] initWithFormat:@"select id,requestid,status,description,thumb from picture where accountid = %d and status <>1 order by id",[NCSingleInstant shared].uid];
        NSLog(@"%@",sql);
        NSArray *array = [db querryTable:sql];
        int num = [array count];
        for(i=0;i<num;i++)
        {
            d = [array objectAtIndex:i];
            NCQElement *n = [NCQElement new];
            
                
            n.pid=[d objectForKey:@"id"];
            n.rid = [d objectForKey:@"requestid"];;
            n.status = [d objectForKey:@"status"];
            
            n.desc =[d objectForKey:@"description"];
            //NSLog(@"%@",n.desc);
            n.thumb = [d objectForKey:@"thumb"];
            //NSLog(@"%@",n.thumb);
            [tasks insertObject:n atIndex:0];
            
            /*if(i ==num-1)
                curid = n.pid;*/
        }
        d = nil;
        array = nil;
    }@catch (NSException *e) {
        NSLog(@"Queue LoadData:%@",e);
    }
}
#pragma mark - Table view data source

-(void)viewWillAppear:(BOOL)animated{
    @try{
    [NCSingleInstant shared].isMe = NO;
    [tasks removeAllObjects];
    [self loadData];
    [self.myTableView reloadData];
    }@catch (NSException *e) {
        NSLog(@"Queue appear:%@",e);
    }
    // [self checkImageExists];
}

-(void)requestServer
{
    netUtils *n = [[netUtils alloc] init];
    [n checkImageStatus];
    n = nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    //NSLog(@"in section");
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QueueCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSLog(@"in Cell");
    @try{
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NCQElement *n=[tasks objectAtIndex:indexPath.row];
    int i = [n.status intValue];
    if(i == 0)
        cell.textLabel.text =@"Processing by server";
    else if(i == 1)
        cell.textLabel.text =@"Success";
    else if(i == -1)
        cell.textLabel.text = @"Sending images to server...";
    else
        cell.textLabel.text = n.desc;
    
    NSData *img = [NSData dataWithContentsOfFile:n.thumb];
   // UIImage *image = [UIImage imageNamed:n.thumb];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = [UIImage imageWithData:img];
   /* CGSize viewSize = image.size;
    NSLog(@"Heigh:%f  Width:%f",viewSize.height,viewSize.width);
    CGAffineTransform rotate = CGAffineTransformMakeRotation( -90.0 / 180.0 * 3.14 );
    [cell.imageView setTransform:rotate];*/
    float sw=50/cell.imageView.image.size.width;
    float sh=50/cell.imageView.image.size.height;
    cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
    }@catch (NSException *e) {
        NSLog(@"Queue cell:%@",e);
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)reloadTableViewDataSource{
    NSLog(@"Begin reload data");
    //[tasks insertObject:@"Please wait..." atIndex:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestServer];
        [tasks removeAllObjects];
        [self loadData];
        
    });
    
    
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    NSLog(@"End reload data");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
     /*[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateStyle:NSDateFormatterShortStyle];
     [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
     
     NSString *s = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
     
     [arr insertObject:s atIndex:0];*/
     [self.myTableView reloadData];
    
    return [NSDate date];
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    tasks = nil;
    [super viewDidUnload];
}
@end
