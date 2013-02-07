//
//  NCLoginViewController.m
//  NameCard
//
//  Created by 杨昊 on 13-1-19.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import "NCLoginViewController.h"
#import "NCSingleInstant.h"
#import "netUtils.h"

@interface NCLoginViewController ()

@end

@implementation NCLoginViewController
@synthesize m_Email,m_Password;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_Email.keyboardType=UIKeyboardTypeEmailAddress;
    self.m_Password.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_Email resignFirstResponder];
    [self.m_Password resignFirstResponder];
    
}
-(BOOL)checkInput
{
    if(![NCSingleInstant validateEmail:m_Email.text]){
        [NCSingleInstant alertWithMessage:@"Please input valid email address"];
        return NO;
    }
    if([m_Password.text length]<6){
        [NCSingleInstant alertWithMessage: @"Password's length should be longer than 6"];
        return NO;
    }
    return YES;
}
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

- (void)viewDidUnload {
    [self setM_Email:nil];
    [self setM_Password:nil];
    [super viewDidUnload];
}
- (IBAction)login:(id)sender {
    int r = 0;
    NSString *s = nil;
    
    if([self checkInput])
    {
        netUtils *n = [netUtils new];
        
        
        r = [n login:m_Email.text password:m_Password.text];
        
        if(r>0){
            NSLog(@"Login Success");
            sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
            s = [[NSString alloc] initWithFormat:@"select id from account where name = '%@'",m_Email.text];
            NSArray *arr = [db querryTable:s];
            s = nil;
            if((arr == nil)||([arr count]==0)){
                s = [[NSString alloc] initWithFormat:@"insert into account(name) values('%@')",m_Email.text];
                
                [db InsertTable:s];
                s = nil;
            }
            
           /* s = @"update account set status = 0";
            [db UpdataTable:s];
            s = nil;
            s = [NSString stringWithFormat:@"update account set status = 1 where name = '%@'",m_Email.text];
            NSLog(@"%@",s);
            if([db UpdataTable:s]){*/
                [NCSingleInstant shared].user = m_Email.text;
                s = [NSString stringWithFormat:@"select id from account where name = \'%@\'",m_Email.text];
                arr = [db querryTable:s];
                NSMutableDictionary *d = [arr objectAtIndex:0];
                [NCSingleInstant shared].uid = [[d objectForKey:@"id"] intValue];
                if(r == 1)
                    [NCSingleInstant shared].isSec = NO;
                else
                    [NCSingleInstant shared].isSec = YES;
                arr = nil;
                d = nil;
                NSLog(@"UID is %i",[NCSingleInstant shared].uid);
            /*
                s = @"select id,account from loginStatus";
                arr = [db querryTable:s];
                if ((arr == nil)||([arr count]==0)) {
                    s = [NSString stringWithFormat: @"insert into loginStatus(id,account,u_type) values(%i,'%@',%d)",[NCSingleInstant shared].uid,[NCSingleInstant shared].user,r];
                    [db InsertTable:s];
                }else{
                    s = [NSString stringWithFormat: @"update loginStatus set id=%d,account='%@',u_type=%d",[NCSingleInstant shared].uid,[NCSingleInstant shared].user,r];
                    [db UpdataTable:s];
                }*/
                
                db = nil;
                [NCSingleInstant setLoginInfo:[NCSingleInstant shared].uid
                                      setName:[NCSingleInstant shared].user
                                       setSec:[NCSingleInstant shared].isSec];
                [self performSegueWithIdentifier:@"showMast" sender:nil];
                [self dismissModalViewControllerAnimated:YES];
            /*
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Update table error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }*/
            
        }
    }

    
}
@end
