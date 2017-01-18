//
//  PickerViewController.m
//  HHWT
//
//  Created by sampath kumar on 06/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "PickerViewController.h"
#import "AppDelegate.h"
@interface PickerViewController ()
{
    NSDate *selectedDate;
    AppDelegate *appdel;
}

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.lblDate.frame.size.height - 1.2, self.lblDate.frame.size.width, 1.2f);
    bottomBorder.backgroundColor = THEME_COLOR.CGColor;
    [self.lblDate.layer addSublayer:bottomBorder];

    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    if(appdel.startDate)
    {
        [_datePicker setMinimumDate:appdel.startDate];
    }
    
}

- (IBAction)selectedDate:(id)sender {
    selectedDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.lblDate.text = formatedDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
    if(_isTourPicker)
    {
        appdel.selectedTourDate = selectedDate;
  
    }else{
        appdel.selectedDate = selectedDate;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancel:(id)sender {
    if(_isTourPicker)
    {
        appdel.selectedTourDate = selectedDate;
    }else
    {
        appdel.selectedDate = selectedDate;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
