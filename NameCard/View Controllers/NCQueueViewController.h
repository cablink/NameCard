//
//  NCQueueViewController.h
//  NameCard
//
//  Created by 杨昊 on 12-11-18.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "EGORefreshTableHeaderView.h"

@interface NCQueueViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    BOOL isflage;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;



- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
