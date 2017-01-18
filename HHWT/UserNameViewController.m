//
//  UserNameViewController.m
//  HHWT
//
//  Created by SYZYGY on 05/12/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "UserNameViewController.h"


@interface UserNameViewController ()

@end

@implementation UserNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Create Your Profile";
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

- (IBAction)nextBtn:(id)sender
{
    if (self.usernameFld.text.length !=0)
    {
        [self.view endEditing:YES];
        showProgress(YES);
        NSString *emailTxt =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"REGISTRATIONEMAIL"]];
        NSString *passwordTxt =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"REGISTRATIONPASSWORD"]];
        NSString *nameTxt =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"REGISTRATIONNAME"]];
        NSString *usernameTxt =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:self.usernameFld.text]];
       
        NSString *urlString;
        NSString *parameter;
        
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/registernewnov.php"];
        parameter = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&country=%@",nameTxt,emailTxt,passwordTxt,usernameTxt];
        
        NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:parameterData];
        registrationConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( registrationConnection )
        {
            mutRegistrationData = [[NSMutableData alloc] init];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *txtStr = textField.text;
    if (txtStr.length ==3 || txtStr.length ==6 || txtStr.length ==8 || txtStr.length ==10 || txtStr.length ==13 || txtStr.length ==16 || txtStr.length ==18 || txtStr.length ==20)
    {
        @try
        {
            NSString * urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/usernamecheck.php"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            NSString *postString = [NSString stringWithFormat:@"username=%@",textField.text];
            NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
            if (data)
            {
                [request setHTTPBody:data];
                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
                
                usernameConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                if( usernameConnection )
                {
                    mutUsernameData = [[NSMutableData alloc] init];
                }
            }
            else
            {
                NSLog(@"Empty Data");
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception %@",exception.reason);
        }
    }
    else if(txtStr.length >3)
    {
        
    }
    else
    {
        self.msgLabel.text =@"Username can't have spaces or special characters";
        self.msgLabel.textColor =[UIColor blackColor];
        self.msgImage.image =[UIImage imageNamed:@""];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <=4)
    {
        self.msgLabel.text =@"Username can't have spaces or special characters";
        self.msgLabel.textColor =[UIColor blackColor];
        self.msgImage.image =[UIImage imageNamed:@""];
    }
}
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if([connection isEqual:usernameConnection])
    {
        @try
        {
             [mutUsernameData setLength:0];
            
        } @catch (NSException *exception)
        {
            NSLog(@"Exception %@",exception.reason);
        }
    }
    else
    {
        [mutRegistrationData setLength:0];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if([connection isEqual:usernameConnection])
    {
        @try
        {
            [mutUsernameData appendData:data];
            
        } @catch (NSException *exception)
        {
            NSLog(@"Exception %@",exception.reason);
        }
    }
    else
    {
        [mutRegistrationData appendData:data];
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    showProgress(NO);
    
    return;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([connection isEqual:usernameConnection])
    {
        @try
        {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:mutUsernameData options: NSJSONReadingMutableContainers error: nil];
            if(jsonObject)
            {
                NSString *jsonStr =[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"msg"]];
                if ([jsonStr isEqualToString:@"username available"])
                {
                    self.msgImage.image =[UIImage imageNamed:@"green.jpeg"];
                    self.msgLabel.text =@"Username is available";
                    self.msgLabel.textColor =[UIColor greenColor];
                }
                else if ([jsonStr isEqualToString:@"username not available"])
                {
                    self.msgLabel.text =@"Username already exists";
                    self.msgLabel.textColor =[UIColor redColor];
                    self.msgImage.image =[UIImage imageNamed:@"float.png"];
                }
            }
            else
            {
                self.msgLabel.text =@"Username already exists";
                self.msgLabel.textColor =[UIColor redColor];
                self.msgImage.image =[UIImage imageNamed:@"float.png"];
            }
        } @catch (NSException *exception)
        {
            NSLog(@"Excepttion %@",exception.reason);
        }
    }
    else
    {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:mutRegistrationData options: NSJSONReadingMutableContainers error: nil];
        showProgress(NO);
        
        if(jsonObject)
        {
            if([[jsonObject objectForKey:@"status"] integerValue] == 1)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserProfilePic"];
                [[NSUserDefaults standardUserDefaults] setValue:@"Local" forKey:@"LoginFrom"];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"REGISTRATIONPASSWORD"]] forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"email"] forKey:@"UserEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"name"] forKey:@"UserName"];
                [[NSUserDefaults standardUserDefaults] setValue:jsonObject[@"email"] forKey:@"UserID"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISUserLogined"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT" message:@"User Registered Successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
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
    }
}


@end
