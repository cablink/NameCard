//
//  NCImageViewController.h
//  NameCard
//
//  Created by 杨昊 on 13-1-22.
//  Copyright (c) 2013年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCImageViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *photoList;
@end
