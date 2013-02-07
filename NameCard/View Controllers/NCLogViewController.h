//
//  NCLogViewController.h
//  NameCard
//
//  Created by 杨昊 on 13-1-19.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCLogViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *m_Email;
@property (weak, nonatomic) IBOutlet UITextField *m_Password;
- (IBAction)login:(id)sender;

@end
