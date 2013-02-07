//
//  NCCameraController.h
//  NameCard
//
//  Created by 杨昊 on 12-11-18.
//  Copyright (c) 2012年 杨昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"


@interface NCCameraController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *picker;
    //ASIFormDataRequest *request;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (assign, nonatomic) CGRect imageFrame;
@property (strong,nonatomic) NSNumber *isMe;

- (IBAction)btnCancel:(id)sender;

- (IBAction)btnBack:(id)sender;


- (IBAction)btnFinish:(id)sender;
@end
