//
//  NCRegViewController.m
//  NameCard
//
//  Created by 杨昊 on 13-1-19.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import "NCRegViewController.h"

@interface NCRegViewController ()

@end

@implementation NCRegViewController
@synthesize m_Email,m_Password,m_Repassword,m_sPassword,m_sRepassword;

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
    self.m_Repassword.secureTextEntry = YES;
    self.m_sPassword.secureTextEntry = YES;
    self.m_sRepassword.secureTextEntry = YES;
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
    [self.m_Repassword resignFirstResponder];
    [self.m_sPassword resignFirstResponder];
    [self.m_sRepassword resignFirstResponder];
}

-(void)cleanInput
{
    m_Email.text = @"";
    m_Password.text = @"";
    m_Repassword.text = @"";
    m_sPassword.text = @"";
    m_sRepassword.text= @"";
    
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
    if(![m_Password.text isEqualToString:m_Repassword.text]){
        [NCSingleInstant alertWithMessage:@"Password cannot be different"];
        return NO;
    }
    return YES;
}
- (IBAction)sendRegister:(id)sender
{
    BOOL r = YES;
    if([self checkInput])
    {
        netUtils *n = [netUtils new];
        
        if([m_sPassword.text length]>5){
            r = [n regist:m_Email.text password:m_Password.text spassword:m_sPassword.text];
        }else{
            r = [n regist:m_Email.text password:m_Password.text spassword:nil];
        }
        if(r){
            NSLog(@"Register Success");
            sqlHelp *db = [[sqlHelp alloc] initWithDbName:[NCSingleInstant shared].dbpath];
            NSString *s = [[NSString alloc] initWithFormat:@"insert into account(name) values(\'%@\')",m_Email.text];
            NSLog(@"%@",s);
            if(![db InsertTable:s]){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register" message:@"Insert table error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            db = nil;
            [self cleanInput];
            
        }
    }
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
    [self setM_Repassword:nil];
    [self setM_sPassword:nil];
    [self setM_sRepassword:nil];
   
    [super viewDidUnload];
}

@end
