//
//  SignUpViewController.m
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    self.emailFld.presentInView =self.view;
    self.passwordFld.presentInView =self.view;
    [self.emailFld addRegx:REGEX_EMAIL withMsg:@"Enter Valid Email"];
    [self.passwordFld addRegx:REGEX_PASSWORD withMsg:@"Enter Password"];
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.loginLabel.text = [NSString stringWithFormat:@"Already have an account? Log In"];
    NSRange range3 = [self.loginLabel.text rangeOfString:@"Already have an account?"];
    NSRange range4 = [self.loginLabel.text rangeOfString:@" Log In"];
    NSMutableAttributedString *loginattributedText = [[NSMutableAttributedString alloc] initWithString:self.loginLabel.text];
    
    NSDictionary *attrDictDummy = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:11.0],
                                    NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                    };
    NSDictionary *attrDictLogin = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:11.0],
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:54/255.0f green:202/255.0f blue:201/255.0f alpha:1.0f]
                                    };
    [loginattributedText setAttributes:attrDictDummy
                                 range:range3];
    [loginattributedText setAttributes:attrDictLogin
                                 range:range4];
    self.loginLabel.attributedText = loginattributedText;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Sign Up with Email";
    NSDictionary *attrDictterms = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:20.0],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    [self.navigationController.navigationBar setTitleTextAttributes:attrDictterms];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"Back";
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)signupBtn:(id)sender
{
    if([self.emailFld validate] & [self.passwordFld validate])
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.emailFld.text forKey:@"REGISTRATIONEMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordFld.text forKey:@"REGISTRATIONPASSWORD"];
        
        CreateProfileViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateProfileViewController"];
        [self.navigationController pushViewController:initialVC animated:YES];
    }
}
- (IBAction)loginBtn:(id)sender
{
    LoginViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:initialVC animated:YES];

}
@end
