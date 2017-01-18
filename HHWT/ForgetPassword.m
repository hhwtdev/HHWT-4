//
//  ForgetPassword.m
//  HHWT
//
//  Created by SampathKumar on 18/09/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ForgetPassword.h"
#import "AppDelegate.h"

@interface ForgetPassword ()<UITextFieldDelegate>{
    NSMutableData *mutRegisterData;
    NSURLConnection *registration;
}

@end

@implementation ForgetPassword

- (void)viewDidLoad
{
    self.title =@"Forgot Password";
    self.txtField.presentInView =self.view;
    [self.txtField addRegx:REGEX_EMAIL withMsg:@"Enter Valid Email"];
    
    [super viewDidLoad];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    return YES;
}

- (IBAction)btnAction:(id)sender
{
    if([self.txtField validate])
    {
        showProgress(YES);
        
        NSString *urlString;
        NSString *parameter;
        
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/forgotpasswordhhwt.php"];
        parameter = [NSString stringWithFormat:@"emailid=%@",_txtField.text];
        
        NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:parameterData];
        registration = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( registration )
        {
            mutRegisterData = [[NSMutableData alloc] init];
        }
    }
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutRegisterData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [mutRegisterData appendData:data];
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    showProgress(NO);
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    _txtField.text = @"";
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:mutRegisterData options: NSJSONReadingMutableContainers error: nil];
    showProgress(NO);
    
    if([[jsonObject valueForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [[[UIAlertView alloc] initWithTitle:@"Info" message:[jsonObject valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Info" message:[jsonObject valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
}


@end
