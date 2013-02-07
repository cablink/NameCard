//
//  NCRegViewController.h
//  NameCard
//
//  Created by 杨昊 on 13-1-19.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "netUtils.h"

@interface NCRegViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *m_Email;
@property (weak, nonatomic) IBOutlet UITextField *m_Password;
@property (weak, nonatomic) IBOutlet UITextField *m_Repassword;
@property (weak, nonatomic) IBOutlet UITextField *m_sPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_sRepassword;
- (IBAction)sendRegister:(id)sender;


@end
