//
//  AddPlacesViewController.m
//  
//
//  Created by sampath kumar on 26/03/16.
//
//

#import "AddPlacesViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "LocationViewController.h"

@interface AddPlacesViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    BOOL isPlace1, isPlace2, isPlace3, isPlace4;
    AppDelegate *appDel;
    NSMutableData *mutableData;
    
    NSData *currentImageData;
    UIImage *defaultImage;;

    NSString *appendURL;
}

@end

@implementation AddPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Add place";

    
    appendURL = @"";
    
    appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDel.MapLatitude = @"";
    appDel.MapLongitude = @"";
    
    _txtPlaceName.layer.borderWidth = 1.0f;
    _txtPlaceName.backgroundColor = [UIColor clearColor];
    _txtPlaceName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtPlaceName.layer.cornerRadius = 5.0f;
    
    self.mapViw.layer.borderWidth = 1.5f;
    self.mapViw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mapViw.layer.cornerRadius = 5.0f;

    [self borderEffect:_btnPlace1];
    [self borderEffect:_btnPlace2];
    [self borderEffect:_btnPlace3];
    [self borderEffect:_btnPlace4];
    
    [self borderEffect:_btnFood];
    [self borderEffect:_btnThings];
    [self borderEffect:_btnPrayer];
    
    [_btnFood setBackgroundColor:THEME_COLOR];
    [_btnFood setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    defaultImage = [UIImage imageNamed:@"newAddd.png"];
    currentImageData = UIImagePNGRepresentation([UIImage imageNamed:@"newAddd.png"]);

    
}

-(void)viewWillAppear:(BOOL)animated
{
  
    
    MKCoordinateRegion region;
    CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([appDel.MapLatitude floatValue] , [appDel.MapLongitude floatValue])
                                                       altitude:0
                                             horizontalAccuracy:0
                                               verticalAccuracy:0
                                                      timestamp:[NSDate date]];
    region.center = locObj.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = 1;
    span.longitudeDelta = 1;
    region.span = span;
    [self.mapViw setRegion:region animated:YES];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake([appDel.MapLatitude floatValue], [appDel.MapLongitude floatValue]);
    [self.mapViw addAnnotation:myAnnotation];
}

-(void)borderEffect:(UIButton *)viw
{
    viw.layer.borderWidth = 1.0f;
    viw.backgroundColor = [UIColor clearColor];
    viw.layer.borderColor = THEME_COLOR.CGColor;
    viw.layer.cornerRadius = 5.0f;
    viw.layer.masksToBounds = YES;

    [viw setTitleColor:THEME_COLOR forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetPlaces
{
    isPlace1 = NO;
    isPlace2 = NO;
    isPlace3 = NO;
    isPlace4 = NO;
}

- (IBAction)btnPlaceActions:(UIButton *)sender {
    [self resetPlaces];
    if(sender.tag == 100)
    {
        isPlace1 = YES;
    }else if(sender.tag == 101)
    {
        isPlace2 = YES;
 
    }else if(sender.tag == 102)
    {
        isPlace3 = YES;

    }else if(sender.tag == 103)
    {
        isPlace4 = YES;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if(isPlace1)
    {
        [self.btnPlace1 setImage:chosenImage forState:UIControlStateNormal];
  
    }else if(isPlace2){
        [self.btnPlace2 setImage:chosenImage forState:UIControlStateNormal];

    }else if(isPlace3){
        [self.btnPlace3 setImage:chosenImage forState:UIControlStateNormal];
 
    }else if(isPlace4){
        [self.btnPlace4 setImage:chosenImage forState:UIControlStateNormal];

    }
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)resetCategory
{
    [self borderEffect:_btnFood];
    [self borderEffect:_btnThings];
    [self borderEffect:_btnPrayer];
}

- (IBAction)foodAction:(id)sender {
   
    [self resetCategory];
    
    [_btnFood setBackgroundColor:THEME_COLOR];
    [_btnFood setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)thingsAction:(id)sender {
    [self resetCategory];


    [_btnThings setBackgroundColor:THEME_COLOR];
    [_btnThings setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)prayerAction:(id)sender {
    [self resetCategory];


    [_btnPrayer setBackgroundColor:THEME_COLOR];
    [_btnPrayer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)tapAction:(id)sender {
    [_txtPlaceName resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtPlaceName resignFirstResponder];
    return YES;
}


- (IBAction)tapMapViw:(id)sender
{
    LocationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:LOCATION_STORYBOARD_ID];
    self.hidesBottomBarWhenPushed=YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)uploadImage:(UIImage *)img
{
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
   
    NSString *FileParamConstant = @"fileToUpload";
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.4);
    
    //Assuming data is not nil we add this to the multipart form
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    // set URL
    [request setURL:[NSURL URLWithString:@"http://www.rgmobiles.com/dating_webservices/get_image_url.php"]];
    
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [appendURL length]>0 ? @"," : @"",[dict valueForKey:@"image"]];
    appendURL = [appendURL stringByAppendingString:urlString];
   
}

- (IBAction)SubmitAction:(id)sender {
    
    showProgress(YES);

    NSData *data1 = UIImagePNGRepresentation(_btnPlace1.currentImage);
    if (![data1 isEqual:currentImageData])
    {
        [self uploadImage:_btnPlace1.currentImage];
    }
    
    NSData *data2 = UIImagePNGRepresentation(_btnPlace2.currentImage);
    if (![data2 isEqual:currentImageData])
    {
        [self uploadImage:_btnPlace2.currentImage];
  
    }
    
    NSData *data3 = UIImagePNGRepresentation(_btnPlace3.currentImage);
    if (![data3 isEqual:currentImageData])
    {
        [self uploadImage:_btnPlace3.currentImage];

    }
    
    NSData *data4 = UIImagePNGRepresentation(_btnPlace4.currentImage);
    if (![data4 isEqual:currentImageData])
    {
        [self uploadImage:_btnPlace4.currentImage];
     }
    
    
    if(_txtPlaceName.text.length >0 && [appDel.MapLatitude length]>0 && [appDel.MapLongitude length]>0)
    {
        [_txtPlaceName resignFirstResponder];
        showProgress(YES);
        NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/addnewplace.php"];
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"userid=%@&name=%@&location=%@&description=%@&photo=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],_txtPlaceName.text, [appDel.MapLatitude stringByAppendingString:[NSString stringWithFormat:@",%@",appDel.MapLongitude]],@"",appendURL];
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
        showProgress(NO);
        NSString *str=@"Please fill all the fields";
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
//        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Sucessfully reported!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
//        _txtPlaceName.text = @"";
//        appDel.MapLatitude = @"";
//        appDel.MapLongitude = @"";
//        appendURL = @"";
//        
//        [_btnPlace1 setImage:defaultImage forState:UIControlStateNormal];
//        [_btnPlace2 setImage:defaultImage forState:UIControlStateNormal];
//        [_btnPlace3 setImage:defaultImage forState:UIControlStateNormal];
//        [_btnPlace4 setImage:defaultImage forState:UIControlStateNormal];
        
    }else
    {
//        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    
    
    [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Sucessfully reported!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    _txtPlaceName.text = @"";
    appDel.MapLatitude = @"";
    appDel.MapLongitude = @"";
    appendURL = @"";
    
    [_btnPlace1 setImage:defaultImage forState:UIControlStateNormal];
    [_btnPlace2 setImage:defaultImage forState:UIControlStateNormal];
    [_btnPlace3 setImage:defaultImage forState:UIControlStateNormal];
    [_btnPlace4 setImage:defaultImage forState:UIControlStateNormal];
    showProgress(NO);
}



@end
