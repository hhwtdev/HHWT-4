//
//  LoginViewController.m
//  HHWT
//
//  Created by Dipin on 11/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "HomeViewController.h"
#import "PrivacyViewController.h"
#import "AppDelegate.h"
#import "PopView.h"
#import "ForgetPassword.h"
#import <MessageUI/MessageUI.h>

#define showProgress(a)             [AppDelegate showProgressForState:a]

@interface LoginViewController ()
{
    NSMutableData *mutLoginData;
    NSURLConnection *login;
    NSURLConnection *fbLogin;
    
}
@end

@implementation LoginViewController

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Log In to Account";
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
-(void)doLogin
{
    NSString *urlString;
    NSString *parameter;
    
    urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/testingloginnew.php"];
    parameter = [NSString stringWithFormat:@"email=%@&password=%@",self.emailFld.text,self.passwordFld.text];
    
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    login = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( login )
    {
        mutLoginData = [[NSMutableData alloc] init];
    }
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutLoginData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutLoginData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    showProgress(NO);

    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == fbLogin)
    {
        NSString *responseStringWithEncoded = [[NSString alloc] initWithData:mutLoginData encoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[responseStringWithEncoded dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        if(jsonObject)
        {
            if([[jsonObject objectForKey:@"status"] integerValue] == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT" message:[jsonObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                alert.tag = [[jsonObject objectForKey:@"status"] integerValue];
                [alert show];
                
                UITabBarController *tabb = [storyBoard instantiateViewControllerWithIdentifier:@"tabbarSBID"];
                self.navigationController.navigationBarHidden = TRUE;
                [self.navigationController pushViewController:tabb animated:YES];
                
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
    else
    {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:mutLoginData options: NSJSONReadingMutableContainers error: nil];
        showProgress(NO);
        
        if(jsonObject)
        {
            if([[jsonObject objectForKey:@"status"] integerValue] == 1)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserProfilePic"];
                [[NSUserDefaults standardUserDefaults] setValue:@"Local" forKey:@"LoginFrom"];
                [[NSUserDefaults standardUserDefaults] setValue:self.passwordFld.text forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"email"] forKey:@"UserEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"name"] forKey:@"UserName"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"phonenumber"] forKey:@"PhoneNumber"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"country"] forKey:@"Country"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"dob"] forKey:@"DOB"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"email"] forKey:@"UserID"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISUserLogined"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Successfully Logged In" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                alert.tag = [[jsonObject objectForKey:@"status"] integerValue];
                [alert show];
                
                UITabBarController *tabb = [storyBoard instantiateViewControllerWithIdentifier:@"tabbarSBID"];
                self.navigationController.navigationBarHidden = TRUE;
                [self.navigationController pushViewController:tabb animated:YES];
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
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        }
    }
    
}



- (IBAction)loginBtn:(id)sender
{
    if([self.emailFld validate] & [self.passwordFld validate])
    {
       showProgress(YES);
       [self doLogin];
    }
}

- (IBAction)fbBtn:(id)sender
{
    showProgress(YES);
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_birthday"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
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
                              [self fbLogin];
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
-(void)fbLogin
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/testingregisterfacebook.php"];
    NSString *parameter = [NSString stringWithFormat:@"fb_id=%@&name=%@&email=%@&imgurl=%@",_fbID,_name,_email,_imgURL];
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    fbLogin = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( fbLogin )
    {
        mutLoginData = [[NSMutableData alloc] init];
    }
}
- (IBAction)frgtPassword:(id)sender
{
    ForgetPassword *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordSBID"];
    [self.navigationController pushViewController:initialVC animated:YES];
}


@end
