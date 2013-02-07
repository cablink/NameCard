//
//  NCCardViewController.h
//  NameCard
//
//  Created by 杨昊 on 12-11-23.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "NCRecord.h"

@interface NCCardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(strong,nonatomic) NSArray *array;
@property(strong,nonatomic) NSString *cid;
- (IBAction)sendEmail:(id)sender;

@end
