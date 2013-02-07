//
//  NCMeViewController.h
//  NameCard
//
//  Created by 杨昊 on 12-11-23.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NCRecord.h"

@interface NCMeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myCamera;

@property(strong,nonatomic) NSArray *array;
- (IBAction)pressMe:(id)sender;

- (IBAction)pressSync:(id)sender;

@end
