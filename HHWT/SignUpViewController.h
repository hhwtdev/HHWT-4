//
//  SignUpViewController.h
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TextFieldValidator.h"
#import "CreateProfileViewController.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet TextFieldValidator *emailFld;
@property (weak, nonatomic) IBOutlet TextFieldValidator *passwordFld;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
- (IBAction)signupBtn:(id)sender;
- (IBAction)loginBtn:(id)sender;

@end
