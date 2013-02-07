//
//  NCImageViewController.m
//  NameCard
//
//  Created by 杨昊 on 13-1-22.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import "NCImageViewController.h"
#import "UIImage+scale.h"
@interface NCImageViewController (){
    UIImageView *first;
    UIImageView *second;
}

- (void)loadVisiblePage;
@end

@implementation NCImageViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize photoList;

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
    CGSize size = self.view.frame.size;
    //NSInteger pageCount = self.photoList.count;
   /* self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.frame = CGRectMake(0,420,320,480);
    [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];*/
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = CGRectMake(0, 0, size.width,size.height);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if([self.photoList count]==2)
    {
        self.scrollView.showsVerticalScrollIndicator = YES;
        //self.scrollView.showsHorizontalScrollIndicator =YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.pagingEnabled = YES;
    }
    self.scrollView.bounces = YES;
    
    //self.scrollView.backgroundColor =   [UIColor whiteColor];
    
    //for (NSInteger i=0; i<pageCount; i++) {
              //  UIImage *m = [self.photoList objectAtIndex:i]
     //   NSLog(@"%f,%f",[m);
        first = [[UIImageView alloc] initWithImage:[self.photoList objectAtIndex:0]];
        first.contentMode = UIViewContentModeScaleAspectFit;
        
        first.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)];
        [first addGestureRecognizer:singleTap];
        [self.scrollView addSubview:first];
        singleTap = nil;
        if([self.photoList count]==2)
        {
            
            second = [[UIImageView alloc] initWithImage:[self.photoList objectAtIndex:1]];
            second.contentMode = UIViewContentModeScaleAspectFit;
            
            second.userInteractionEnabled = YES;
            singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)];
            [second addGestureRecognizer:singleTap];
            //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height);
            [self.scrollView addSubview:second];

        }
        
    //}
    [self.view addSubview:scrollView];
    //[self.view addSubview:pageControl];
}

-(void)clickImage
{
    //NSLog(@"aaa");
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGSize PagedScrollViewSize = self.scrollView.frame.size;
    // 设置scroll view的contentSize属性，这个是包含所有页面的scroll view的尺寸
    self.scrollView.contentSize = CGSizeMake(PagedScrollViewSize.width * self.photoList.count, PagedScrollViewSize.height);
    CGRect frame;
    frame.origin.x = 0 ;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    frame = CGRectInset(frame, 10.0f, 10.0f);
    first.frame = frame;
    
    if([self.photoList count]==2)
    {
        
        frame.origin.x = self.scrollView.frame.size.width ;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        frame = CGRectInset(frame, 10.0f, 10.0f);
        second.frame = frame;
    }
    //NSLog(@"Appear:width:%f  hight:%f",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    
}

- (void)loadVisiblePage{
    
    //CGFloat pageWidth = self.scrollView.frame.size.width;
   // NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    
    //self.pageControl.currentPage = page;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 在屏幕上加载特定页面
    //[self loadVisiblePage];
}

/*
-(void)changePage:(id)sender {
    
    int page = self.pageControl.currentPage;
    
    [self.scrollView setContentOffset:CGPointMake(300 * page, 0)];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation duration:(NSTimeInterval)duration {
    CGRect frame;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //self.scrollView.showsHorizontalScrollIndicator =YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = NO;

    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        frame = CGRectInset(frame, 10.0f, 10.0f);
        //first.contentMode = UIViewContentModeScaleAspectFit;
        first.frame = frame;
        
        if([self.photoList count]==2)
        {
            
            frame.origin.x = self.scrollView.frame.size.width;
            frame.origin.y = 0;
            frame.size = self.scrollView.frame.size;
            frame = CGRectInset(frame, 10.0f, 10.0f);
            //second.contentMode = UIViewContentModeScaleAspectFit;
            second.frame = frame;
            self.scrollView.showsVerticalScrollIndicator = YES;
            //self.scrollView.showsHorizontalScrollIndicator =YES;
            self.scrollView.scrollEnabled = YES;
            self.scrollView.pagingEnabled = YES;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height);
            // NSLog(@"Scroll Portrait width:%f high:%f",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
            //NSLog(@"second Portrait width:%f high:%f",second.frame.size.width,second.frame.size.height);
        }
    } else {
        frame.origin.y = 0;
        frame.origin.x = 0;
        //frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        //frame = CGRectInset(frame, 10.0f, 0.0f);
        self.scrollView.frame = frame;
        
        //NSLog(@"scroll width:%f",self.scrollView.frame.size.width);
        //NSLog(@"content width:%f",self.scrollView.contentSize.width);
        frame.origin.y = 0;
        frame.origin.x = 0;
        //frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        //first = [[UIImageView alloc] initWithImage:[self.photoList objectAtIndex:0]];
        //first.contentMode = UIViewContentModeScaleAspectFill;
        first.frame = frame;
        //NSLog(@"Scroll Landscape X:%f width:%f",first.frame.origin.x,first.frame.size.width);
        //NSLog(@"Scroll Landscape Y:%f high:%f",first.frame.origin.y,first.frame.size.height);
        
        if([self.photoList count]==2)
        {
            frame.origin.x = self.scrollView.frame.size.width;
            frame.origin.y = 0;
            frame.size = self.scrollView.frame.size;
            frame = CGRectInset(frame, 10.0f, 0.0f);
            
            //second = [[UIImageView alloc] initWithImage:[self.photoList objectAtIndex:1]];
            //second.contentMode = UIViewContentModeScaleAspectFill;
            second.frame = frame;
            //NSLog(@"Scroll Landscape X:%f width:%f",self.scrollView.frame.origin.x,self.scrollView.frame.size.width);
            //NSLog(@"Scroll Landscape Y:%f high:%f",self.scrollView.frame.origin.y,self.scrollView.frame.size.height);
            self.scrollView.showsVerticalScrollIndicator = YES;
            //self.scrollView.showsHorizontalScrollIndicator =YES;
            self.scrollView.scrollEnabled = YES;
            self.scrollView.pagingEnabled = YES;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height);
        }
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload
{
    self.pageControl = nil;
    self.scrollView = nil;
    self.photoList = nil;
}
@end
