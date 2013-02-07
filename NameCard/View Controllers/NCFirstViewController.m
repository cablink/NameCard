//
//  NCFirstViewController.m
//  NameCard
//
//  Created by 杨昊 on 12-12-19.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import "NCFirstViewController.h"
#import "netUtils.h"

@interface NCFirstViewController ()

@end

@implementation NCFirstViewController

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
	// Do any additional setup after loading the view.
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    netUtils *n = [netUtils new];
    
    if([n checkLoginStatus])
    {
        [self performSegueWithIdentifier:@"showNameCard" sender:nil];
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    }
    n = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
