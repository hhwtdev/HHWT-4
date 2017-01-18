//
//  ViewController.h
//  HHWT
//
//  Created by  kumar on 03/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "PrivacyViewController.h"
#import "PopView.h"

@interface ViewController : UIViewController<UIPopoverPresentationControllerDelegate,PopViewDelegate>

@property (nonatomic, retain) NSString *imgURL;
@property (nonatomic, retain) NSString *fbID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;


- (IBAction)signupwithEmail:(id)sender;
- (IBAction)termsofUseBtn:(id)sender;
- (IBAction)loginBtn:(id)sender;
@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;
@property (weak, nonatomic) IBOutlet UILabel *termsOfServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end

