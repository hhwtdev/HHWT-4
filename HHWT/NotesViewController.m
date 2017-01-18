//
//  NotesViewController.m
//  
//
//  Created by sampath kumar on 28/03/16.
//
//

#import "NotesViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhoto.h>
#import "NYTExamplePhoto.h"

@interface NotesViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
{
    NSData *currentImageData;
    UIImage *defaultImage;
    NSString *appendURL;
    NSMutableData *mutableData;
    BOOL isInitial;
}

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    appendURL = @"";

    defaultImage = [UIImage imageNamed:@"newAddd.png"];
    currentImageData = UIImagePNGRepresentation([UIImage imageNamed:@"newAddd.png"]);
    [self.btnImage setImage:defaultImage forState:UIControlStateNormal];
    isInitial = YES;
    self.btnEdit.hidden = YES;
    showProgress(YES);
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/insertnotes.php"];
    NSString *parameter;
    parameter = [NSString stringWithFormat:@"sno=%@",_sno];
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
- (IBAction)addImage:(id)sender {
    if ([_btnImage.currentImage isEqual:defaultImage]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        NSMutableArray *imgArray = [[NSMutableArray alloc] init];
            NYTExamplePhoto *photo1 = [[NYTExamplePhoto alloc] init];
            photo1.image = _btnImage.currentImage;
            [imgArray addObject:photo1];
        
        
        NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:imgArray];
        photosViewController.rightBarButtonItem = nil;
        [self presentViewController:photosViewController animated:YES completion:nil];
 
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.btnImage setImage:chosenImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)tapAction:(id)sender {
    [_txtNotes resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitt:(id)sender {
    
    showProgress(YES);
    
    NSData *data1 = UIImagePNGRepresentation(_btnImage.currentImage);
    if (![data1 isEqual:currentImageData])
    {
        [self uploadImage:_btnImage.currentImage];
    }
    
    if(_txtNotes.text.length > 0)
    {
        [_txtNotes resignFirstResponder];
        showProgress(YES);
        NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/updatenotes.php"];
        
        NSString *appendMessage = [NSString stringWithFormat:@"%@ ## %@",_txtNotes.text,appendURL];
        
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"sno=%@&notes=%@",_sno,appendMessage];
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
    NSString *urlString = [NSString stringWithFormat:@"%@",[dict valueForKey:@"image"]];
    appendURL = urlString;
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
    if(isInitial == YES)
    {
        isInitial = NO;
    }

    showProgress(NO);
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    return;
}

-(BOOL)isEmpty:(id)thing {
    return thing == nil || [(NSString *)thing isKindOfClass:[NSNull class]] || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) || ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
    {
        if(isInitial == YES)
        {
            isInitial = NO;
            if([self isEmpty:[jsonDict objectForKey:@"msg"] ])
            {
            }else{
                NSArray *arr = [[jsonDict objectForKey:@"msg"] componentsSeparatedByString:@"##"];
                _txtNotes.text = [arr objectAtIndex:0];
                
                NSString *urlStr = [[arr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
                if (img != nil) {
                    [_btnImage setImage:img forState:UIControlStateNormal];
                    self.btnEdit.hidden = NO;
                }
                
                appendURL = [arr objectAtIndex:1];
            }
        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Sucessfully Added!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
            
            //appendURL = @"";
            //_txtNotes.text = @"";
            //[_btnImage setImage:defaultImage forState:UIControlStateNormal];
            //self.btnEdit.hidden = YES;
        }
        
       
        
    }else
    {

        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}


- (IBAction)actionEdit:(id)sender {
    
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
}
@end
