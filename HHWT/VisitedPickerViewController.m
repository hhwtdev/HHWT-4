//
//  VisitedPickerViewController.m
//  HHWT
//
//  Created by Dipin on 14/06/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "VisitedPickerViewController.h"
#import "AppDelegate.h"

@interface VisitedPickerViewController ()
{
    NSDate *selectedDate;
    AppDelegate *appdel;
}

@end

@implementation VisitedPickerViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.lblDate.frame.size.height - 1.2, self.lblDate.frame.size.width, 1.2f);
    bottomBorder.backgroundColor = THEME_COLOR.CGColor;
    [self.lblDate.layer addSublayer:bottomBorder];
    
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if(appdel.visitedDate)
    {
        [_datePicker setMinimumDate:appdel.visitedDate];
    }
    
}

- (IBAction)selectedDate:(id)sender {
    selectedDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.lblDate.text = formatedDate;
}


- (IBAction)done:(id)sender {
    appdel.visitedDate = selectedDate;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancel:(id)sender {
    appdel.visitedDate = selectedDate;
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
