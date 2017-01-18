//
//  LoginViewController.h
//  HHWT
//
//  Created by Dipin on 11/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "TextFieldValidator.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ExploreViewController.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface LoginViewController : UIViewController
{
    UIStoryboard *storyBoard;
}
@property (nonatomic, retain) NSString *imgURL;
@property (nonatomic, retain) NSString *fbID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;

@property (weak, nonatomic) IBOutlet TextFieldValidator *emailFld;
@property (weak, nonatomic) IBOutlet TextFieldValidator *passwordFld;
- (IBAction)loginBtn:(id)sender;
- (IBAction)fbBtn:(id)sender;
- (IBAction)frgtPassword:(id)sender;


@end
