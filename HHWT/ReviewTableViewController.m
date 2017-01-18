//
//  ReviewTableViewController.m
//  HHWT
//
//  Created by Dipin on 13/06/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ReviewTableViewController.h"
#import "AppDelegate.h"
#import "VisitedPickerViewController.h"
#define showProgress(a)             [AppDelegate showProgressForState:a]


@interface ReviewTableViewController ()<UIAlertViewDelegate>
{
    NSMutableData *mutableData;
}
@end

@implementation ReviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblItem.text = _dataelement[@"name"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tap];
    
    _txtTitle.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtTitle.layer.borderWidth = 1.0f;
    
    _txtPurpose.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtPurpose.layer.borderWidth = 1.0f;
    
    _txtViewDesc.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtViewDesc.layer.borderWidth = 1.0f;
    
    _viewVisitedDate.layer.borderColor = [UIColor whiteColor].CGColor;
    _viewVisitedDate.layer.borderWidth = 1.0f;
    
    _lblItem.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblItem.layer.borderWidth = 1.0f;
    
    _btnSubmit.layer.cornerRadius = 5.0f;
    _btnSubmit.layer.masksToBounds = YES;
    
    _starView.rating = 0.0f;
    
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"Open Sans" size:22],
                                                                    NSForegroundColorAttributeName: tintColor
                                                                    };
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLogo.png"]];
    self.navigationItem.titleView = img;
    
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [self.navigationItem.titleView  setUserInteractionEnabled:YES];
    [self.navigationItem.titleView addGestureRecognizer:navSingleTap];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    UIBarButtonItem *barButtonRightItem =  [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(actionSubmit)];
    [self.navigationItem setRightBarButtonItem:barButtonRightItem];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self appDelegate].visitedDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM yyyy"];
        _lblVisitedDate.text = [formatter stringFromDate:[self appDelegate].visitedDate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navSingleTap
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSubmit
{
    if (_txtTitle.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter review Title" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
//    else if (_txtPurpose.text.length == 0) {
//       [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the purpose of the visit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//    }
    else if (_txtViewDesc.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter your review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else if ([self appDelegate].visitedDate == nil) {
       [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Visited Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else
    {
        [self sendReview];
    }
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(void)sendReview
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/insertcomments.php"];
    NSString *parameter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *startDate1 = [dateFormatter stringFromDate:[NSDate date]];
    
    parameter = [NSString stringWithFormat:@"dataelement=%@&fb_id=%@&name=%@&reviews=%@&reviewname=%@&placename=%@&rating=%@&purpose=%@&time=%@",_dataelement[@"sno"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"],_txtViewDesc.text,_txtTitle.text,_lblItem.text,[NSString stringWithFormat:@"%0.1f", _starView.rating],@"bussiness",startDate1];
    
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
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
    {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Would you like to review more places" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Yes", nil] show];
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 2) {
//        
//    }
}

- (IBAction)actionSubmit:(id)sender {
    
    if (_txtTitle.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter review Title" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    //    else if (_txtPurpose.text.length == 0) {
    //       [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the purpose of the visit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    //    }
    else if (_txtViewDesc.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter your review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else if ([self appDelegate].visitedDate == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Visited Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else
    {
        [self sendReview];
    }
}

- (IBAction)actionVisitedDate:(id)sender {
    
    VisitedPickerViewController*pic = [self.storyboard instantiateViewControllerWithIdentifier:VISITED_PICKER_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self presentViewController:pic animated:YES completion:nil];
    }else{
        [self.navigationController presentViewController:pic animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        _btnSubmit.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)actionTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
@end
