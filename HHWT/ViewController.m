//
//  ViewController.m
//  HHWT
//
//  Created by  kumar on 03/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    NSMutableData *mutableData;
    UIStoryboard *storyBoard;
    BOOL isAlreadyLogin;
}
@end

@implementation ViewController


- (void)viewDidLoad
{
    self.termsOfServiceLabel.text = [NSString stringWithFormat:@"By signing up, you agree to our Terms Of Use"];
    NSRange range1 = [self.termsOfServiceLabel.text rangeOfString:@"By signing up, you agree to our"];
    NSRange range2 = [self.termsOfServiceLabel.text rangeOfString:@"Terms Of Use"];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.termsOfServiceLabel.text];
    NSDictionary *attrDictterms = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0],
                                    NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                    };
    [attributedText setAttributes:attrDictterms
                            range:range1];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0]}
                            range:range2];
    self.termsOfServiceLabel.attributedText = attributedText;
    
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
    
    
    [super viewDidLoad];
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

    [super viewWillAppear:YES];

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ISUserLogined"] == YES)
    {
        isAlreadyLogin = YES;
        [self moveToHome];
    }
    else
    {
        isAlreadyLogin = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
   self.navigationItem.title = @"Back";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectWithFb:(id)sender
{
    showProgress(YES);
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
     
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_birthday"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             showProgress(NO);
             NSLog(@"Process error %@",error.localizedDescription);
         }
         else if (result.isCancelled)
         {
             showProgress(NO);
             NSLog(@"Cancelled");
         }
         else
         {
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 NSLog(@"result is:%@",result);
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture.type(large), email, name, id, gender, birthday"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id fbResult, NSError *error)
                      {
                          if (!error)
                          {
                              [[NSUserDefaults standardUserDefaults] setValue:fbResult[@"email"] forKey:@"UserEmail"];
                              [[NSUserDefaults standardUserDefaults] setValue:fbResult[@"first_name"] forKey:@"UserName"];
                              NSDictionary *picture =fbResult[@"picture"];
                              NSDictionary *data = picture[@"data"];
                              [[NSUserDefaults standardUserDefaults] setValue:fbResult[@"id"] forKey:@"UserID"];
                              [[NSUserDefaults standardUserDefaults] setValue:data[@"url"] forKey:@"UserProfilePic"];
                              [[NSUserDefaults standardUserDefaults] setValue:@"Facebook" forKey:@"LoginFrom"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                              _email = fbResult[@"email"];
                              _name = fbResult[@"first_name"];
                              _fbID = fbResult[@"id"];
                              _imgURL = data[@"url"];
                              [self registrationUserInfo];
                          }
                          else
                          {
                              NSLog(@"Process error %@",error.localizedDescription);
                          }
                      }];
                 }
                
             }
         }
     }];
    
}

-(void)registrationUserInfo
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/testingregisterfacebook.php"];
    NSString *parameter = [NSString stringWithFormat:@"fb_id=%@&name=%@&email=%@&imgurl=%@",_fbID,_name,_email,_imgURL];
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( connection )
    {
        mutableData = [[NSMutableData alloc] init];
    }
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    showProgress(NO);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[responseStringWithEncoded dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    if(jsonObject)
    {
        if([[jsonObject objectForKey:@"status"] integerValue] == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT" message:[jsonObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            alert.tag = [[jsonObject objectForKey:@"status"] integerValue];
            [alert show];
            [self setInitialScreen];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT" message:[jsonObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            alert.tag = [[jsonObject objectForKey:@"status"] integerValue];
            [alert show];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Registration Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISUserLogined"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self moveToHome];
        }
    }
}

-(void)moveToHome
{
    if (isAlreadyLogin)
    {
        [self setInitialScreen];
    }
    else
    {
        isAlreadyLogin = YES;
    }
}
-(void)setInitialScreen
{
    UITabBarController *tabb = [storyBoard instantiateViewControllerWithIdentifier:@"tabbarSBID"];
    self.navigationController.navigationBarHidden = TRUE;
    [self.navigationController pushViewController:tabb animated:YES];
}

- (IBAction)signupwithEmail:(id)sender
{
    SignUpViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:initialVC animated:YES];
}

- (IBAction)termsofUseBtn:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *destNav = [story instantiateViewControllerWithIdentifier:@"PrivacyViewController"];    PrivacyViewController *privacy = (PrivacyViewController *)destNav.viewControllers[0];
    privacy.preferredContentSize = CGSizeMake(self.view.frame.size.width - 60,self.view.frame.size.height - 100);
    destNav.modalPresentationStyle = UIModalPresentationFormSheet;
    _dateTimePopover8 = destNav.popoverPresentationController;
    _dateTimePopover8.delegate = self;
    _dateTimePopover8.sourceView = self.view;
    _dateTimePopover8.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    _dateTimePopover8.sourceRect = CGRectMake(30, 50, 280, 400);
    [self presentViewController:destNav animated:YES completion:nil];
}

- (IBAction)loginBtn:(id)sender
{
     [self performSegueWithIdentifier:@"toLogin" sender:nil];
}
@end
