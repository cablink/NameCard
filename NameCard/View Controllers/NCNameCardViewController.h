//
//  NCNameCardViewController.h
//  NameCard
//
//  Created by 杨昊 on 13-1-22.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"


@interface NCNameCardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    BOOL isflage;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (IBAction)logout:(id)sender;


@end
