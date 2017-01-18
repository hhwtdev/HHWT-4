//
//  FeedBackViewController.h
//  
//
//  Created by sampath kumar on 25/03/16.
//
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

#define FEED_BACK_STORYBOARD_ID @"FeedBackViewControllerSBID"

@interface FeedBackViewController : HHWTViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtView;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingsView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)actionYes:(id)sender;
- (IBAction)actionNo:(id)sender;
- (IBAction)actionSubmit:(id)sender;

@end
