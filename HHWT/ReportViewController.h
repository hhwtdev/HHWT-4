//
//  ReportViewController.h
//  
//
//  Created by sampath kumar on 25/03/16.
//
//

#import <UIKit/UIKit.h>

#define REPORT_STORYBOARD_ID @"ReportViewControllerSBID"

@interface ReportViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UITextView *txtViw;
- (IBAction)submitAction:(id)sender;
@end
