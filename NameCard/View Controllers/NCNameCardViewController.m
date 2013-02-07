//
//  NCNameCardViewController.m
//  NameCard
//
//  Created by 杨昊 on 13-1-22.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import "NCNameCardViewController.h"
#import "NCCardViewController.h"
#import "sqlHelp.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NCCardList.h"
#import "NCSingleInstant.h"
#import "netUtils.h"
#import "UIImageView+WebCache.h"

@interface NCNameCardViewController (){
    NSMutableArray *arr;
    NSMutableDictionary *dic;
    NSArray *searchResults;
    NSUInteger curId;
    sqlHelp *db;
    NSArray *keys;
}

@end

@implementation NCNameCardViewController
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
    // self.hidesBottomBarWhenPushed = NO;
    //self.tabBarController.tabBar.hidden = NO;
    
    arr = [[NSMutableArray alloc]init];
    dic = [[NSMutableDictionary alloc]init];
    //keys = [[NSArray alloc]init];
	// Do any additional setup after loading the view, typically from a nib.
    db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
    if(db != nil)
        [self loadData];
    if (_refreshHeaderView == nil) {
        //float h = self.myTableView.bounds.size.height;
        EGORefreshTableHeaderView *view1 =
        [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -40.0f-self.myTableView.bounds.size.height, self.myTableView.frame.size.width, self.view.bounds.size.height)];
        view1.delegate = self;
        [self.myTableView addSubview:view1];
        _refreshHeaderView = view1;
        view1=nil;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    //[self loadImage];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [NCSingleInstant shared].isMe = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    searchResults = nil;
    searchResults = [arr filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:nil];
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:@"showDetails" sender:self];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
    }
    NSArray *a = [dic objectForKey:[keys objectAtIndex:section]];
    return [a count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }else
        return [keys count];
    //return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tname = nil;
    
    if(tableView != self.searchDisplayController.searchResultsTableView){
        if(keys != nil)
            tname=[keys objectAtIndex:section];
    }
    //NSString *tname = @"OK";
    return tname;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NameCardCell";
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        //[cell set]
        NCCardList *s = [searchResults objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"System-Bold" size:14.0]];
        cell.textLabel.text = [s.name stringByAppendingFormat:@",%@",s.title];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        cell.detailTextLabel.text = s.company;
        NSString *str = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,s.thumb];
        
       
        //NSLog(@"%@",str);
        [cell.imageView setImageWithURL:[NSURL URLWithString:str]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        float sw=70/cell.imageView.image.size.width;
        float sh=50/cell.imageView.image.size.height;
        cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
        
    }else{
        if (section<[dic count]) {
            NSArray *a = [dic objectForKey:[keys objectAtIndex:section]];
            
            NCCardList *s = [a objectAtIndex:row];
            cell.textLabel.text = [s.name stringByAppendingFormat:@",%@",s.title];
            cell.detailTextLabel.text = s.company;
            NSString *str = [[NSString alloc] initWithFormat:@"%@%@",NCSERVER,s.thumb];
            
            //NSLog(@"%@",str);
            //UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:str]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            float sw=70/cell.imageView.image.size.width;
            float sh=50/cell.imageView.image.size.height;
            cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
            
        }else{
            cell.detailTextLabel.text = @"Loading data,please wait...";
            [self loadMore];
        }
    }
    
    //cell.imageView.image = [UIImage imageNamed:@"person.png"];
    return cell;
}
-(void)loadMore
{
    // Load some data here, it may take some time
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
   // NSLog(@"%d",[keys count]);
   // NSArray *k = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    return keys;
    
}


-(void)loadData
{
    NSDictionary *d = nil;
    int i = 0,j = 0;
    
    NSArray *k = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];    
    int count =[k count];
    keys = nil;
    [db openDB];
    [dic removeAllObjects];
    [arr removeAllObjects];
    for(j=0;j<count;j++)
    {
        NSString *sql = [NSString stringWithFormat:@"select id,e_name,title,company,thumb,lastname from nameCard where accountid = %d and lastname <>'' and lastname like '%@%%' order by lastname",[NCSingleInstant shared].uid,[k objectAtIndex:j]];
        //NSLog(@"%@",sql);
        NSArray *array = [db querryTableBatch:sql];
        if((array != nil)&&([array count]>0))
        {
            NSMutableArray *orderArray=[[NSMutableArray alloc]init];
            int num = [array count];
            for(i=0;i<num;i++)
            {
                d = [array objectAtIndex:i];
                NCCardList *n = [NCCardList new];
                n.index = [d objectForKey:@"id"];
                n.name = [NSString stringWithFormat:@"%@ %@",[d objectForKey:@"e_name"],[d objectForKey:@"lastname"]];
                n.title = [d objectForKey:@"title"];
                n.company =[d objectForKey:@"company"];
                n.thumb = [d objectForKey:@"thumb"];
                [arr addObject:n];
                [orderArray addObject:n];
            }
            [dic setObject:orderArray forKey:[k objectAtIndex:j]];
            orderArray = nil;
            array = nil;
            
        }
    }
    [db closeDatabase];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    
    [keyArray addObjectsFromArray:[[dic allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    keys =keyArray;
    
}
-(void)loadFinish{
    [arr removeAllObjects];
    [self loadData];
    [self.myTableView reloadData];
}

- (void)reloadTableViewDataSource{
    NSLog(@"==Begin load data");
    [self loadFinish];
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    NSLog(@"===Finish");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}

- (IBAction)logout:(id)sender {
    netUtils *n = [netUtils new];
    if([n logout]){
        [NCSingleInstant shared].uid = 0;
        [NCSingleInstant shared].user = nil;
        [NCSingleInstant shared].isMe = NO;
        [NCSingleInstant shared].isSec = NO;
        [NCSingleInstant alertWithMessage:@"Logout system success"];
        [NCSingleInstant setLoginInfo:nil setName:nil setSec:NO];
        [self performSegueWithIdentifier:@"showLogout" sender:nil];
    }
    n = nil;
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

/*
 
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 if([segue.identifier isEqualToString:@"showNCDetail"]){
 NSIndexPath *indexPath = [self.theTableView indexPathForSelectedRow];
 NCDetailViewController *d = segue.destinationViewController;
 NSLog(@"%@",[nameCard objectAtIndex:indexPath.row]);
 d.s_Name = [nameCard objectAtIndex:indexPath.row];
 d.hidesBottomBarWhenPushed = YES;
 }
 }
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NCCardList *n;
    
    if([segue.identifier isEqualToString:@"showDetails"]){
        NSIndexPath *indexPath = nil;
        //NCCardViewController *d = segue.destinationViewController;
        NCCardViewController *d=segue.destinationViewController;
        
        if([self.searchDisplayController isActive])
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            n= [searchResults objectAtIndex:indexPath.row];
            
        }
        else
        {
            indexPath = [self.myTableView indexPathForSelectedRow];
            NSUInteger section = indexPath.section;
            NSUInteger row = indexPath.row;
            NSArray *a = [dic objectForKey:[keys objectAtIndex:section]];
            n = [a objectAtIndex:row];
        }
        d.cid = n.index;
        d.hidesBottomBarWhenPushed = YES;
    }
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    arr = nil;
    searchResults = nil;
    db =nil;
    //[dic removeAllObjects];
    dic = nil;
    [super viewDidUnload];
}
@end
