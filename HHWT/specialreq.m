//
//  specialreq.m
//  HHWT
//
//  Created by Govind on 23/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//
#import "specialreq.h"
#import "TourDetailModel.h"
#import "HomeViewController.h"
#import "ToursViewController.h"



@interface specialreq ()
{
    
}


@end

@implementation specialreq

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLogo.png"]];
    self.navigationItem.titleView = img;
    
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    _myTextView.layer.borderColor = borderColor.CGColor;
    _myTextView.layer.borderWidth = 1.0;
    _myTextView.layer.cornerRadius = 5.0;
    
    
    _myTextView.delegate = self;
    _myTextView.text = @"Special Request...";
    _myTextView.textColor = [UIColor lightGrayColor];
    
}





- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Special Request..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Special Request...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (IBAction)special:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT"
                                                    message:@"Thanks for your information. The tour operator will contact you via Email shortly!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        //NSLog(@"cancel");
        
        ToursViewController *dis = [self.storyboard instantiateViewControllerWithIdentifier:home];
        //dis.selectedTour = _selectedTour;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OK works" message:@"no error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}



#pragma mark - UICollectionViewDataSource methods

@end