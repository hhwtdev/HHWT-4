//
//  ReportViewController.m
//  
//
//  Created by sampath kumar on 25/03/16.
//
//

#import "ReportViewController.h"
#import "AppDelegate.h"

@interface ReportViewController (){
    NSMutableData *mutableData;
}

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Report";
    
    _txtViw.layer.borderWidth = 1.0f;
    _txtViw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtViw.layer.cornerRadius = 5.0f;
    
    _txtViw.text = @"Write your message here...";
    _txtViw.textColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}
- (IBAction)tappedView:(id)sender {
    [_txtViw resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([_txtViw.text isEqualToString:@"Write your message here..."]){
        _txtViw.text = @"";
        _txtViw.textColor = [UIColor blackColor];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    
    if(_txtViw.text.length >0 && ![_txtViw.text isEqualToString:@"Write your message here..."])
    {
        [_txtViw resignFirstResponder];
        showProgress(YES);
        NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/reportabug.php"];
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"contents=%@",_txtViw.text];
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
    else{
        NSString *str;
        if([_txtViw.text isEqualToString:@"Write your message here..."])
            str = @"Please enter your report";
        else
            str = _txtViw.text.length == 0 ? @"Please enter your report" : @"";
        
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
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
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
    {
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Sucessfully reported!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        _txtViw.text = @"";
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}


@end
